USE QLYDETAI

-- Q.58: Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề
-- T: MAGV, TENGV (THAMGIADT)
-- S: MACD (CHUDE)
-- R: MAGV, TENGV, MACD (GIAOVIEN)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT cd1.MACD
    FROM CHUDE cd1
    EXCEPT
    SELECT dt.MACD
    FROM DETAI dt JOIN THAMGIADT tg ON dt.MADT = tg.MADT
    WHERE tg.MAGV = gv.MAGV
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT *
    FROM CHUDE cd
    WHERE NOT EXISTS(
        SELECT *
        FROM DETAI dt JOIN THAMGIADT tg ON dt.MADT = tg.MADT
        WHERE dt.MACD = cd.MACD AND tg.MAGV = gv.MAGV
    )
)
-- Q.59: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia
-- Thương: MADT, TENDT (DETAI)
-- Chia: MAGV(GIAOVIEN)
-- Bị chia: MAGV, MADT, TENDT.

SELECT dt.MADT, dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv
    WHERE gv.MABM = N'HTTT'
    EXCEPT
    SELECT tg.MAGV
    FROM THAMGIADT tg
    WHERE tg.MADT = dt.MADT 
)

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT *
    FROM GIAOVIEN gv
    WHERE gv.MABM = N'HTTT'
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = gv.MAGV AND dt.MADT = tg.MADT
    )
)

-- Q.60. Cho biết tên đề tài có tất cả các giảng viên bộ môn "Hệ thống thông tin" tham gia
-- Thương: MADT, TENDT
-- Số chia: MAGV
-- Số bị chia: MAGV, MADT, TENDT

SELECT dt.MADT, dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
    WHERE bm.TENBM = N'Hệ thống thông tin'
    EXCEPT
    SELECT tg.MAGV
    FROM THAMGIADT tg
    WHERE tg.MADT = dt.MADT
)
AND EXISTS(
    SELECT gv2.MAGV
    FROM GIAOVIEN gv2 JOIN BOMON bm2 ON gv2.MABM = bm2.MABM
    WHERE bm2.TENBM = N'Hệ thống thông tin'
)

SELECT dt.MADT, dt.TENDT
FROM DETAI dt
WHERE NOT EXISTS(
    SELECT *
    FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
    WHERE bm.TENBM = N'Hệ thống thông tin'
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg
        WHERE tg.MAGV = gv.MAGV AND tg.MADT = dt.MADT
    )
)
-- Q.61. Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD
-- Thương: MAGV, TENGV
-- Số chia: MADT 
-- Số bị chia: MAGV, TENGV, MADT
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT dt.MADT
    FROM DETAI dt
    WHERE dt.MACD = N'QLGD'
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg
    WHERE tg.MAGV = gv.MAGV
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT *
    FROM DETAI dt
    WHERE dt.MACD = N'QLGD'
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MAGV = gv.MAGV AND tg.MADT = dt.MADT
    )
)

-- Q.62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia
-- Thương: MAGV, TENGV
-- Số chia: MADT
-- Số bị chia: MAGV, TENGV, MADT
SELECT gv.MAGV, gv.HOTEN 
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT tg.MADT
    FROM THAMGIADT tg
    WHERE tg.MAGV = (
        SELECT gv2.MAGV
        FROM GIAOVIEN gv2
        WHERE gv2.HOTEN = N'Trần Trà Hương'
    )
    EXCEPT
    SELECT tg2.MADT
    FROM THAMGIADT tg2
    WHERE tg2.MAGV = gv.MAGV
)
AND EXISTS(
    SELECT tg.MADT
    FROM THAMGIADT tg
    WHERE tg.MAGV = (
        SELECT gv2.MAGV
        FROM GIAOVIEN gv2
        WHERE gv2.HOTEN = N'Trần Trà Hương'
    )
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT *
    FROM THAMGIADT tg JOIN GIAOVIEN gv2 ON tg.MAGV = gv2.MAGV
    WHERE gv2.HOTEN = N'Trần Trà Hương'
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg2
        WHERE tg2.MADT = tg.MADT AND tg2.MAGV = gv.MAGV
    )
)

-- Q.63. Cho biết tên đề tài nào mà được tất cả các giảng viên của bộ môn Hóa Hữu Cơ tham gia
-- Thương: MADT, TENDT
-- Số chia: MAGV
-- Số bị chia: MAGV, MADT, TENDT

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
    WHERE bm.TENBM = N'Hóa huữ cơ'
    EXCEPT
    SELECT tg.MAGV
    FROM THAMGIADT tg 
    WHERE tg.MADT = dt.MADT
)
AND EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv
    WHERE gv.MABM = (
        SELECT bm.MABM
        FROM BOMON bm
        WHERE bm.TENBM = N'Hóa hữu cơ'
    )
)

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT *
    FROM GIAOVIEN gv 
    WHERE gv.MABM = (
        SELECT bm.MABM
        FROM BOMON bm
        WHERE bm.TENBM = N'Hóa hữu cơ'
    ) 
    AND NOT EXISTS(
        SELECT * 
        FROM THAMGIADT tg
        WHERE tg.MADT = dt.MADT AND tg.MAGV = gv.MAGV
    )
)
AND EXISTS(
    SELECT gv.MAGV
    FROM GIAOVIEN gv
    WHERE gv.MABM = (
        SELECT bm.MABM
        FROM BOMON bm
        WHERE bm.TENBM = N'Hóa hữu cơ')
)
-- Q.64 Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006
-- Thương: MAGV, HOTEN
-- Số chia: STT
-- Số bị chia: MAGV, HOTEN, STT

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT cv.STT
    FROM CONGVIEC cv
    WHERE cv.MADT = N'006'
    EXCEPT
    SELECT tg.STT
    FROM THAMGIADT tg 
    WHERE tg.MAGV = gv.MAGV AND tg.MADT = N'006'
)
AND EXISTS(
    SELECT cv.STT
    FROM CONGVIEC cv
    WHERE cv.MADT = N'006'
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT * 
    FROM CONGVIEC cv 
    WHERE cv.MADT = N'006'
    AND NOT EXISTS(
        SELECT * 
        FROM THAMGIADT tg 
        WHERE tg.STT = cv.STT AND tg.MADT = N'006' AND tg.MAGV = gv.MAGV
    )
)
AND EXISTS(
    SELECT * 
    FROM CONGVIEC cv 
    WHERE cv.MADT = N'006'
)
-- Q.65: Cho biết tên giáo viên nào đã tham gia tất cả đề tài của chủ đề Ứng dụng công nghệ
-- Thương: MAGV, HOTEN
-- Số chia: MADT
-- Số bị chia: MAGV, HOTEN, MADT

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT dt.MADT 
    FROM DETAI dt JOIN CHUDE cd ON dt.MACD = cd.MACD
    WHERE cd.TENCD = N'Ứng dụng công nghệ'
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg 
    WHERE tg.MAGV = gv.MAGV
)
AND EXISTS(
    SELECT dt.MADT 
    FROM DETAI dt JOIN CHUDE cd ON dt.MACD = cd.MACD
    WHERE cd.TENCD = N'Ứng dụng công nghệ'
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT *
    FROM DETAI dt JOIN CHUDE cd ON dt.MACD = cd.MACD
    WHERE cd.TENCD = N'Ứng dụng công nghệ' 
    AND NOT EXISTS(
        SELECT * 
        FROM THAMGIADT tg 
        WHERE tg.MAGV = gv.MAGV AND tg.MADT = dt.MADT 
    )
)
AND EXISTS(
    SELECT *
    FROM DETAI dt JOIN CHUDE cd ON dt.MACD = cd.MACD
    WHERE cd.TENCD = N'Ứng dụng công nghệ' 
)

-- Q.66: Cho biết tên giáo viên nào đã tham gia tất các đề tài do Trần Trà Hương làm chủ nhiệm
-- Thương: MAGV, HOTEN 
-- Số chia: MADT 
-- Số bị chia: MAGV, HOTEN, MADT 

SELECT gv.MAGV, gv.HOTEN 
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT dt.MADT
    FROM DETAI dt 
    WHERE dt.GVCNDT = (
        SELECT gv2.MAGV
        FROM GIAOVIEN gv2 
        WHERE gv2.HOTEN = N'Trần Trà Hương'
    ) 
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg
    WHERE tg.MAGV = gv.MAGV 
)
AND EXISTS(
    SELECT dt.MADT
    FROM DETAI dt 
    WHERE dt.GVCNDT = (
        SELECT gv2.MAGV
        FROM GIAOVIEN gv2 
        WHERE gv2.HOTEN = N'Trần Trà Hương'
    ) 
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT *
    FROM DETAI dt 
    WHERE dt.GVCNDT = (
        SELECT gv2.MAGV
        FROM GIAOVIEN gv2
        WHERE gv2.HOTEN = N'Trần Trà Hương' 
    )
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MADT = dt.MADT AND tg.MAGV = gv.MAGV
    )
)
AND EXISTS(
    SELECT *
    FROM DETAI dt 
    WHERE dt.GVCNDT = (
        SELECT gv2.MAGV
        FROM GIAOVIEN gv2
        WHERE gv2.HOTEN = N'Trần Trà Hương' 
    )
)

-- Q.67. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia.
-- Thương: MADT, TENDT 
-- Số chia: MAGV 
-- Số bị chia: MAGV, MADT, TENDT 

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT gv.MAGV 
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.MAKHOA = N'CNTT'
    EXCEPT
    SELECT tg.MAGV
    FROM THAMGIADT tg
    WHERE tg.MADT = dt.MADT 
)
AND EXISTS(
    SELECT gv.MAGV 
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.MAKHOA = N'CNTT'
)

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT *
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.MAKHOA = N'CNTT'
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MADT = dt.MADT AND tg.MAGV = gv.MAGV
    )
)
AND EXISTS(
    SELECT *
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.MAKHOA = N'CNTT'
)

--Q68. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc.
-- Thương: MAGV, HOTEN
-- Số chia: STT
-- Số bị chia: MAGV, HOTEN, STT

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT cv.STT
    FROM CONGVIEC cv 
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    )
    EXCEPT
    SELECT tg.STT
    FROM THAMGIADT tg 
    WHERE tg.MAGV = gv.MAGV AND tg.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    )
)
AND EXISTS(
    SELECT cv.STT
    FROM CONGVIEC cv 
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    )
)

SELECT gv.MAGV, gv.HOTEN 
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT * 
    FROM CONGVIEC cv 
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    )
    AND NOT EXISTS(
        SELECT * 
        FROM THAMGIADT tg 
        WHERE tg.STT = cv.STT AND tg.MAGV = gv.MAGV 
        AND tg.MADT = (
            SELECT dt.MADT
            FROM DETAI dt 
            WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
        )
    )
)
AND EXISTS(
    SELECT * 
    FROM CONGVIEC cv 
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Nghiên cứu tế bào gốc'
    )
)
--Q69. Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu?
-- Thương: MAGV, HOTEN
-- Số chia: MADT
-- Số bị chia: MADT, MAGV, HOTEN

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT dt.MADT
    FROM DETAI dt 
    WHERE dt.KINHPHI > 100
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg 
    WHERE tg.MAGV = gv.MAGV
) 

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT *
    FROM DETAI dt 
    WHERE dt.KINHPHI > 100
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MAGV = gv.MAGV AND dt.MADT = tg.MADT
    )
)

-- Q.70: Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa Sinh Học tham gia
-- Thương: MADT, TENDT
-- Số chia: MAGV
-- Số bị chia: MAGV, TENDT, MADT

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT gv.MAGV 
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM 
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.TENKHOA = N'Sinh học'
    EXCEPT
    SELECT tg.MAGV
    FROM THAMGIADT tg 
    WHERE tg.MADT = dt.MADT
)
AND EXISTS(
    SELECT gv.MAGV 
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM 
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.TENKHOA = N'Sinh học'
)

SELECT dt.MADT, dt.TENDT
FROM DETAI dt 
WHERE NOT EXISTS(
    SELECT *
    FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM 
                  JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
    WHERE k.TENKHOA = N'Sinh học'
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MADT = dt.MADT AND tg.MAGV = gv.MAGV
    )
)

-- Q.71: Cho biết mã số, họ tên, ngày sinh giáo viên tham gia tất cả các công việc của đề tài
-- "Ứng dụng khoa học xanh"
-- Thương: MAGV, HOTEN, NGSINh
-- Số chia: STT
-- Số bị chia: MAGV, HOTEN, NGSINh, STT 
SELECT gv.MAGV, gv.HOTEN, gv.NGSINH
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT cv.STT
    FROM CONGVIEC cv 
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Ứng dụng khoa học xanh'
    )
    EXCEPT
    SELECT tg.STT
    FROM THAMGIADT tg 
    WHERE tg.MAGV = gv.MAGV AND tg.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Ứng dụng khoa học xanh'
    )
)
AND EXISTS(
    SELECT cv.STT
    FROM CONGVIEC cv 
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt 
        WHERE dt.TENDT = N'Ứng dụng khoa học xanh'
    )
)

SELECT gv.MAGV, gv.HOTEN, gv.NGSINH
FROM GIAOVIEN gv 
WHERE NOT EXISTS(
    SELECT *
    FROM CONGVIEC cv
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt
        WHERE dt.TENDT = N'Ứng dụng khoa học xanh'
    )
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MAGV = gv.MAGV AND tg.STT = cv.STT AND tg.MADT = (
            SELECT dt.MADT
            FROM DETAI dt
            WHERE dt.TENDT = N'Ứng dụng khoa học xanh'
        )
    )
)
AND EXISTS(
    SELECT *
    FROM CONGVIEC cv
    WHERE cv.MADT = (
        SELECT dt.MADT
        FROM DETAI dt
        WHERE dt.TENDT = N'Ứng dụng khoa học xanh'
    )
)

-- Q.72: Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên
-- tham gia tất cả các đề tài thuộc chủ đề "Nghiên cứu phát triển"
-- Thương: MAGV, HOTEN, MABM, TENBM, GVQLCM
-- Số chia: MADT
-- Số bị chia: MAGV, HOTEN, MABM, TENBM, GVQLCM, MADT

SELECT gv.MAGV, gv.HOTEN, bm.MABM, bm.TENBM, gv2.HOTEN 'Người quản lý' 
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
                 LEFT JOIN GIAOVIEN gv2 ON gv.GVQLCM = gv2.MAGV
WHERE NOT EXISTS(
    SELECT dt.MADT
    FROM DETAI dt 
    WHERE dt.MACD = (
        SELECT cd.MACD
        FROM CHUDE cd
        WHERE cd.TENCD = N'Nghiên cứu phát triển'
    )
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg 
    WHERE tg.MAGV = gv.MAGV
)

SELECT gv.MAGV, gv.HOTEN, bm.MABM, bm.TENBM, gv2.HOTEN 'Người quản lý' 
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
                 LEFT JOIN GIAOVIEN gv2 ON gv.GVQLCM = gv2.MAGV
WHERE NOT EXISTS(
    SELECT *
    FROM DETAI dt 
    WHERE dt.MACD = (
        SELECT cd.MACD
        FROM CHUDE cd 
        WHERE cd.TENCD = N'Nghiên cứu phát triển'
    )
    AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg 
        WHERE tg.MAGV = gv.MAGV AND tg.MADT = dt.MADT
    )
)
