USE QLYDETAI
-- Q1. Cho biết họ tên và mức lương của giáo viên nữ
SELECT HOTEN 'Họ và tên', LUONG 'Lương'
FROM GIAOVIEN
WHERE PHAI = N'Nữ'

-- Q2. Cho biết họ tên của các giáo viên và mức lương của họ sao khi tăng 10%
SELECT HOTEN 'Họ và tên', LUONG * 1.1 'Lương'
FROM GIAOVIEN

-- Q3. Cho biết mã giáo viên có họ bắt đầu là 'Nguyễn' và lương trên 2000 hoặc Giáo viên là trưởng bộ môn nhận chức năm 1995
SELECT MAGV
FROM GIAOVIEN gv JOIN BOMON bm ON gv.MAGV = bm.TRUONGBM
WHERE (gv.HOTEN LIKE N'Nguyễn%' AND gv.LUONG > 2000) OR (bm.TRUONGBM IS NOT NULL AND YEAR(BM.NGAYNHANCHUC) = 1995)

-- Q4. Cho biết tên của những giáo viên thuộc khoa CÔNG NGHỆ THÔNG TIN
SELECT HOTEN 'Họ và tên'
FROM GIAOVIEN gv, BOMON bm, KHOA k
WHERE (gv.MABM = bm.MABM) AND (bm.MAKHOA = k.MAKHOA) AND (k.TENKHOA = N'Công nghệ thông tin')

-- Q5. Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
SELECT gv.*
FROM GIAOVIEN gv, BOMON bm
WHERE gv.MAGV = bm.TRUONGBM

-- Q6. Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
SELECT gv.MAGV, gv.HOTEN, gv.LUONG, gv.PHAI, gv.NGSINH, gv.DIACHI, gv.MABM, bm.TENBM
FROM GIAOVIEN gv, BOMON bm
WHERE gv.MABM = bm.MABM

-- Q7. Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
SELECT TENDT, GVCNDT, gv.HOTEN
FROM DETAI detai, GIAOVIEN gv
WHERE detai.GVCNDT = gv.MAGV

-- Q8. Với mỗi khoa, cho biết thông tin của trưởng khoa
SELECT k.TRUONGKHOA 'Mã trưởng khoa', gv.HOTEN 'Họ và tên'
FROM GIAOVIEN gv, KHOA k
WHERE gv.MAGV = k.TRUONGKHOA

-- Q9. Cho biết các giáo viên của bộ môn vi sinh có tham gia đề tài 006
SELECT gv.MAGV 'Mã giáo viên', gv.HOTEN 'Họ và tên'
FROM THAMGIADT tgdetai, GIAOVIEN gv, BOMON bm
WHERE tgdetai.MAGV = gv.MAGV AND gv.MABM = bm.MABM AND (bm.TENBM = N'Vi sinh') AND tgdetai.MADT = '006'

-- Q10. Với những đề tài thuộc cấp quản lý thành phố,
-- Cho biết mã đề tài, đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh và địa chỉ
SELECT detai.MADT 'Mã đề tài', detai.TENDT 'Tên đề tài', detai.GVCNDT 'Mã giáo viên chủ nhiệm đề tài', gv.HOTEN 'Họ và tên', gv.DIACHI 'Địa chỉ'
FROM DETAI detai, CHUDE cd, GIAOVIEN gv
WHERE detai.MACD = cd.MACD AND detai.GVCNDT = gv.MAGV AND CAPQL = N'Thành phố'

-- Q11. Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
SELECT gv2.HOTEN 'Giáo viên quản lý chuyên môn', gv1.HOTEN 'Giáo viên'
FROM GIAOVIEN gv1, GIAOVIEN gv2
WHERE gv2.GVQLCM = gv1.MAGV

-- Q12. Tìm họ tên của những giáo viên được 'Nguyễn Thanh Tùng phụ trách trực tiếp'
SELECT gv.HOTEN
FROM GIAOVIEN gv, GIAOVIEN gv2
WHERE gv.MAGV = gv2.GVQLCM AND gv2.HOTEN = N'Nguyễn Thanh Tùng'

-- Q13. Cho biết tên giáo viên là trưởng bộ môn của hệ thống thông tin
SELECT gv.HOTEN
FROM GIAOVIEN gv, BOMON bm
WHERE gv.MAGV = bm.TRUONGBM AND gv.MABM = bm.MABM AND bm.TENBM = N'Hệ thống thông tin'

-- Q.14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề quản lý giáo dục
SELECT gv.HOTEN 'Họ và tên người chủ nhiệm đề tài'
FROM DETAI detai, CHUDE cd, GIAOVIEN gv
WHERE detai.MACD = cd.MACD AND detai.GVCNDT = gv.MAGV AND cd.TENCD = N'Quản lý giáo dục'

-- Q.15. Cho biết tên các công việc của đề tài "HTTT quản lý các trường đại học" có thời gian bắt đầu trong tháng 3/2008
SELECT cv.TENCV 'Tên công việc'
FROM CONGVIEC cv, DETAI detai
WHERE cv.MADT = detai.MADT AND detai.TENDT = N'HTTT quản lý các trường ĐH' AND MONTH(cv.NGAYBD) = 3 AND YEAR(cv.NGAYBD) = 2008

-- Q.16. Cho biết tên giáo viên và tên người quản lý chuyên môn giáo viên đó
SELECT gv2.HOTEN 'Giáo viên quản lý chuyên môn', gv1.HOTEN 'Giáo viên'
FROM GIAOVIEN gv1, GIAOVIEN gv2
WHERE gv2.GVQLCM = gv1.MAGV

-- Q.17. Cho biết các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2008
SELECT * 
FROM CONGVIEC 
WHERE NGAYBD BETWEEN '2007-01-01' AND '2008-08-01';

-- Q.18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên Trần Trà Hương
SELECT gv2.HOTEN 'Họ tên'
FROM GIAOVIEN gv1, GIAOVIEN gv2
WHERE gv1.MABM = gv2.MABM and GV1.HOTEN = N'Trần Trà Hương' ANd GV2.HOTEN <> N'Trần Trà Hương'

-- Q.19. Tìm những giáo viên vừa trưởng bộ môn vừa chủ nhiệm đề tài
SELECT DISTINCT gv.MAGV 'Mã giáo viên', gv.HOTEN 'Họ tên'
FROM BOMON bm, GIAOVIEN gv, DETAI detai
WHERE bm.TRUONGBM = gv.MAGV AND detai.GVCNDT = gv.MAGV

-- Q.20. Tìm những giáo viên vừa là trưởng khoa vừa trưởng bộ môn
SELECT gv.MAGV 'Mã giáo viên', gv.HOTEN 'Họ tên'
FROM KHOA k, GIAOVIEN gv, BOMON bm
WHERE k.TRUONGKHOA = gv.MAGV AND bm.TRUONGBM = gv.MAGV

-- Q.21. Cho biết tên những trưởng bộ môn chủ nhiệm đề tài
SELECT DISTINCT gv.HOTEN 'Họ và tên'
FROM BOMON bm, GIAOVIEN gv, detai detai
WHERE bm.TRUONGBM = gv.MAGV AND detai.GVCNDT = gv.MAGV

-- Q.22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài
SELECT DISTINCT k.TRUONGKHOA 'Mã số'
FROM KHOA k, GIAOVIEN gv, DETAI detai
WHERE k.TRUONGKHOA = gv.MAGV AND gv.MAGV = detai.GVCNDT

-- Q.23. Cho biết mã số các giảng viên thuộc bộ môn 'HTTT' hoặc có tham gia đề tài có mã '001'
SELECT DISTINCT gv.MAGV 'Mã giáo viên'
FROM GIAOVIEN gv, BOMON bm, THAMGIADT tgdetai
WHERE bm.MABM = gv.MABM AND tgdetai.MAGV = gv.MAGV AND (bm.MABM = N'HTTT' OR tgdetai.MADT = N'001')

-- Q.24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002
SELECT gv2.MAGV 'Mã giáo viên', gv2.HOTEN 'Họ và tên'
FROM GIAOVIEN gv1, GIAOVIEN gv2
WHERE gv1.MABM = gv2.MABM and gv1.MAGV = '002' AND gv2.MAGV <> '002'

-- Q.25. Tìm những giáo viên là trưởng bộ môn
SELECT gv.MAGV 'Mã giáo viên', gv.HOTEN 'Họ và tên'
FROM GIAOVIEN gv, BOMON bm
WHERE gv.MAGV = bm.TRUONGBM

-- Q.26. Cho biết họ tên và mức lương của giáo viên
SELECT HOTEN 'Họ và tên', LUONG 'Lương' 
FROM GIAOVIEN

-- Q.27. Cho biết số lượng giáo viên và tổng lương của họ
SELECT COUNT(MAGV) 'Số lượng giáo viên', SUM(LUONG) 'Tổng lương'
FROM GIAOVIEN

-- Q.28. Cho biết số lượng và lương trung bình của từng bộ môn
SELECT MABM 'Mã bộ môn', AVG(LUONG) 'Lương trung bình'
FROM GIAOVIEN
GROUP BY MABM

-- Q.29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó
SELECT cd.TENCD 'Tên chủ đề', COUNT(detai.MADT) 'Số lượng đề tài'
FROM CHUDE cd JOIN DETAI detai ON cd.MACD = detai.MACD
GROUP BY cd.TENCD

-- Q.30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia
SELECT gv.HOTEN 'Tên giáo viên', COUNT(tgdetai.MADT) 'Số lượng đề tài' 
FROM GIAOVIEN gv JOIN THAMGIADT tgdetai ON gv.MAGV = tgdetai.MAGV
GROUP BY gv.HOTEN, GV.MAGV

-- Q.31 Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm
SELECT gv.HOTEN 'Tên giáo viên', COUNT(GVCNDT) 'Số lượng đề tài'
FROM GIAOVIEN gv JOIN DETAI detai on detai.GVCNDT = gv.MAGV
GROUP BY gv.HOTEN

-- Q.32. Với mỗi giáo viên, cho biết tên giáo viên và số người thân của giáo viên đó
SELECT gv.HOTEN 'Tên giáo viên', COUNT(gv.MAGV) 'Số người thân'
FROM GIAOVIEN gv JOIN NGUOITHAN ngthan ON gv.MAGV = ngthan.MAGV
GROUP BY gv.HOTEN, gv.MAGV

-- Q.33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên
SELECT gv.HOTEN 'Họ tên', COUNT(tgdetai.MADT) 'Số lượng đề tài'
FROM GIAOVIEN gv JOIN THAMGIADT tgdetai ON gv.MAGV = tgdetai.MAGV
GROUP BY gv.HOTEN
HAVING COUNT(DISTINCT tgdetai.MADT) >= 3

-- Q.34. Cho biết số lượng giáo viên đã tham gia vào đề tài 'Ứng dụng khoa học xanh'
SELECT COUNT(tgdetai.MAGV) 'Số lượng giáo viên'
FROM THAMGIADT tgdetai, CONGVIEC cv, DETAI detai
WHERE (tgdetai.MADT = cv.MADT AND tgdetai.STT = cv.STT) AND (cv.MADT = detai.MADT)
GROUP BY detai.TENDT
HAVING detai.TENDT = N'Ứng dụng khoa học xanh'