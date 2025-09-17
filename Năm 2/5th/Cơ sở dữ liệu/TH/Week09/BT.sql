USE QLYDETAI

DECLARE @I INT = 1, @N INT = 5
DECLARE @A NVARCHAR(10)

SET @A = 'ABC'
SET @A = (
    SELECT gv.PHAI
    FROM GIAOVIEN gv
    WHERE gv.MAGV = N'001' 
)
SELECT @A = N'ACB', @I = 1
SELECT @A = PHAI, @I = LUONG 
FROM GIAOVIEN

PRINT N'THONG BAO';
THROW 51000, 'LOI', 1
RAISERROR(N'THONG BAO LOI', 16 ,1)

WHILE (@I < @N)
BEGIN
    PRINT @I
    SET @I = @I + 1
END 
IF @I < 3 OR @A <> 'ABC'
BEGIN
    SET @A = @A + CAST(@I AS nvarchar(3))
END

GO
CREATE
-- ALTER 
PROCEDURE SP_TEST
    @MAGV NVARCHAR(10),
    @HOTEN NVARCHAR(30),
    @LUONG INT,
    @KQ int OUT -- Biến lưu trữ giá trị output
AS -- Kết thúc khai báo tham số
    SET @KQ = 0
    IF @MAGV IN (SELECT MAGV FROM GIAOVIEN)
    BEGIN;
        THROW 50001, N'LỖI TRÙNG MAGV', 1
        SET @KQ = 1
        RETURN 1 -- Để thoát khỏi thủ tục
    END
    IF @HOTEN IS NULL
    BEGIN
        ; THROW 50002, N'LỖI TÊN RỖNG', 1
        SET @KQ = 1
        RETURN 1
    END 
    IF @LUONG <= 0
    BEGIN
        ; THROW 50001, N'LỖI LƯƠNG SAI GIA TRI', 1
        SET @KQ = 1
        RETURN 1 -- INT
    END 
    INSERT GIAOVIEN(MAGV, HOTEN, LUONG)
    VALUES(@MAGV, @HOTEN, @LUONG)
    RETURN 0
GO -- Kết thúc khai báo thủ tục

DECLARE @K INT, @R INT 
EXEC @R = SP_TEST '001', 'NGUYEN VAN A', 200, @K OUT
PRINT @K 
PRINT @R 
SELECT * FROM GIAOVIEN