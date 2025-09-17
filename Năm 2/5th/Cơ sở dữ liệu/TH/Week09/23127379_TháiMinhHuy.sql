USE QLYDETAI

-- Cho biết thông tin mã và tên người quản lý của giáo viên 
-- tham gia nhiều đề tài có tên liên quan đến chủ đề giáo dục nhất. 
SELECT ql.MAGV, ql.HOTEN
FROM GIAOVIEN ql JOIN GIAOVIEN gv ON ql.GVQLCM = gv.MAGV 
    JOIN THAMGIADT tg ON tg.MAGV = gv.MAGV
    JOIN DETAI dt ON dt.MADT = tg.MADT
    JOIN CHUDE cd ON cd.MACD = dt.MACD
WHERE cd.TENCD LIKE N'%giáo dục'
GROUP BY ql.MAGV, ql.HOTEN, gv.MAGV
HAVING COUNT(DISTINCT tg.MADT) >= ALL (
    SELECT COUNT(DISTINCT dt.MADT)
    FROM DETAI dt JOIN CHUDE cd ON dt.MACD = cd.MACD
    WHERE cd.TENCD LIKE N'%giáo dục'
    GROUP BY dt.MADT
)

-- Cho biết trưởng khoa của giáo viên chủ nhiệm đề tài 
-- có tất cả giáo viên có họ Nguyễn hơn 30 tuổi tham gia.
-- Thương: MAGV
-- Số chia: MADT
-- Số bị chia: MAGV, MADT 

SELECT tk.MAGV, tk.HOTEN
FROM DETAI dt JOIN GIAOVIEN gv ON dt.GVCNDT = gv.MAGV
    JOIN BOMON bm ON gv.MABM = bm.MABM
    JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
    JOIN GIAOVIEN tk ON tk.MAGV = k.TRUONGKHOA
WHERE NOT EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv 
    WHERE gv.HOTEN LIKE N'Nguyễn%' AND DATEDIFF(YY, gv.NGSINH, GETDATE()) > 30
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg 
    WHERE tg.MADT = dt.MADT
)
AND EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv 
    WHERE gv.HOTEN LIKE N'Nguyễn%' AND DATEDIFF(YY, gv.NGSINH, GETDATE()) > 30
)

GO 
CREATE OR ALTER PROCEDURE sp_ThemPC_23127379 
    @MaGV VARCHAR(10),
    @MaDT NVARCHAR(10),
    @STT INT,
    @PHUCAP FLOAT,
    @KQ INT OUT
AS
BEGIN
    SET @KQ = 0
    IF @MaGV IS NULL
    BEGIN
        ;THROW 50001, 'LỖI MAGV RỖNG', 1
        SET @KQ = 1
        RETURN 1
    END 
    
    IF @MaDT IS NULL
    BEGIN
        ;THROW 50002, 'LỖI MADT RỖNG', 1
        SET @KQ = 1
        RETURN 1
    END 
    
    IF (NOT EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @MaGV) OR (NOT EXISTS(SELECT * FROM CONGVIEC WHERE MADT = @MaDT AND STT = @STT)))
    BEGIN
        ;THROW 50003, 'Lỗi không tồn tại', 1
        SET @KQ = 1
        RETURN 1
    END

    IF @PHUCAP < 0
    BEGIN
        ;THROW 50004, 'Lỗi phụ cấp âm', 1
        SET @KQ = 1
        RETURN 1
    END

    DECLARE @SL INT = 0
    SELECT @SL = ISNULL(COUNT(*), 0)
    FROM THAMGIADT tg 
    WHERE tg.MAGV = @MaGV AND tg.MADT = @MaDT

    IF (@PHUCAP > ANY(SELECT TG.PHUCAP 
                      FROM THAMGIADT TG 
                      WHERE TG.MADT = @MADT AND 
                            TG.MAGV IN (SELECT QL.MAGV                                         
                                        FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM 
                                                         JOIN KHOA K ON K.MAKHOA = BM.MAKHOA 
                                                         JOIN GIAOVIEN QL ON (QL.MAGV = K.TRUONGKHOA OR QL.MAGV = BM.TRUONGBM)
                                        WHERE GV.MAGV = @MAGV)
                    )) RETURN 1

    INSERT INTO THAMGIADT(MAGV, MADT, STT, PHUCAP) VALUES (@MaGV, @MaDT, @STT, @PHUCAP)
END

GO 
CREATE OR ALTER PROCEDURE sp_InKhoa_23127379 
    @MaKhoa VARCHAR(10),
    @KQ INT OUT
AS
BEGIN
    SET @KQ = 0
    IF @MaKhoa IS NULL
    BEGIN
        ;THROW 50001, 'Lỗi mã khoa rỗng', 1
        SET @KQ = 1
        RETURN 1
    END
    
    IF (NOT EXISTS(SELECT * FROM KHOA WHERE MAKHOA = @MaKhoa))
    BEGIN
        ;THROW 50002, 'Mã khoa không tồn tại', 1
        SET @KQ = 1
        RETURN 1
    END

    DECLARE @TenKhoa NVARCHAR(100)
    DECLARE @TenTK NVARCHAR(100)
    DECLARE @SLBM INT 
    DECLARE @SLGV INT

    SELECT @TenKhoa = k.TENKHOA,
           @TenTK = ISNULL(tk.HOTEN, '-'),
           @SLBM = COUNT(DISTINCT bm.MABM),
           @SLGV = COUNT(gv.MAGV)
    FROM KHOA k LEFT JOIN GIAOVIEN tk ON k.TRUONGKHOA = tk.MAGV
        LEFT JOIN BOMON bm ON k.MAKHOA = bm.MAKHOA
        LEFT JOIN GIAOVIEN gv ON gv.MABM = bm.MABM
    WHERE k.MAKHOA = @MaKhoa
    GROUP BY k.MAKHOA, k.TENKHOA, tk.HOTEN

    PRINT N'Khoa: ' + @TenKhoa
    PRINT N'Tên trưởng khoa: ' + @TenTK
    PRINT N'Số lượng bộ môn: ' + CAST(@SLBM AS NVARCHAR)
    PRINT N'Số lượng giáo viên: ' + CAST(@SLGV AS NVARCHAR)
END

DECLARE @KQ1 INT
EXEC sp_InKhoa_23127379 'CNTT', @KQ1 OUTPUT


-- Tìm những giáo viên chủ nhiệm ít nhất 1 đề tài thuộc chủ đề Quản lý giáo dục

SELECT gv.MAGV, gv.HOTEN 
FROM DETAI dt JOIN GIAOVIEN gv ON dt.GVCNDT = gv.MAGV
    JOIN CHUDE cd ON cd.MACD = dt.MACD
WHERE cd.TENCD = N'Quản lý giáo dục'
GROUP BY dt.GVCNDT, gv.HOTEN, gv.MAGV
HAVING COUNT(dt.MADT) >= 1

-- Tìm đề tài mà tất cả giáo viên tham gia đều có ít nhất 2 số điện thoại
-- Thương: MADT
-- Số chia: MAGV
-- Số bị chia: MAGV, MADT

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv JOIN GV_DT gvdt ON gv.MAGV = gvdt.MAGV
    GROUP BY gv.MAGV
    HAVING COUNT(gvdt.DIENTHOAI) >= 2
    EXCEPT 
    SELECT tg.MAGV
    FROM THAMGIADT tg 
    WHERE tg.MADT = dt.MADT
)
AND EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv JOIN GV_DT gvdt ON gv.MAGV = gvdt.MAGV
    GROUP BY gv.MAGV
    HAVING COUNT(gvdt.DIENTHOAI) >= 2
)