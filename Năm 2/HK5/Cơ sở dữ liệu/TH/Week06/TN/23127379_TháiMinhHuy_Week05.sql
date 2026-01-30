USE QLYDETAI
-- Q.35. Cho biết mức lương cao nhất của các giảng viên
SELECT DISTINCT gv.LUONG "Lương cao nhất trong các giảng viên"
FROM GIAOVIEN gv
WHERE gv.LUONG = (
    SELECT MAX(LUONG)
    FROM GIAOVIEN
)

-- Q.36. Cho biết những giáo viên có lương lớn nhất
SELECT gv.HOTEN 'Họ tên'
FROM GIAOVIEN gv
WHERE gv.LUONG >= (
    SELECT MAX(gv2.LUONG)
    FROM GIAOVIEN gv2
)

-- Q.37. Cho biết lương cao nhất trong bộ môn "HTTT"
SELECT gv.LUONG "Lương cao nhất trong bộ môn HTTT"
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM 
WHERE bm.MABM = N'HTTT' AND gv.LUONG >= (SELECT MAX(gv2.LUONG) FROM GIAOVIEN gv2)

-- Q.38. Cho biết tên giáo viên lớn tuổi nhất của bộ môn HTTT
SELECT gv.HOTEN "Họ tên" 
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
WHERE bm.MABM = N'HTTT' AND DATEDIFF(yy, gv.NGSINH, GETDATE()) >= ALL (
    SELECT DATEDIFF(yy, gv2.NGSINH, GETDATE()) 
    FROM GIAOVIEN gv2 JOIN BOMON bm2 ON gv2.MABM = bm2.MABM
    WHERE bm2.MABM = N'HTTT'
)

-- Q.39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin
SELECT gv.HOTEN "Họ tên"
FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM 
              JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
WHERE k.MAKHOA = N'CNTT' AND gv.NGSINH >= ALL(
    SELECT gv2.NGSINH
    FROM BOMON bm2 JOIN GIAOVIEN gv2 ON bm2.MABM = gv2.MABM
    JOIN KHOA k2 ON bm2.MAKHOA = k2.MAKHOA
    WHERE bm2.MAKHOA = N'CNTT'
)

-- Q.40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất
SELECT gv.HOTEN 'Tên giáo viên', k.TENKHOA 'Tên khoa' 
FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
              JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
WHERE gv.LUONG >= ALL(
    SELECT MAX(gv2.LUONG)
    FROM GIAOVIEN gv2
)

-- Q.41. Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ
SELECT gv.HOTEN 'Tên giáo viên', gv.MABM 'Bộ môn'
FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
WHERE gv.LUONG >= ALL (
    SELECT MAX(gv2.LUONG) 
    FROM BOMON bm2 JOIN GIAOVIEN gv2 ON bm2.MABM = gv2.MABM
    GROUP BY bm2.MABM
)

-- Q.42. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia
SELECT TENDT
FROM DETAI
WHERE MADT NOT IN(
    SELECT MADT
    FROM THAMGIADT tg, GIAOVIEN gv
    WHERE tg.MAGV = gv.MAGV and gv.HOTEN = N'Nguyễn Hoài An'
)

-- Q.43. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài và người chủ nhiệm đề tài
SELECT GIAOVIEN.HOTEN, DETAI.TENDT
FROM DETAI, GIAOVIEN
WHERE GIAOVIEN.MAGV = DETAI.GVCNDT AND MADT NOT IN(
    SELECT MADT
    FROM THAMGIADT tg, GIAOVIEN gv
    WHERE tg.MAGV = gv.MAGV and gv.HOTEN = N'Nguyễn Hoài An'
)

-- Q.44. Cho biết tên của những giảng viên khoa CNTT mà chưa tham gia đề tài nào
SELECT gv.HOTEN 
FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
              JOIN KHOA k ON bm.MAKHOA = k.MAKHOA
WHERE k.TENKHOA = N'Công nghệ thông tin' AND gv.MAGV NOT IN (SELECT tg.MAGV FROM THAMGIADT tg)

-- Q.45. Tìm những giáo viên không tham gia bất kì đề tài nào
SELECT MAGV, HOTEN
FROM GIAOVIEN 
WHERE MAGV NOT IN (SELECT MAGV FROM THAMGIADT)

-- Q.46. Cho biết giáo viên có lương hơn giáo viên "Nguyễn Hoài An"
SELECT HOTEN
FROM GIAOVIEN
WHERE LUONG > (SELECT LUONG FROM GIAOVIEN gv2 WHERE gv2.HOTEN = N'Nguyễn Hoài An')

-- Q.47. Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài
SELECT DISTINCT gv.HOTEN
FROM GIAOVIEN gv, THAMGIADT tg, BOMON bm
WHERE bm.TRUONGBM = gv.MAGV AND tg.MAGV = gv.MAGV AND GV.MAGV IN (
    SELECT MAGV
    FROM THAMGIADT
    GROUP BY MAGV
    HAVING COUNT(MADT) > 1
)

-- Q.48. Tìm những giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
SELECT gv1.HOTEN
FROM GIAOVIEN gv1
WHERE EXISTS(
    SELECT gv2.*
    FROM GIAOVIEN gv2
    WHERE gv2.HOTEN = gv1.HOTEN
    AND gv2.PHAI = gv1.PHAI
    AND gv2.MABM = gv1.MABM
    AND gv2.MAGV <> gv1.MAGV
)

-- Q.49. Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn "Công nghệ phần mềm"
SELECT gv.HOTEN
FROM GIAOVIEN gv
WHERE gv.LUONG >= ANY (
    SELECT gv2.LUONG
    FROM GIAOVIEN gv2, BOMON bm
    WHERE gv2.MABM = bm.MABM AND bm.TENBM = N'Công nghệ phần mềm'
)

-- Q.50. Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn "Hệ thống thông tin"
SELECT gv.HOTEN
FROM GIAOVIEN gv
WHERE gv.LUONG >= ALL (
    SELECT gv2.LUONG
    FROM GIAOVIEN gv2, BOMON bm
    WHERE gv2.MABM = bm.MABM AND bm.TENBM = N'Hệ thống thông tin'
)

-- Q.51. Cho biết tên khoa có đông giáo viên nhất
SELECT k.TENKHOA
FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
              JOIN KHOA k ON k.MAKHOA = bm.MAKHOA
GROUP BY k.MAKHOA, k.TENKHOA
HAVING COUNT(gv.MAGV) >= ALL (
    SELECT COUNT(gv2.MAGV)
    FROM GIAOVIEN gv2 JOIN BOMON bm2 ON gv2.MABM = bm2.MABM
    GROUP BY bm2.MAKHOA
)
-- Q.52. Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
SELECT gv.HOTEN
FROM GIAOVIEN gv JOIN DETAI dt ON gv.MAGV = dt.GVCNDT
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(dt.MADT) >= ALL (
    SELECT COUNT(detai.MADT)
    FROM DETAI detai
    GROUP BY GVCNDT
)

-- Q.53. Cho biết mã bộ môn có nhiều giáo viên nhất
SELECT bm.MABM
FROM BOMON bm JOIN GIAOVIEN gv ON bm.MABM = gv.MABM
GROUP BY bm.MABM
HAVING COUNT(gv.MAGV) >= ALL (
    SELECT COUNT(gv2.MAGV)
    FROM GIAOVIEN gv2 
    GROUP BY gv2.MABM
)

-- Q.54. Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất
SELECT gv.MAGV, gv.HOTEN, bm.TENBM
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
                 JOIN THAMGIADT tg ON tg.MAGV = gv.MAGV
GROUP BY gv.MAGV, gv.HOTEN, bm.TENBM
HAVING COUNT(DISTINCT tg.MADT) >= ALL(
    SELECT COUNT(DISTINCT tg.MADT)
    FROM THAMGIADT tg
    GROUP BY tg.MAGV
)

-- Q.55. Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT
SELECT DISTINCT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
                 JOIN THAMGIADT tg on gv.MAGV = tg.MAGV
WHERE bm.TENBM = N'Hệ thống thông tin'
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(DISTINCT tg.MADT) >= ALL(
    SELECT COUNT(DISTINCT tg.MADT)
    FROM THAMGIADT tg
    GROUP BY tg.MAGV
)

-- Q.56. Cho biết tên giáo viên và tên bộ môn có nhiều người thân nhất
SELECT gv.MAGV, gv.HOTEN, bm.TENBM
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MABM = bm.MABM
                 JOIN NGUOITHAN nt ON gv.MAGV = nt.MAGV
GROUP BY gv.MAGV, gv.HOTEN, bm.TENBM
HAVING COUNT(gv.MAGV) >= ALL(
    SELECT COUNT(nt.MAGV)
    FROM NGUOITHAN nt 
    GROUP BY nt.MAGV
)

-- Q.57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất
SELECT gv.MAGV, gv.HOTEN
FROM GIAOVIEN gv JOIN BOMON bm ON bm.TRUONGBM = gv.MAGV
                 JOIN DETAI dt ON dt.GVCNDT = gv.MAGV
GROUP BY gv.MAGV, gv.HOTEN
HAVING COUNT(dt.MADT) >= ALL(
    SELECT COUNT(dt.MADT)
    FROM DETAI dt JOIN BOMON bm ON dt.GVCNDT = bm.TRUONGBM
    GROUP BY bm.TRUONGBM
)
