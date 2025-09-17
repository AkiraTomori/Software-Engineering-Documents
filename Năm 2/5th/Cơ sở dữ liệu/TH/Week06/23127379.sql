USE QLYDETAI

-- Với mỗi bộ môn, cho biết tên bộ môn và só lượng giáo viên của bộ môn đó.

-- Nếu đặt truy vấn con ở SELECT
-- Kết quả của câu truy vấn sẽ là giá trị của một thuộc tính
SELECT BM.TENBM, (SELECT COUNT(*)
                            FROM GIAOVIEN GV
                            WHERE GV.MABM = BM.MABM)
FROM BOMON BM
-- Nếu đặt tại mệnh đề FROM
-- Kết quả của cấu truy vấn sẽ xem như là một bảng dữ liệu, do
-- đó có thể truy vấn từ bảng dữ liệu này

-- Ví dụ:
-- Cho biết họ tên và lương của các giáo viên bộ môn HTTT

SELECT T.HOTEN, T.LNG
FROM (SELECT MAGV, HOTEN, LUONG as LNG
        FROM GIAOVIEN
        WHERE MABM = N'HTTT') AS T

-- Đặt tại mệnh đề WHERE
-- Kết quả của câu truy vấn được sử dụng như một thành phần 
-- trong biểu thức điều kiện.
-- VD: Cho biết những giáo viên có lương lớn hơn lương của giáo viên có MAGV = '001'
SELECT *
FROM GIAOVIEN
WHERE LUONG > (SELECT LUONG
                FROM GIAOVIEN
                WHERE MAGV = N'001')

-- VD: Lấy giáo viên lương < luong trưởng bộ môn HTTT
SELECT *
FROM GIAOVIEN
WHERE LUONG < ANY (SELECT distinct gv.LUONG
                FROM GIAOVIEN GV, BOMON BM
                WHERE GV.MAGV = bm.TRUONGBM and BM.MABM = N'HTTT')


SELECT gv.*
FROM GIAOVIEN gv, (SELECT gv.LUONG
                    FROM GIAOVIEN gv, BOMON BM
                    WHERE gv.MAGV = bm.TRUONGBM AND bm.MABM = N'HTTT') T
WHERE gv.LUONG < T.LUONG

SELECT GV.*
FROM GIAOVIEN gv, (SELECT AVG(GV2.LUONG) LTB
                    FROM GIAOVIEN GV2
                    WHERE GV2.MABM = N'HTTT') T
WHERE gv.LUONG < T.LTB


-- Tìm giáo viên không tham gia đề tài (dùng in/not in)
SELECT *
FROM GIAOVIEN gv1
WHERE gv1.MAGV NOT IN (SELECT DISTINCT tg.MAGV from THAMGIADT tg)

SELECT *
FROM GIAOVIEN gv1
WHERE gv1.MAGV <> ALL (SELECT DISTINCT tg.MAGV from THAMGIADT tg)

SELECT *
FROM GIAOVIEN gv1
WHERE NOT EXISTS(SELECT * 
                FROM THAMGIADT tg 
                WHERE tg.MAGV = gv1.MAGV)
-- Tìm những giáo viên tham gia đề tài
SELECT *
FROM GIAOVIEN gv1
WHERE gv1.MAGV IN (SELECT DISTINCT tg.MAGV FROM THAMGIADT tg)

-- GV có lương lớn nhất
SELECT * FROM GIAOVIEN gv1 WHERE gv1.LUONG >= ALL (SELECT LUONG FROM GIAOVIEN)

SELECT * FROM GIAOVIEN gv1 WHERE gv1.LUONG = (SELECT MAX(LUONG) FROM GIAOVIEN)

SELECT * FROM GIAOVIEN gv1 WHERE NOT EXISTS(SELECT *
                                            FROM GIAOVIEN gv2
                                            WHERE gv2.LUONG > gv1.LUONG)
-- Giáo viên tham gia nhiều đề tài nhất
SELECT gv.MAGV, gv.HOTEN, COUNT(DISTINCT tg.MADT) as SLDT
FROM GIAOVIEN gv join THAMGIADT tg on gv.MAGV = tg.MAGV
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(DISTINCT tg.MADT) >= ALL(SELECT COUNT(DISTINCT TG2.MADT) FROM THAMGIADT TG2 GROUP BY TG2.MAGV)

-- 39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin
SELECT gv.HOTEN
FROM GIAOVIEN gv, BOMON bm, KHOA k
WHERE GV.MABM = bm.MABM and bm.MAKHOA = k.MAKHOA and k.MAKHOA = N'CNTT' AND DATEDIFF(yy, gv.NGSINH, GETDATE()) <= ALL (SELECT DATEDIFF(yy, gv2.NGSINH, GETDATE())
                                            FROM GIAOVIEN gv2, BOMON bm2, KHOA k2
                                            WHERE gv2.MABM = bm2.MABM and bm2.MAKHOA = k2.MAKHOA AND k2.MAKHOA = N'CNTT')

-- 40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất
SELECT gv.HOTEN, k.TENKHOA
FROM GIAOVIEN gv, KHOA k, BOMON bm
WHERE gv.MABM = bm.MABM and k.MAKHOA = bm.MAKHOA AND gv.LUONG >= ALL (SELECT MAX(gv2.LUONG) 
                                                                FROM GIAOVIEN gv2)

-- 44. Cho biết tên những giáo viên thuộc khoa CNTT mà chưa tham gia đề tài nào.
SELECT gv.HOTEN
FROM GIAOVIEN gv, BOMON bm, KHOA k
WHERE gv.MABM = bm.MABM AND bm.MAKHOA = k.MAKHOA AND k.MAKHOA = N'CNTT' AND GV.MAGV NOT IN (SELECT DISTINCT tg.MAGV
                                                                                            FROM THAMGIADT tg
                                                                                            )
-- 48. Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT gv.*
FROM GIAOVIEN gv
WHERE EXISTS (
        SELECT gv2.*
        FROM GIAOVIEN gv2
        WHERE gv2.HOTEN = gv.HOTEN
        AND gv2.PHAI = gv.PHAI
        AND gv2.MABM = gv.MABM
        AND gv2.MAGV <> gv.MAGV
)

-- 51. Cho biết tên khoa có đông giáo viên nhất

SELECT k.TENKHOA
FROM KHOA k, GIAOVIEN gv, BOMON bm
WHERE k.MAKHOA = bm.MAKHOA AND bm.MABM = gv.MABM
GROUP BY k.MAKHOA, k.TENKHOA
HAVING COUNT(gv.MAGV) >= ALL (SELECT COUNT(gv2.MAGV)
                                FROM GIAOVIEN gv2 JOIN BOMON bm2 ON gv2.MABM = bm2.MABM
                                GROUP BY bm2.MAKHOA)

-- 57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất.
SELECT gv.HOTEN, COUNT(tg.MADT)
FROM BOMON bm, GIAOVIEN gv, THAMGIADT tg
WHERE bm.TRUONGBM = gv.MAGV and gv.MAGV = tg.MAGV
GROUP BY gv.MAGV, tg.MADT, gv.HOTEN
HAVING COUNT(tg.MADT) >= ALL (SELECT COUNT(DISTINCT tg2.MADT)
                                        FROM THAMGIADT tg2
                                        GROUP BY tg2.MAGV 
                                        )

SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv, DETAI dt, BOMON bm
WHERE gv.MAGV = dt.GVCNDT and bm.TRUONGBM = gv.MAGV
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(DT.MADT) >= ALL (
        SELECT count(tmp.GVCNDT)
        FROM DETAI tmp join BOMON bm on tmp.GVCNDT = bm.TRUONGBM
        GROUP BY tmp.GVCNDT
)
