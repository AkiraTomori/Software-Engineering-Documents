USE QLYDETAI

-- a. In ra câu chào Hello World
GO
CREATE PROCEDURE SP_PrintString
    @LineNeedToPrint NVARCHAR(20),
    @KQ INT OUT
AS 
BEGIN
    SET @KQ = 0 
    IF @LineNeedToPrint IS NULL
    BEGIN;
        THROW 50001, N'LỖI CHUỖI RỖNG', 1
        SET @KQ = 1
        RETURN 1
    END 
    PRINT @LineNeedToPrint
    RETURN 0
END

DECLARE @K INT
EXEC SP_PrintString 'Hello World !!!', @K OUTPUT

-- b. In ra tổng 2 số
GO
CREATE 
PROCEDURE SP_Cal_2_Numbers
    @FIRST INT,
    @SECOND INT,
    @SUM INT OUT
AS
BEGIN
    SET @SUM = @FIRST + @SECOND
END 

DECLARE @Tong INT 
EXEC SP_Cal_2_Numbers 10, 5, @Tong OUTPUT
PRINT @Tong

-- d. In ra tổng của 3 số
GO
CREATE 
PROCEDURE SP_Cal_3_Numbers
    @first INT,
    @second INT,
    @third INT,
    @total_sum INT OUT 
AS 
BEGIN
    DECLARE @temp_sum INT
    EXEC SP_Cal_2_Numbers @first, @second, @temp_sum OUTPUT 
    EXEC SP_Cal_2_Numbers @temp_sum, @third, @total_sum OUTPUT
END

DECLARE @tong INT
EXEC SP_Cal_3_Numbers 2, 3, 4, @tong OUTPUT
PRINT @tong

-- e. In ra tổng các số nguyên từ m đến n
GO
CREATE 
PROCEDURE Sp_Cal_Numbers_From_m_to_n
    @m INT,
    @n INT
AS 
BEGIN
    DECLARE @total INT = 0
    DECLARE @I INT = @m
    WHILE @I <= @n
    BEGIN
        SET @total = @total + @I
        SET @I = @I + 1
    END
    print @total
END 
EXEC Sp_Cal_Numbers_From_m_to_n 1, 12

-- f. Kiểm tra 1 số có phải số nguyên tố không
GO 
CREATE 
PROCEDURE SP_CheckPrime
    @prime INT,
    @isprime BIT OUTPUT
AS 
BEGIN 
    DECLARE @i INT = 2
    SET @isprime = 1
    IF @prime < 2
    BEGIN
        SET @isprime = 0
        -- PRINT N'Số này không phải là số nguyên tố vì nhỏ hơn 2.';
    END 
    ELSE 
    BEGIN
        WHILE @i <= SQRT(@prime)
        BEGIN
            IF @prime % @i = 0
            BEGIN
                SET @isprime = 0
                -- PRINT N'Số này không phải là số nguyên tố vì chia hết cho ' + CAST(@i AS VARCHAR);
                BREAK
            END 
            SET @i = @i + 1
        END
    END
END 

DECLARE @IsPrime BIT
EXEC SP_CheckPrime 4, @IsPrime OUTPUT
PRINT @IsPrime

-- g. In ra tổng các số nguyên tố trong đoạn m, n
GO
CREATE 
PROCEDURE SP_SumPrimes
    @m INT,
    @n INT,
    @totalSum INT OUT
AS 
BEGIN
    DECLARE @sum INT = 0
    DECLARE @i INT = @m
    DECLARE @isPrime BIT

    WHILE @i <= @n
    BEGIN
        EXEC SP_CheckPrime @i, @isPrime OUTPUT
        IF @isPrime = 1
        BEGIN
            SET @sum = @sum + @i
        END
        SET @i = @i + 1
    END
    SET @totalSum = @sum
END

DECLARE @total INT
EXEC SP_SumPrimes 1, 12, @total OUTPUT
PRINT @total

-- h. Tính ước chung lớn nhất của hai số nguyên
GO
CREATE 
PROCEDURE SP_FindGreatestCommonDivisor
    @a INT,
    @b INT,
    @KQ INT OUT 
AS 
BEGIN
    DECLARE @TEMP INT 
    WHILE @b <> 0
    BEGIN
        SET @TEMP = @b
        SET @b = @a % @b
        SET @a = @TEMP
    END 
    SET @KQ = @TEMP
END 

DECLARE @gcd INT 
EXEC SP_FindGreatestCommonDivisor 24, 16, @gcd OUTPUT 
PRINT @gcd

-- i. Tình bội chung nhỏ nhất của hai số nguyên
GO 
CREATE 
PROCEDURE SP_FindLeastCommonDivisor
    @a INT,
    @b INT,
    @KQ INT OUT 
AS 
BEGIN
    DECLARE @gcd INT = 0
    EXEC SP_FindGreatestCommonDivisor @a, @b, @gcd OUTPUT
    DECLARE @product INT = @a * @b
    SET @KQ = (@product) / (@gcd)
END 
DECLARE @lcm INT 
EXEC SP_FindLeastCommonDivisor 24, 16, @lcm OUTPUT 
PRINT @lcm
-- j. Xuất ra toàn bộ danh sách giáo viên
GO 
CREATE 
PROCEDURE PrintAllTeachers
AS 
BEGIN
    SELECT * FROM GIAOVIEN
END 
EXEC PrintAllTeachers
-- k. Tính số lượng đề tài mà một giáo viên đang thực hiện
GO 
CREATE 
PROCEDURE CountDeTaiFromOneTeacher 
    @MaGV VARCHAR(10)
AS 
BEGIN
    SELECT gv.MAGV, gv.HOTEN, COUNT(DISTINCT tg.MADT) 'Số lượng đề tài'
    FROM GIAOVIEN gv JOIN THAMGIADT tg ON gv.MAGV = tg.MADT
    WHERE gv.MAGV = @MaGV
    GROUP BY gv.MAGV, gv.HOTEN
END

EXEC CountDeTaiFromOneTeacher '001'
-- l. In thông tin chi tiết của một giáo viên (print):
-- Thông tin cá nhân, số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó
GO 
CREATE 
PROCEDURE SP_PrintInfo
    @MaGv VARCHAR(10),
    @flag INT OUT 
AS 
BEGIN
    SET @flag = 0
    IF @MaGv IS NULL
    BEGIN
        ; THROW 50001, N'MAGV rỗng', 1
        SET @flag = 1
        RETURN 1
    END  
    DECLARE @GetName NVARCHAR(20)
    -- DECLARE @GetMaBm NVARCHAR(10)
    DECLARE @GetFamliyMember INT
    DECLARE @GetDeTai INT

    SELECT @GetName = gv.HOTEN
    FROM GIAOVIEN gv 
    WHERE gv.MAGV = @MaGv

    SELECT @GetFamliyMember = COUNT(*)
    FROM NGUOITHAN ng 
    WHERE ng.MAGV = @MaGv

    SELECT @GetDeTai = COUNT(*)
    FROM THAMGIADT tg 
    WHERE tg.MAGV = @MaGv

    PRINT N'Thông tin giáo viên'
    PRINT N'Tên giáo viên: ' + @GetName
    PRINT N'Số lượng đề tài tham gia: ' + CAST(@GetDeTai AS NVARCHAR)
    PRINT N'Số lượng người thân: ' + CAST(@GetFamliyMember AS NVARCHAR)
END

DECLARE @Co INT 
EXEC SP_PrintInfo '001', @Co OUTPUT

-- m. Kiểm tra xem một giáo viên có tồn tại không (dựa vào MAGV)
GO 
CREATE 
PROCEDURE SP_CheckTeacherExists
    @MaGV VARCHAR(10),
    @Flag INT OUT 
AS 
BEGIN
    SET @Flag = 0
    IF @MaGV IS NULL
    BEGIN
        ; THROW 50001, N'Mã GV rỗng', 1
        SET @Flag = 1
        RETURN 1
    END
    IF (EXISTS(SELECT * FROM GIAOVIEN gv WHERE gv.MAGV = @MaGV))
        PRINT N'Tồn tại giáo viên có mã giáo viên: ' + @MaGV
    ELSE 
        PRINT N'Không tồn tại giáo viên có mã giáo viên' + @MaGV
    RETURN 0 
END

DECLARE @flag INT
EXEC SP_CheckTeacherExists '001', @flag OUTPUT
-- m. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ môn của giáo viên đó làm chủ nhiệm
GO 
CREATE 
PROCEDURE SP_CheckTeacherProjectCompliance
    @MaGV VARCHAR(10),
    @MaDT NVARCHAR(10),
    @Flag INT OUT
AS 
BEGIN 
    SET @Flag = 0
    IF @MaGV IS NULL
    BEGIN
        ;THROW 50001, N'Lỗi MAGV rỗng', 1
        SET @Flag = 1
        RETURN 1
    END 
    IF @MaDT IS NULL
    BEGIN
        ;THROW 50001, N'Lỗi MADT rỗng', 1
        SET @Flag = 1
        RETURN 1
    END 
    
    DECLARE @MaBM_GV VARCHAR(10)
    DECLARE @MaBM_DT NVARCHAR(10)
    DECLARE @GVCNDT VARCHAR(10)

    SELECT @MaBM_GV = gv.MABM
    FROM GIAOVIEN gv
    WHERE gv.MAGV = @MaGV

    SELECT @GVCNDT = dt.GVCNDT
    FROM DETAI dt 
    WHERE dt.MADT = @MaDT

    SELECT @MaBM_DT = gv.MABM
    FROM GIAOVIEN gv
    WHERE gv.MAGV = @GVCNDT

    IF @MaBM_GV = @MaBM_DT
        PRINT N'Giáo viên được phép thực hiện đề tài này'
    ELSE 
        PRINT N'Giáo viên không được phép thực hiện đề tài này'
    RETURN 0
END 
DECLARE @flag INT
EXEC SP_CheckTeacherProjectCompliance '001', '001', @flag OUTPUT
-- o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài
    -- Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc phải tồn tại, thời gian tham gia phải > 0
    -- Kiểm tra quy định ở câu n
GO 
CREATE 
PROCEDURE SP_AddMoreJobForTeacher
    @MaGV VARCHAR(10),
    @MaDT NVARCHAR(10),
    @STT INT,
    @PhuCap FLOAT,
    @KETQUA NVARCHAR(10),
    @NgayBD DATE,
    @NgayKT DATE,
    @Flag INT OUT 
AS
BEGIN
    SET @Flag = 0
    DECLARE @errorMSG NVARCHAR(100)

    IF @MaGV IS NULL
    BEGIN
        ;THROW 50001, N'Lỗi MAGV rỗng', 1
        SET @Flag = 1
        RETURN 1
    END 

    IF @MaDT IS NULL
    BEGIN
        ;THROW 50001, N'Lỗi MADT rỗng', 1
        SET @Flag = 1
        RETURN 1
    END 

    IF NOT EXISTS(SELECT * FROM GIAOVIEN gv WHERE gv.MAGV = @MaGV)
    BEGIN
        SET @errorMSG = N'Không tồn tại giáo viên có mã giáo viên ' + @MaGV
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END
    IF NOT EXISTS(SELECT * FROM CONGVIEC cv WHERE cv.STT = @STT AND cv.MADT = @MaDT)
    BEGIN
        SET @errorMSG = N'Không tồn tại công việc có mã đề tài ' + @MaDT
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END 
    IF DATEDIFF(DAY, @NgayBD, @NgayKT) <= 0
    BEGIN
        SET @errorMSG = N'Thời gian phải lớn hơn 0'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END 
    DECLARE @MaBM_GV VARCHAR(10)
    DECLARE @MaBM_DT NVARCHAR(10)
    DECLARE @GVCNDT VARCHAR(10)

    SELECT @MaBM_GV = gv.MABM
    FROM GIAOVIEN gv
    WHERE gv.MAGV = @MaGV

    SELECT @GVCNDT = dt.GVCNDT
    FROM DETAI dt 
    WHERE dt.MADT = @MaDT

    SELECT @MaBM_DT = gv.MABM
    FROM GIAOVIEN gv
    WHERE gv.MAGV = @GVCNDT

    IF @MaBM_GV <> @MaBM_DT
    BEGIN
        SET @errorMSG = N'Giáo viên không được phép thực hiện đề tài này'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END
    INSERT INTO THAMGIADT (MAGV, MADT, STT, PHUCAP, KETQUA)
    VALUES (@MaGV, @MaDT, @STT, @PhuCap, @KETQUA)

    PRINT N'Phân công giáo viên thành công'
    RETURN 0
END 

DECLARE @Flag INT 
EXEC SP_AddMoreJobForTeacher '003', '001', 3, 1.0, N'Đạt', '10-20-2007', '12-20-2008', @Flag OUTPUT
-- p. Thực hiện xóa một giáo viên theo mã, nếu giáo viên có thông tin liên quan(, có thân nhân, có tham gia đề ,.. ) thì báo lỗi
GO 
CREATE 
PROCEDURE SP_DeleteGV
    @MaGV VARCHAR(10),
    @Flag INT OUT
AS 
BEGIN
    SET @Flag = 0
    DECLARE @errorMSG NVARCHAR(100)
    IF @MaGV IS NULL

    BEGIN
        SET @errorMSG = N'Lỗi MAGV rỗng'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END
    
    IF EXISTS(SELECT * FROM NGUOITHAN WHERE MAGV = @MaGV)
    BEGIN
        SET @errorMSG = N'Có lưu thông tin người thân nên không thể xóa'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END
    
    IF EXISTS(SELECT * FROM THAMGIADT WHERE MAGV = @MaGV)
    BEGIN
        SET @errorMSG = N'Giáo viên này đang tham gia đề tài'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF EXISTS(SELECT * FROM GV_DT WHERE MAGV = @MaGV)
    BEGIN
        SET @errorMSG = N'Có lưu số điện thoại của giáo viên nên không thể xóa'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF EXISTS(SELECT * FROM DETAI WHERE GVCNDT = @MaGV)
    BEGIN
        SET @errorMSG = N'Giáo viên này đang chủ nhiệm đề tài nên không thể xóa'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    DELETE FROM GIAOVIEN WHERE MAGV = @MaGV
    RETURN 0
END 

DECLARE @Flag INT 
EXEC SP_DeleteGV '001', @Flag OUTPUT

-- q. In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản lý nếu có.
GO 
CREATE 
PROCEDURE SP_PrintTeacher
    @MaBM NVARCHAR(10),
    @Flag INT OUT 
AS 
BEGIN
    SET @Flag = 0
    DECLARE @errorMSG NVARCHAR(100)
    IF @MaBM IS NULL
    BEGIN
        SET @errorMSG = N'Lỗi MABM rỗng'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    SELECT gv.*, ISNULL(TGDT.ProjectCount, 0) AS 'Số lượng đề tài', ISNULL(NT.FamilyCount, 0) AS 'Số lượng thân nhân', ISNULL(GVQL.TeacherCount, 0) AS 'Số lượng giáo viên mà giáo viên quản lý'
    FROM GIAOVIEN gv LEFT JOIN (
        SELECT MAGV, COUNT(*) AS ProjectCount FROM THAMGIADT GROUP BY MAGV
    ) TGDT ON gv.MAGV = TGDT.MAGV
    LEFT JOIN (
        SELECT MAGV, COUNT(*) AS FamilyCount FROM NGUOITHAN GROUP BY MAGV
    ) NT ON gv.MAGV = NT.MAGV
    LEFT JOIN (
        SELECT GVQLCM, COUNT(*) AS TeacherCount FROM GIAOVIEN GROUP BY GVQLCM
    ) GVQL ON gv.MAGV = GVQL.GVQLCM
    WHERE gv.MABM = @MaBM
    RETURN 0
END 

DECLARE @Flag INT 
EXEC SP_PrintTeacher 'HTTT', @Flag
-- r. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b thì
-- lương của a phải cao hơn lương của b
GO 
CREATE 
PROCEDURE SP_CheckSalaryTwoTeacher
    @MaGV_First VARCHAR(10),
    @MaGV_Second VARCHAR(10),
    @Flag INT OUT 
AS 
BEGIN
    SET @Flag = 0
    DECLARE @errorMSG NVARCHAR(100)
    IF @MaGV_First IS NULL
    BEGIN
        SET @errorMSG = N'Lỗi MAGV đầu tiên rỗng'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF @MaGV_Second IS NULL
    BEGIN
        SET @errorMSG = N'Lỗi MAGV thứ hai rỗng'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    DECLARE @MABM_A NVARCHAR(10)
    DECLARE @MABM_B NVARCHAR(10)
    DECLARE @LUONG_A INT
    DECLARE @LUONG_B INT

    SELECT @MABM_A = gv.MABM, @LUONG_A = gv.LUONG
    FROM GIAOVIEN gv 
    WHERE gv.MAGV = @MaGV_First

    SELECT @MABM_B = gv.MABM, @LUONG_B = gv.LUONG
    FROM GIAOVIEN gv 
    WHERE gv.MAGV = @MaGV_Second

    IF EXISTS(SELECT * FROM BOMON WHERE MABM = @MABM_B AND TRUONGBM = @MaGV_First)
    BEGIN
        IF @LUONG_A <= @LUONG_B
        BEGIN
            SET @errorMSG = N'Lương của trưởng bộ môn phải cao hơn'
            SET @Flag = 1
            PRINT @errorMSG
            RETURN 1
        END
    END
    ELSE 
    BEGIN
        SET @errorMSG = N'Giáo viên đầu tiên không phải là trưởng bộ môn'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END 
    PRINT N'Lương của trưởng bộ môn cao hơn'
    RETURN 0
END 

DECLARE @Flag INT 
EXEC SP_CheckSalaryTwoTeacher '002', '003', @Flag OUTPUT 

-- s. Thêm một giáo viên, kiểm tra quy định
-- Không trùng tên, tuối > 18, lương > 0
GO 
CREATE 
PROCEDURE SP_AddTeacher
    @MaGV VARCHAR(10),
    @HOTEN NVARCHAR(20),
    @LUONG INT,
    @PHAI NVARCHAR(5),
    @NGSINH DATE,
    @DIACHI NVARCHAR(50),
    @GVQLCM VARCHAR(10),
    @MaBM NVARCHAR(10),
    @Flag INT OUT
AS
BEGIN
    SET @Flag = 0
    DECLARE @errorMSG NVARCHAR(100)
    
    IF @MaGV IS NULL
    BEGIN
        SET @errorMSG = N'Lỗi MAGV rỗng!!!!'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF EXISTS(SELECT * FROM GIAOVIEN gv WHERE gv.HOTEN = @HOTEN)
    BEGIN
        SET @errorMSG = N'Giáo viên này trùng tên với giáo viên khác'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF DATEDIFF(YEAR, @NGSINH, GETDATE()) <= 18
    BEGIN
        SET @errorMSG = N'Tuổi phải tối thiểu từ 18'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF @LUONG <= 0
    BEGIN
        SET @errorMSG = N'Lương phải là số dương.'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    INSERT INTO GIAOVIEN(MAGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI, GVQLCM, MABM) VALUES
    (@MaGV, @HOTEN, @LUONG, @PHAI, @NGSINH, @DIACHI, @GVQLCM, @MaBM)

    RETURN 0
END

-- t. Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có gv 001,002,003 thì giáo viên tiếp theo là 004. 
-- Nếu đã có gv 001, 002, 004 thì mã giáo viên tiếp theo là 003
GO 
CREATE 
PROCEDURE SP_AddTeacherBaseOnExistingId
    @HOTEN NVARCHAR(20),
    @LUONG INT,
    @PHAI NVARCHAR(5),
    @NGSINH DATE,
    @DIACHI NVARCHAR(50),
    @GVQLCM VARCHAR(10),
    @MaBM NVARCHAR(10),
    @Flag INT OUT
AS
BEGIN
    SET @Flag = 0
    DECLARE @NextMaGV VARCHAR(10)
    DECLARE @errorMSG NVARCHAR(100)

    SELECT @NextMAGV = RIGHT('000' + CAST(MIN(CAST(MAGV AS INT) + 1) AS VARCHAR(10)), 3)
    FROM GIAOVIEN gv 
    WHERE CAST(gv.MAGV AS INT) + 1 NOT IN (
        SELECT CAST(gv.MAGV AS INT)
        FROM GIAOVIEN gv 
    )

    IF EXISTS(SELECT * FROM GIAOVIEN gv WHERE gv.HOTEN = @HOTEN)
    BEGIN
        SET @errorMSG = N'Giáo viên này trùng tên với giáo viên khác'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF DATEDIFF(YEAR, @NGSINH, GETDATE()) <= 18
    BEGIN
        SET @errorMSG = N'Tuổi phải tối thiểu từ 18'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    IF @LUONG <= 0
    BEGIN
        SET @errorMSG = N'Lương phải là số dương.'
        SET @Flag = 1
        PRINT @errorMSG
        RETURN 1
    END

    INSERT INTO GIAOVIEN(MAGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI, GVQLCM, MABM) VALUES
    (@NextMaGV, @HOTEN, @LUONG, @PHAI, @NGSINH, @DIACHI, @GVQLCM, @MaBM)

    RETURN 0
END 

