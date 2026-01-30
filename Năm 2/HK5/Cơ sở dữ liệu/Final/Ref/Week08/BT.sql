USE QLYDETAI
-- Tìm tất cả giáo viên không tham gia đề tài nào
-- Phép trừ, dùng 3 cách
-- Except (khả hợp)
-- Not Exists (lồng)
-- Not in (lồng)
-- Theo except
    SELECT MAGV
    FROM GIAOVIEN
EXCEPT
    SELECT MAGV
    FROM THAMGIADT

    SELECT gv.MAGV, gv.HOTEN
    FROM GIAOVIEN gv
EXCEPT
    SELECT gv.MAGV, gv.HOTEN
    FROM THAMGIADT tg JOIN GIAOVIEN gv ON tg.MAGV = gv.MAGV
-- Sử dụng not exists
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE NOT EXISTS(
    SELECT *
FROM THAMGIADT tg
WHERE tg.MAGV = gv.MAGV
)
-- Sử dụng not in
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE gv.MAGV NOT IN(
    SELECT DISTINCT tg.MAGV
FROM THAMGIADT tg
)
-- Phép giao
-- Sử dụng toán tử intersects (khả hợp)
-- Exists hoặc In (lồng)
-- Kết bth
-- Tìm các giáo viên vừa tham gia đề tài vừa là trưởng bộ môn
-- Phép giao
    SELECT TRUONGBM
    FROM BOMON
INTERSECT
    SELECT MAGV
    FROM THAMGIADT

-- Sử dụng in and in
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE gv.MAGV IN (
    SELECT bm.TRUONGBM
    FROM BOMON bm
)
    AND gv.MAGV IN (
    SELECT tg.MAGV
    FROM THAMGIADT tg
)

-- Sử dụng exists and exists
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE EXISTS(
    SELECT tg.*
    FROM THAMGIADT tg
    WHERE tg.MAGV = gv.MAGV
)
    AND EXISTS(
    SELECT bm.*
    FROM BOMON bm
    WHERE bm.TRUONGBM = gv.MAGV
)

-- Kết bth
SELECT DISTINCT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MAGV = bm.TRUONGBM
    JOIN THAMGIADT tg on gv.MAGV = tg.MAGV
-- Phép hội
-- Dùng UNION (loại trùng) / UNION ALL (lấy tất)
-- Lồng với Exists hoặc IN

-- Liệt kê những giáo viên có tham gia đề tài và những giáo viên là trưởng bộ môn
    SELECT MAGV
    FROM THAMGIADT
UNION
    SELECT TRUONGBM
    FROM BOMON

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE EXISTS(
    SELECT tg.*
    FROM THAMGIADT tg
    WHERE tg.MAGV = gv.MAGV
) OR EXISTS(
    SELECT bm.*
    FROM BOMON bm
    WHERE bm.TRUONGBM = gv.MAGV
)

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv
WHERE MAGV IN(
    SELECT TRUONGBM
    FROM BOMON bm
) OR MAGV IN(
    SELECT MAGV
    FROM THAMGIADT 
)
-- Phép chia
-- Cú pháp, sử dụng Except
-- Tìm các giáo viên (MAGV) mà tham gia tất cả đề tài
SELECT DISTINCT tg1.MAGV
FROM THAMGIADT tg1
WHERE NOT EXISTS(
            SELECT MADT
    FROM DETAI
EXCEPT
    SELECT tg2.MADT
    FROM THAMGIADT tg2
    WHERE tg2.MAGV = tg1.MAGV
)

-- Sử dụng NOT EXISTS
SELECT DISTINCT tg1.MAGV
FROM THAMGIADT tg1
WHERE NOT EXISTS (
    SELECT dt.*
FROM DETAI dt
WHERE NOT EXISTS(
        SELECT tg2.*
FROM THAMGIADT tg2
WHERE tg2.MADT = dt.MADT AND tg2.MAGV = tg1.MAGV
    )
)

-- Sử dụng gom nhóm
SELECT DISTINCT tg1.MAGV
FROM THAMGIADT tg1
GROUP BY tg1.MAGV
HAVING COUNT(DISTINCT tg1.MADT) = (
    SELECT COUNT(dt.MADT)
FROM DETAI dt
)
-- Tìm tên các giáo viên HTTT mà tham gia tất cả các đề tài thuộc chủ đề "QLGD"
SELECT DISTINCT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv, THAMGIADT dt
WHERE gv.MAGV = dt.MAGV AND gv.MABM = N'HTTT' AND NOT EXISTS(
                    SELECT MADT
        FROM DETAI
        WHERE MACD = N'QLGD'
    EXCEPT
        SELECT MADT
        FROM THAMGIADT dt2
        WHERE dt2.MAGV = dt.MAGV
)

SELECT DISTINCT gv.MAGV, gv.HOTEN
FROM THAMGIADT dt, GIAOVIEN gv
WHERE dt.MAGV = gv.MAGV AND gv.MABM = N'HTTT' AND NOT EXISTS(
    SELECT *
    FROM DETAI
    WHERE MACD = N'QLGD' AND NOT EXISTS(
        SELECT *
        FROM THAMGIADT tg2
        WHERE tg2.MAGV = dt.MAGV AND tg2.MADT = dt.MADT
    )
)

SELECT DISTINCT tg1.MAGV, gv.HOTEN
FROM THAMGIADT tg1, GIAOVIEN gv
WHERE tg1.MAGV = gv.MAGV AND gv.MABM = N'HTTT'
    AND tg1.MADT IN (SELECT MADT
    FROM DETAI
    WHERE MACD = N'QLGD')
GROUP BY tg1.MAGV, gv.HOTEN
HAVING COUNT(DISTINCT tg1.MADT) = (
    SELECT COUNT(MADT)
FROM DETAI
WHERE MACD = N'QLGD'
)

/*LUYỆN TẬP:
1. CHO DANH SÁCH GIÁO VIÊN (ma, ten) THAM GIA TẤT CẢ ĐỀ TÀI 
   DO TRƯỞNG BỘ MÔN HỌ LÀM CHỦ NHIỆM.
   S:DETAI(MADT) DO TRUONGBM CUA MAGV LA CHU NHIEM 
   T:GIAOVIEN(MAGV)
   R:THAMGIA(MAGV, MADT)*/
-- T: MAGV (GIAOVIEN)
-- S: MADT (DETAI)
-- R: THAMGIA(MAGV, MADT)
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv, THAMGIADT tg, DETAI dt, BOMON bm
WHERE gv.MAGV = tg.MAGV AND tg.MADT = dt.MADT
    AND bm.MABM = gv.MABM and bm.TRUONGBM = dt.GVCNDT
GROUP BY gv.MAGV, bm.TRUONGBM, gv.HOTEN
HAVING COUNT(DISTINCT tg.MADT) = (
    SELECT COUNT(*)
FROM DETAI dt
WHERE dt.GVCNDT = bm.TRUONGBM
)

/*
CÁCH 1: SỬ DỤNG GROUP BY, HAVING CHO BÀI TOÁN PHÉP CHIA (TÌM T THOẢ TẤT CẢ S)
 - SỐ BỊ CHIA: R(X, Y)
 - SỐ CHIA: S(Y)
 - THƯƠNG: T(X)
SELECT R.X
FROM R
GROUP BY R.X ==> TRONG R ĐẾM XEM ỨNG VỚI MỖI BỘ T CÓ BAO NHIÊU BỘ S THOẢ MÃN
HAVING COUNT(R.Y) = (SELECT COUNT(S.Y) ==> ĐẾM TỔNG SỐ S CÓ
                     FROM S)
*/

/*
CÁCH 2: SỬ DỤNG PHÉP TRỪ EXCEPT
 - SỐ BỊ CHIA: R(X, Y)
 - SỐ CHIA: S(Y)
 - THƯƠNG: T(X)

/* TÌM S KHÔNG THOẢ T: NẾU TRUY VẤN CON RA RỖNG (NOT EXISTS TRẢ RA TRUE): T LÀ KẾT QUẢ PHÉP CHIA CẦN TÌM 
                                                    ==> KHÔNG CÓ S KHÔNG THOẢ T ==> T THOẢ TẤT CẢ S
                       NÊU TRUY VẤN CON RA ÍT NHẤT 1 DÒNG (NOT EXISTS RA FALSE): T KHÔNG PHẢI KẾT QUẢ PHÉP CHIA CẦN TÌM 
                                                    ==> CÓ ÍT NHẤT 1 S KHÔNG THOẢ T ==> T KHÔNG THOẢ TẤT CẢ */
SELECT T.X
FROM T
WHERE NOT EXISTS (SELECT S.Y -- LẤY TẤT CẢ Y CÓ
                  FROM S 
                  EXCEPT
                  SELECT R.Y -- LẤY CÁC BỘ Y THOẢ T.X Ở TRUY VẤN CHA
                  FROM R
                  WHERE R.X = T.X
                
) */


-- SELECT gv.MAGV, gv.HOTEN
-- FROM GIAOVIEN gv JOIN BOMON bm on gv.MABM = bm.MABM
-- WHERE NOT EXISTS(
--     -- Do trường bộ môn làm chủ nhiệm đề tài
--     SELECT dt.MADT
--     FROM DETAI dt 
--     WHERE dt.GVCNDT = bm.TRUONGBM
--     EXCEPT
--     -- Lấy ra mã đề tài có gv tham gia
--     SELECT tg.MADT
--     FROM THAMGIADT tg
--     WHERE tg.MAGV = gv.MAGV
-- )
-- AND EXISTS( -- Kiểm tra S không rỗng
--     SELECT dt.MADT
--     FROM DETAI dt
--     WHERE dt.GVCNDT = bm.TRUONGBM
-- )
/*LUYỆN TẬP:
1. CHO DANH SÁCH GIÁO VIÊN (ma, ten) THAM GIA TẤT CẢ ĐỀ TÀI 
   DO TRƯỞNG BỘ MÔN HỌ LÀM CHỦ NHIỆM.
   S:DETAI(MADT) DO TRUONGBM CUA MAGV LA CHU NHIEM 
   T:GIAOVIEN(MAGV)
   R:THAMGIA(MAGV, MADT)*/


SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
WHERE NOT EXISTS(
    SELECT dt.MADT
    FROM DETAI dt
    WHERE dt.GVCNDT = bm.TRUONGBM
    EXCEPT
    SELECT tg.MADT
    FROM THAMGIADT tg
    WHERE tg.MAGV = gv.MAGV
)
AND EXISTS(
    SELECT dt.MADT
    FROM DETAI dt
    WHERE dt.GVCNDT = bm.TRUONGBM
)
