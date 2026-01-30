-- create database UniversityDB;
use UniversityDB;
go 

create table Student(
    student_id varchar(9),
    student_name nvarchar(50) not null,
    gender char(1) check (gender in ('F', 'M', 'O')),
    birthdate datetime,
    class varchar(5),
    department_id varchar(5),
    primary key(student_id)
)

create table Course(
    course_id varchar(9),
    course_name nvarchar(50) not null unique,
    credit int check (credit > 0),
    department_id varchar(5)
    primary key(course_id)
)

create table Section(
    section_id int,
    course_id varchar(9) not null,
    semester varchar(9) not null,
    year int not null,
    capacity int check(capacity > 0),
    unique(course_id, semester, year),
    primary key(section_id)
)

create table Teaching(
    section_id int not null,
    instructor_id varchar(9) not null,
    role varchar(9) -- Lecturer, TA
    primary key(section_id, instructor_id)
)

create table Prerequisite(
    course_id varchar(9) not null,
    prerequisite_id varchar(9) not null,
    primary key(course_id, prerequisite_id)
)

create table Instructor(
    instructor_id varchar(9),
    instructor_name nvarchar(50) not null,
    phone nvarchar(9) not null,
    department_id varchar(5) not null,
    salary int check (salary > 0),
    primary key(instructor_id)
)


create table Department(
    department_id varchar(5),
    department_name nvarchar(50) not null,
    office varchar(5),
    department_head varchar(9)
    primary key(department_id)
)

create table GradeReport(
    section_id int not null,
    student_id varchar(9) not null,
    grade_100 int check(grade_100 >= 0),
    grade_ABC char(1) check(grade_ABC in ('A', 'B', 'C', 'D', 'E', 'F'))
    primary key(section_id, student_id)
)

alter table Student
add constraint fk_student_department
foreign key(department_id)
references Department(department_id)

alter table Course
add constraint fk_course_department
foreign key(department_id)
references Department(department_id)

alter table Section
add constraint fk_section_course
foreign key(course_id)
references Course(course_id)

alter table teaching
add constraint fk_teaching_section
foreign key(section_id)
references Section(section_id)

alter table teaching
add constraint fk_teaching_instructor
foreign key(instructor_id)
references Instructor(instructor_id)

alter table GradeReport
add constraint fk_gradereport_section
foreign key(section_id)
references Section(section_id)

alter table GradeReport
add constraint fk_gradereport_student
foreign key(student_id)
references Student(student_id)

alter table Prerequisite
add constraint fk_prerequisite_course
foreign key(course_id)
references Course(course_id)

alter table Prerequisite
add constraint fk_prerequisite_course_2
foreign key(prerequisite_id)
references Course(course_id)

alter table Instructor
add constraint fk_instructor_department
foreign key(department_id)
references Department(department_id)

alter table Department
add constraint fk_department_instructor
foreign key(department_head)
references Instructor(instructor_id)

go 
-- insert data

insert into Department values
('AI', 'Artificial Intelligence', 'I86', NULL),
('CS', 'Computer Science', 'I81', null),
('IS', 'Information System', 'I84', null),
('NW', 'Network', 'I87', null),
('SE', 'Software Engineering', 'I82', null)

insert into Student values
('ST001', 'Nguyen Ai Linh', 'F', '2002/12/01', null, 'CS'),
('ST002', 'Tran Thanh Sang', 'M', '2003/09/02', null, 'CS'),
('ST003', 'Huynh Thanh Phong', 'M', '2001/05/03', null, 'SE'),
('ST004', 'Hoang Nhat Linh', 'F', '2002/05/10', null, 'SE'),
('ST005', 'Le Ba Khanh', 'M', '2001/11/12', null, 'SE'),
('ST006', 'Ly Quoc Phong', 'M', '2000/08/12', null, 'SE'),
('ST007', 'Tran Thanh An', 'F', '2000/11/09', null, 'IS'),
('ST008', 'Le Nha Thu', 'F', '2002/08/09', null, 'IS'),
('ST009', 'Ho Ngoc Anh', 'F', '2003/11/01', null, 'AI'),
('ST010', 'Nguyen Thanh Son', 'M', '2003/12/05', null, 'NW')

insert into Course values
('CS01', 'Databases', 4, 'IS'),
('CS02', 'Databases Management System', 4, 'IS'),
('CS03', 'Introduction to Programming', 4, 'SE'),
('CS04', 'Object-Oriented Programming', 4, 'SE'),
('CS05', 'Basic Network', 4, 'NW'),
('CS06', 'Advanced Network', 4, 'NW'),
('CS07', 'Introduction to Artificial Intelligence', 4, 'AI'),
('CS08', 'Introduction to Machine Learning', 4, 'CS'),
('CS09', 'Computer Vission', 4, 'CS'),
('CS10', 'Robotics', 4, 'AI')

insert into Instructor values
('I001', 'Dang Huynh Bao Khanh', '080913213', 'CS', 1000),
('I002', 'Alex Grant', '082412613', 'CS', 2000),
('I003', 'Tran Hoang Lan', '080921234', 'Se', 1500),
('I004', 'Nguyen Ngoc Khanh', '090245613', 'IS', 1500),
('I005', 'James Cobb', '092193213', 'SE', 2000),
('I006', 'Le Khanh', '090799131', 'IS', 2200),
('I007', 'Vu Ngoc Bao', '090511342', 'SE', 2100),
('I008', 'Tran Hong An', '099912353', 'NW', 1900),
('I009', 'Nguyen Hai Lam', '080911234', 'AI', 1500),
('I010', 'Dang Hoang Phong', '090233451', 'AI', 2300)

insert into Section values
(1, 'CS01', 'Fall', 2022, 30),
(2, 'CS02', 'Fall', 2022, 30),
(3, 'CS03', 'Fall', 2022, 30),
(4, 'CS04', 'Fall', 2022, 30),
(5, 'CS01', 'Spring', 2022, 20),
(6, 'CS02', 'Spring', 2022, 20),
(7, 'CS03', 'Spring', 2022, 20),
(8, 'CS05', 'Spring', 2022, 20),
(9, 'CS05', 'Fall', 2023, 12),
(10, 'CS06', 'Fall', 2023, 12),
(11, 'CS07', 'Fall', 2023, 12)

insert into Teaching values
(1, 'I004', 'Lecturer'),
(1, 'I006', 'TA'),
(2, 'I004', 'Lecturer'),
(2, 'I007', 'TA'),
(3, 'I003', 'TA'),
(3, 'I005', 'Lecturer'),
(4, 'I005', 'Lecturer'),
(4, 'I009', 'TA'),
(5, 'I004', 'Lecturer'),
(5, 'I006', 'TA'),
(6, 'I004', 'Lecturer'),
(7, 'I005', 'Lecturer'),
(8, 'I008', 'Lecturer')

insert into Prerequisite values
('CS02', 'CS01'),
('CS04', 'CS03'),
('CS06', 'CS05'),
('CS08', 'CS07'),
('CS09', 'CS07'),
('CS10', 'CS07')

insert into GradeReport values (1, 'ST001', 80, null)
insert into GradeReport values (1, 'ST002', 82, null)
insert into GradeReport values (1, 'ST003', 35, null)
insert into GradeReport values (1, 'ST004', 60, null)
insert into GradeReport values (1, 'ST005', 100, null)
insert into GradeReport values (1, 'ST006', 100, null)
insert into GradeReport values (1, 'ST007', 90, null)
insert into GradeReport values (1, 'ST008', 52, null)
insert into GradeReport values (1, 'ST009', 36, null)
insert into GradeReport values (1, 'ST010', 99, null)

insert into GradeReport values (2, 'ST001', 77, null)
insert into GradeReport values (2, 'ST002', 84, null)
insert into GradeReport values (2, 'ST003', 60, null)
insert into GradeReport values (2, 'ST004', 53, null)
insert into GradeReport values (2, 'ST005', 99, null)
insert into GradeReport values (2, 'ST006', 93, null)
insert into GradeReport values (2, 'ST007', 82, null)
insert into GradeReport values (2, 'ST008', 63, null)
insert into GradeReport values (2, 'ST009', 62, null)
insert into GradeReport values (2, 'ST010', 88, null)

insert into GradeReport values (3, 'ST001', 80, null)
insert into GradeReport values (3, 'ST002', 82, null)
insert into GradeReport values (3, 'ST003', 53, null)
insert into GradeReport values (3, 'ST004', 62, null)
insert into GradeReport values (3, 'ST005', 72, null)
insert into GradeReport values (3, 'ST006', 88, null)
insert into GradeReport values (3, 'ST007', 98, null)
insert into GradeReport values (3, 'ST008', 44, null)
insert into GradeReport values (3, 'ST009', 50, null)
insert into GradeReport values (3, 'ST010', 72, null)

insert into GradeReport values (4, 'ST001', 92, null)
insert into GradeReport values (4, 'ST002', 78, null)
insert into GradeReport values (4, 'ST003', 85, null)
insert into GradeReport values (4, 'ST004', 43, null)
insert into GradeReport values (4, 'ST005', 88, null)
insert into GradeReport values (4, 'ST006', 97, null)
insert into GradeReport values (4, 'ST007', 87, null)
insert into GradeReport values (4, 'ST008', 54, null)
insert into GradeReport values (4, 'ST009', 73, null)
insert into GradeReport values (4, 'ST010', 87, null)

update Department set department_head = 'I001' where department_id = 'CS'
update Department set department_head = 'I009' where department_id = 'AI'
update Department set department_head = 'I004' where department_id = 'IS'
update Department set department_head = 'I003' where department_id = 'SE'

update GradeReport set grade_ABC = 
    case
    when grade_100 between 90 and 100 then 'A'
    when grade_100 between 80 and 89 then 'B'
    when grade_100 between 70 and 79 then 'C'
    when grade_100 between 65 and 69 then 'D'
    when grade_100 < 65 then 'F'
    end

select * from GradeReport