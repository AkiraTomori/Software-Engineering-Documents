-- MSSV: 23127379
-- Họ tên: Thái Minh Huy
-- Mã Đề: 1010
-- Vị trí: 3E

CREATE DATABASE _23127379
GO 
USE _23127379
-- 1. Tạo bảng và các ràng buộc cần thiết
CREATE TABLE CONGTY
(
    MaCT NVARCHAR(5) NOT NULL,
    TenCT NVARCHAR(50),
    QuocGia NVARCHAR(50),
    TruSo NVARCHAR(50),
    CongTrinhTB NVARCHAR(5),
    PRIMARY KEY(MaCT)
)

CREATE TABLE CONGTRINH
(
    MaCongTrinh NVARCHAR(5) NOT NULL,
    MaCongTy NVARCHAR(5) NOT NULL,
    TenCongTrinh NVARCHAR(100),
    DiaDiem NVARCHAR(100),
    Nam INT DEFAULT (YEAR(GETDATE())),
    PRIMARY KEY(MaCongTrinh, MaCongTy)
)

CREATE TABLE HANGMUC
(
    STT INT NOT NULL,
    MaCongTrinh NVARCHAR(5) NOT NULL,
    MaCongTy NVARCHAR(5) NOT NULL,
    TenHangMuc NVARCHAR(100),
    ChiPhi FLOAT,
    NhanCong INT,
    PRIMARY KEY(STT, MaCongTrinh, MaCongTy)
)

ALTER TABLE CONGTY
ADD CONSTRAINT FK_CONGTY_CONGTRINH
FOREIGN KEY(CongTrinhTB, MaCT)
REFERENCES CONGTRINH(MaCongTrinh, MaCongTy)

ALTER TABLE HANGMUC
ADD CONSTRAINT FK_HANGMUC_CONGTRINH
FOREIGN KEY(MaCongTrinh, MaCongTy)
REFERENCES CONGTRINH(MaCongTrinh, MaCongTy)

ALTER TABLE CONGTRINH
ADD CONSTRAINT FK_CONGTRINH_CONGTY
FOREIGN KEY(MaCongTy)
REFERENCES CONGTY(MaCT)
-- 2. Nhập các dòng dữ liệu
INSERT INTO CONGTY(MaCT, TenCT, QuocGia, TruSo, CongTrinhTB) VALUES
(N'CTY01', N'Vinaconex', N'Việt Nam', N'Hà Nội', NULL),
(N'CTY02', N'Coteccons', N'Việt Nam', N'TP.HCM', NULL),
(N'CTY03', N'Lotte E&C', N'Hàn Quốc', N'Seoul', NULL)

INSERT INTO CONGTRINH(MaCongTrinh, MaCongTy, TenCongTrinh, DiaDiem, Nam) VALUES
(N'001', N'CTY01', N'Tòa nhà văn phòng ABC Buildings', N'Hà Nội, Việt Nam', 2023),
(N'002', N'CTY02', N'Trung tâm thương mại CoCo', N'TP.HCM, Việt Nam', 2022),
(N'001', N'CTY03', N'Chung cư cao cấp Star', N'Đà Nẵng, Việt Nam', 2024),
(N'001', N'CTY02', N'Khách sạn 5 sao Seoul', N'Seoul, Hàn Quốc', 2021)

UPDATE CONGTY SET CongTrinhTB = N'001' WHERE MaCT = N'CTY01'
UPDATE CONGTY SET CongTrinhTB = N'002' WHERE MaCT = N'CTY02'
UPDATE CONGTY SET CongTrinhTB = N'001' WHERE MaCT = N'CTY03'

INSERT INTO HANGMUC(STT, MaCongTrinh, MaCongTy, TenHangMuc, ChiPhi, NhanCong) VALUES
(1, N'001', N'CTY01', N'Móng nền', 500, 100),
(2, N'001', N'CTY01', N'Kết cấu', 700, 80),
(1, N'002', N'CTY02', N'Nội thất', 300, 50),
(2, N'002', N'CTY02', N'Hệ thống điện', 200, 90),
(1, N'001', N'CTY03', N'Sàn bê tông', 400, 100)

-- 3. Cho biết tổng chi phí và tổng số nhân công của công trình "Trung tâm thương mại CoCo"

SELECT SUM(hm.ChiPhi) 'Tổng chi phí', SUM(hm.NhanCong) 'Tổng nhân công'
FROM HANGMUC hm, CONGTRINH ct
WHERE ct.MaCongTrinh = hm.MaCongTrinh AND ct.MaCongTy = hm.MaCongTy
      AND ct.TenCongTrinh = N'Trung tâm thương mại CoCo'
GROUP BY ct.TenCongTrinh, ct.MaCongTrinh

-- 4. Cho biết danh sách tên công ty, trụ sở và tên công trình tiêu biểu của công ty Việt Nam
SELECT cty.TenCT 'Tên công ty', cty.TruSo 'Trụ sở', ct.TenCongTrinh 'Công trình tiêu biểu'
FROM CONGTY cty, CONGTRINH ct
WHERE cty.CongTrinhTB = ct.MaCongTrinh AND cty.MaCT = ct.MaCongTy
      AND cty.QuocGia = N'Việt Nam'
-- 5. Ứng với mỗi công ty được xây dựng trước năm hiện tại và được phụ trách 
-- bởi công ty có công trình tiêu biểu có tên kết thúc bởi chuỗi 'ABC Buildings'
-- cho biết tên công trình và tổng chi phí các hạng mục của mỗi công trình

SELECT ct.TenCongTrinh 'Tên công trình', SUM(hm.ChiPhi) 'Tổng chi phí'
FROM CONGTRINH ct, HANGMUC hm
WHERE ct.MaCongTrinh = hm.MaCongTrinh AND ct.MaCongTy = hm.MaCongTy
      AND ct.Nam < YEAR(GETDATE()) AND ct.TenCongTrinh LIKE N'%ABC Buildings'
GROUP BY ct.TenCongTrinh, ct.MaCongTrinh
