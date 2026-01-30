GO

if not exists(select * from Teaching where section_id = 11)
BEGIN
    insert into Teaching(section_id, instructor_id, role) VALUES
    (11, 'I009', 'Lecturer')
END

-- 1. 
-- 1.	Extract the names and salary (after a 10% increase) of the instructors teaching the course CS07. 
-- (Note: Students insert appropriate sample data to test the query
GO
create or alter function fn_GetInstructorSalaryByCourse(@course_id varchar(9))
RETURNS TABLE
AS
return (
    select i.instructor_name, cast(i.salary * 1.1 as int) as newSalary
    from Instructor i
    join Teaching t on t.instructor_id = i.instructor_id
    join Section s on s.section_id = t.section_id
    where s.course_id = @course_id
)

select * from dbo.fn_GetInstructorSalaryByCourse('CS07')

-- 2.	Retrieve the instructors and their teaching courses with the role "lecturer". The result should be sorted first by department name and then alphabetically by instructor name.

GO
create or alter PROCEDURE sp_GetLecturerCourses
AS
BEGIN
    select distinct i.instructor_name, d.department_name ,c.course_name
    from Instructor i
    join Teaching t on i.instructor_id = t.instructor_id
    join Section s on s.section_id = t.section_id
    join Course c on c.course_id = s.course_id
    join Department d on d.department_id = c.department_id
    where t.role = 'Lecturer'
    ORDER BY d.department_name asc, i.instructor_name ASC
END

exec sp_GetLecturerCourses
go
CREATE or ALTER PROCEDURE sp_GetSpecialStudents
AS
BEGIN
    -- Điều kiện 1: Sinh viên học môn do khoa khác quản lý
    SELECT DISTINCT st.student_id, st.student_name, 'Cross-Department' AS Reason
    FROM Student st
    JOIN GradeReport g ON st.student_id = g.student_id
    JOIN Section s ON g.section_id = s.section_id
    JOIN Course c ON s.course_id = c.course_id
    WHERE st.department_id <> c.department_id

    UNION

    -- Điều kiện 2: Điểm cao nhất môn Databases, Spring 2022
    SELECT st.student_id, st.student_name, 'Highest Grade DB Spring 22' AS Reason
    FROM Student st
    JOIN GradeReport g ON st.student_id = g.student_id
    JOIN Section s ON g.section_id = s.section_id
    JOIN Course c ON s.course_id = c.course_id
    WHERE c.course_name = 'Databases' 
      AND s.semester = 'Spring' 
      AND s.year = 2022
      AND g.grade_100 = (
          SELECT MAX(g2.grade_100)
          FROM GradeReport g2
          JOIN Section s2 ON g2.section_id = s2.section_id
          JOIN Course c2 ON s2.course_id = c2.course_id
          WHERE c2.course_name = 'Databases' 
            AND s2.semester = 'Spring' 
            AND s2.year = 2022
      );
END;
GO

-- Thực thi:
EXEC sp_GetSpecialStudents;
GO

GO
create or alter PROCEDURE sp_StudentCourseCountByDept
AS
BEGIN
    Select 
        st.student_id,
        st.student_name,
        d.department_name as ManagedBY,
        COUNT(c.course_id) as course_count
    from Student st
    left join GradeReport g on st.student_id = g.student_id
    LEFT JOIN Section s on s.section_id = g.section_id
    LEFT JOIN Course c on c.course_id = s.course_id
    LEFT JOIN Department d on d.department_id = c.department_id
    group by st.student_id, st.student_name, d.department_name
    ORDER BY st.student_id
END

exec sp_StudentCourseCountByDept

CREATE TABLE StudentStatistics(
    student_id VARCHAR(9),
    student_name NVARCHAR(50),
    school_year INT,
    semester VARCHAR(9),
    nb_credits INT,
    PRIMARY KEY (student_id, school_year, semester),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);
GO

-- 5b. SP để tính toán và đổ dữ liệu
CREATE PROCEDURE sp_PopulateStudentStats
AS
BEGIN
    -- Xóa dữ liệu cũ để tính lại (nếu cần reset)
    DELETE FROM StudentStatistics;

    INSERT INTO StudentStatistics (student_id, student_name, school_year, semester, nb_credits)
    SELECT 
        st.student_id,
        st.student_name,
        s.year,
        s.semester,
        SUM(c.credit) AS TotalCredits
    FROM Student st
    JOIN GradeReport g ON st.student_id = g.student_id
    JOIN Section s ON g.section_id = s.section_id
    JOIN Course c ON s.course_id = c.course_id
    GROUP BY st.student_id, st.student_name, s.year, s.semester;
    
    PRINT 'Data populated successfully into StudentStatistics.';
END;
GO

-- Thực thi:
EXEC sp_PopulateStudentStats;
SELECT * FROM StudentStatistics;
GO

CREATE TRIGGER trg_UpdateStudentStats
ON GradeReport
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Tìm danh sách các (Student, Semester, Year) bị ảnh hưởng
    -- Dùng bảng ảo Inserted (cho INSERT/UPDATE) và Deleted (cho DELETE/UPDATE)
    DECLARE @AffectedKeys TABLE (student_id VARCHAR(9), semester VARCHAR(9), year INT);

    INSERT INTO @AffectedKeys
    SELECT i.student_id, s.semester, s.year
    FROM inserted i
    JOIN Section s ON i.section_id = s.section_id
    UNION
    SELECT d.student_id, s.semester, s.year
    FROM deleted d
    JOIN Section s ON d.section_id = s.section_id;

    -- 2. Cập nhật lại StudentStatistics cho những sinh viên bị ảnh hưởng
    -- Logic: Tính lại tổng tín chỉ và MERGE (hoặc Update/Insert) vào bảng thống kê
    
    -- Bước 2a: Xóa dòng cũ của những sinh viên bị ảnh hưởng trong bảng Stats
    DELETE FROM StudentStatistics
    WHERE EXISTS (
        SELECT 1 FROM @AffectedKeys k 
        WHERE k.student_id = StudentStatistics.student_id 
          AND k.semester = StudentStatistics.semester 
          AND k.school_year = StudentStatistics.school_year
    );

    -- Bước 2b: Insert lại giá trị mới đã tính toán
    INSERT INTO StudentStatistics (student_id, student_name, school_year, semester, nb_credits)
    SELECT 
        st.student_id,
        st.student_name,
        s.year,
        s.semester,
        SUM(c.credit)
    FROM Student st
    JOIN GradeReport g ON st.student_id = g.student_id
    JOIN Section s ON g.section_id = s.section_id
    JOIN Course c ON s.course_id = c.course_id
    WHERE EXISTS (
        SELECT 1 FROM @AffectedKeys k
        WHERE k.student_id = st.student_id AND k.semester = s.semester AND k.year = s.year
    )
    GROUP BY st.student_id, st.student_name, s.year, s.semester;
    
    PRINT 'StudentStatistics updated via Trigger.';
END;
GO