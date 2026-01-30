-- MSSV: 23127379
-- Họ tên: Thái Minh Huy
-- Mã Đề: 3
-- Vị trí chỗ ngồi: 3I

USE QUANLYNGANHANG 
GO
-- Câu 1: Cho biết các loại tài khoản (mã, tên) được dùng để giao dịch
-- nhiều nhất năm 2023

SELECT ltk.maloaitk, ltk.tenloaitk
FROM LOAITAIKHOAN ltk JOIN TAIKHOAN tk ON ltk.maloaitk = tk.loaitk
    JOIN GIAODICH gd ON (tk.macn = gd.macn AND tk.sotk = gd.sotk)
WHERE YEAR(gd.ngaygiogd) = 2023
GROUP BY ltk.maloaitk, ltk.tenloaitk
HAVING COUNT(gd.magd) >= ALL(
    SELECT COUNT(ltk.maloaitk)
FROM LOAITAIKHOAN ltk JOIN TAIKHOAN tk ON ltk.maloaitk = tk.loaitk
    JOIN GIAODICH gd ON (tk.macn = gd.macn AND tk.sotk = gd.sotk)
WHERE YEAR(gd.ngaygiogd) = 2023
GROUP BY ltk.maloaitk 
)


-- Câu 2: Cho biết các chi nhánh (mã, tên) đang quản lý khách hàng
-- có mở tất cả các loại tài khoản
-- Thương: macn, tencn
-- Số chia: maloaitk
-- Số bị chia: macn, tencn, maloaitk

SELECT cn.macn, cn.tencn
FROM CHINHANH cn
WHERE NOT EXISTS(
                SELECT ltk.maloaitk
    FROM LOAITAIKHOAN ltk
EXCEPT
    SELECT tk.loaitk
    FROM TAIKHOAN tk JOIN KHACHHANG kh ON tk.macn = kh.macn
    WHERE tk.macn = cn.macn
)

-- Câu 4: Viết thủ tục xuất tài khoản. Thủ tục nhận vào sotk, macn và xuất thông tin theo mẫu sau:
-- Mã khách hàng - Tên khách hàng
-- Tên chi nhánh: ....
-- Số dư tài khoản
-- Tổng số giáo dịch mà tài khoản đã thực hiện

GO
CREATE OR ALTER PROCEDURE sp_PrintBankAccout_23127379
    @SoTK CHAR(10),
    @MACN CHAR(10),
    @KQ INT OUT
AS
BEGIN
    SET @KQ = 0
    -- Kiểm số số tài khoản rỗng ?
    IF @SoTK IS NULL
    BEGIN
        ;THROW 50001, 'Lỗi tài khoản rỗng', 1
        SET @KQ = 1
        RETURN 1
    END

    -- Kiếm tra chi nhánh có rỗng không ? 
    IF @MACN IS NULL
    BEGIN
        ;THROW 50002, 'Lỗi mã chi nhánh rỗng', 1
        SET @KQ = 1
        RETURN 1
    END

    -- Kiểm tra mã chi nhánh có tồn tại trong CSDL
    IF NOT EXISTS(SELECT *
    FROM CHINHANH cn
    WHERE cn.macn = @MACN)
    BEGIN
        ;THROW 50003, 'Lỗi chi nhánh không tồn tại', 1
        SET @KQ = 1
        RETURN 1
    END

    -- Kiểm tra số tài khoản được nhập vào có thuộc chi nhánh đó hay không ?
    IF NOT EXISTS(
        SELECT *
    FROM TAIKHOAN tk JOIN CHINHANH cn ON tk.macn = cn.macn
    WHERE cn.macn = @MACN AND tk.sotk = @SoTK
    )
    BEGIN
        ;THROW 50004, 'Lỗi không tồn tại số tài khoản thuộc về chi nhánh', 1
        SET @KQ = 1
        RETURN 1
    END

    -- Khai báo biến cho quá trình thực hiện xuất thông tin
    DECLARE @getMaKH CHAR(100)
    DECLARE @getTenKH NVARCHAR(100)
    DECLARE @getTenCN NVARCHAR(100)
    DECLARE @getSoDUTK INT
    DECLARE @getSoGD INT

    SELECT @getMaKH = kh.makh, @getTenKH = kh.hoten, @getTenCN = cn.tencn
    FROM KHACHHANG kh JOIN CHINHANH cn ON kh.macn = cn.macn
    WHERE cn.macn = @MACN

    SELECT @getSoDUTK = tk.sodutk, @getSoGD = ISNULL(COUNT(gd.macn), 0)
    FROM TAIKHOAN tk JOIN GIAODICH gd ON (tk.macn = gd.macn AND tk.sotk = gd.sotk)
    WHERE tk.macn = @MACN AND tk.sotk = @SoTK
    GROUP BY tk.sotk, tk.macn, tk.sodutk

    PRINT N'Mã khách hàng: ' + @getMaKH + N' - Họ tên khách hàng: ' + @getTenKH
    PRINT N'Tên chi nhánh: ' + @getTenCN
    PRINT N'Số dư tài khoản: ' + CAST(@getSoDUTK AS NVARCHAR)
    PRINT N'Tổng số giao dịch tài khoản đã thực hiện: ' + CAST(@getSoGD AS NVARCHAR)
    RETURN 0
END

DECLARE @flag2 INT
EXEC sp_PrintBankAccout_23127379 '0010000311', 'CN001', @flag2 OUTPUT

-- Câu 3: Viết thủ tục thêm một giao dịch mới
GO
CREATE OR ALTER PROCEDURE sp_CreateNewTransaction_23127379
    @MaCN CHAR(10),
    @SoTk CHAR(10),
    @MaLoaiGD INT,
    @tiengd DECIMAL(10, 2),
    @KQ2 INT OUT
AS
BEGIN
    SET @KQ2 = 0
    IF @MaCN IS NULL
    BEGIN
        ;THROW 50001, 'Lỗi mã chi nhánh rỗng', 1
        SET @KQ2 = 1
        RETURN 1
    END

    IF @SoTk IS NULL 
    BEGIN
        ;THROW 50002, 'Lỗi số tài khoản rỗng', 1
        SET @KQ2 = 1
        RETURN 1
    END

    IF @MaLoaiGD IS null
    BEGIN
        ;
        THROW 50003, 'Lỗi mã giao dịch rỗng', 1
        SET @KQ2 = 1
        RETURN 1
    END

    IF NOT EXISTS(SELECT *
    FROM TAIKHOAN tk
    WHERE tk.sotk = @SoTk)
    BEGIN
        ;THROW 50004, 'Lỗi không tồn tại số tài khoản', 1
        SET @KQ2 = 1
        RETURN 1
    END

    IF NOT EXISTS(SELECT *
    FROM CHINHANH cn
    WHERE cn.macn = @MaCN)
    BEGIN
        ;THROW 50005, 'Lỗi chi nhánh không tồn tại', 1
        SET @KQ2 = 1
        RETURN 1
    END

    IF NOT EXISTS(SELECT *
    FROM LOAIGIAODICH
    WHERE maloaigd = @MaLoaiGD)
    BEGIN
        ;THROW 50006, 'Lỗi mã giao dịch không tồn tại', 1
        SET @KQ2 = 1
        RETURN 1
    END

    IF @tiengd < 0
    BEGIN
        ;THROW 50007, 'Tiền giao dịch phải dương', 1
        SET @KQ2 = 1
        RETURN 1
    END

    DECLARE @checkSDTK INT 
    SELECT @checkSDTK = tk.sodutk
    FROM LOAIGIAODICH lg JOIN GIAODICH gd ON gd.magd = lg.maloaigd
        JOIN TAIKHOAN tk ON tk.macn = gd.macn AND tk.sotk = gd.sotk
    WHERE lg.maloaigd = 1 OR lg.maloaigd = 2 AND tk.sotk = @SoTk AND tk.macn = @MaCN
    
    IF @checkSDTK < @tiengd
    BEGIN
        ; THROW 50008, 'Lỗi tiền giao dịch lớn hơn số du', 1
        SET @KQ2 = 1
        RETURN 1
    END

    DECLARE @magd CHAR(30)
    DECLARE @ngaygiogd DATETIME
    SET @ngaygiogd = GETDATE()

    DECLARE @getMACN CHAR(10)

    SELECT @getMACN = macn
    FROM CHINHANH
    WHERE macn = @MaCN

    DECLARE @getSOTK CHAR(10)

    SELECT @getSOTK = tk.sotk
    FROM TAIKHOAN tk
    WHERE tk.macn = @MaCN AND tk.sotk = @SoTk

    SET @magd = CAST(@ngaygiogd AS CHAR) + RIGHT(@getMACN, 3) + RIGHT(@getSOTK, 7)

    INSERT INTO GIAODICH(magd, macn, sotk, maloaigd, ngaygiogd ,tiengd) VALUES
    (@magd, @MaCN, @SoTk, @MaLoaiGD, @ngaygiogd, @tiengd)

    RETURN 0
END

DECLARE @flag INT 
EXEC sp_CreateNewTransaction_23127379 'CN001', '0010000111', '2', 100, @flag OUTPUT
