CREATE DATABASE GK_23127379_BAO
GO
USE GK_23127379_BAO

CREATE TABLE BAIBAO
(
    STT INT NOT NULL,
    HoiNghi NVARCHAR(10) NOT NULL,
    NamToChuc INT NOT NULL,
    LoaiBaiBao NVARCHAR(20) CHECK (LoaiBaiBao IN (N'Toàn văn', N'Tóm tắt')),
    ChuDe NVARCHAR(20) CHECK (ChuDe IN (N'Ứng dụng', N'Nghiên cứu')),
    PRIMARY KEY (STT, HoiNghi, NamToChuc)
)

CREATE TABLE HOINGHI
(
    MaHoiNghi NVARCHAR(10) NOT NULL,
    QuocGia NVARCHAR(30),
    TenHoiNghi NVARCHAR(50) UNIQUE,
    NamThanhLap INT,
    NhaXuatBan NVARCHAR(30),
    PRIMARY KEY(MaHoiNghi)
)

CREATE TABLE TOCHUC
(
    HoiNghi NVARCHAR(10) NOT NULL,
    NamToChuc INT NOT NULL,
    DiaDiem NVARCHAR(50),
    BaiBaoTieuBieu INT,
    PRIMARY KEY(HoiNghi, NamToChuc)
)

ALTER TABLE BAIBAO
ADD CONSTRAINT FK_BAIBAO_TOCHUC
FOREIGN KEY(HoiNghi, NamToChuc)
REFERENCES TOCHUC(HoiNghi, NamToChuc)

ALTER TABLE TOCHUC
ADD CONSTRAINT FK_TOCHUC_HOINGHI
FOREIGN KEY(HoiNghi)
REFERENCES HOINGHI(MaHoiNghi)

ALTER TABLE TOCHUC
ADD CONSTRAINT FK_TOCHUC_BAIBAO
FOREIGN KEY(BaiBaoTieuBieu, HoiNghi, NamToChuc)
REFERENCES BAIBAO(STT, HoiNghi, NamToChuc)

ALTER TABLE BAIBAO
ADD CONSTRAINT FK_BAIBAO_HOINGHI
FOREIGN KEY(HoiNghi)
REFERENCES HOINGHI(MaHoiNghi)

INSERT INTO HOINGHI(MaHoiNghi, QuocGia, TenHoiNghi, NamThanhLap, NhaXuatBan) VALUES
(N'CITA', N'Việt Nam', N'Công nghệ thông tin và ứng dụng', 2023, N'Giáo dục'),
(N'KES', N'Hoa Kỳ', N'Tri thức và dữ liệu', 2022, N'IEEE')

INSERT INTO TOCHUC(HoiNghi, NamToChuc, DiaDiem, BaiBaoTieuBieu) VALUES
(N'CITA', 2023, N'Đà Nẵng, Việt Nam', NULL),
(N'KES', 2022, N'Tokyo, Nhật Bản', NULL),
(N'KES', 2023, N'Paris, Pháp', NULL)

INSERT INTO BAIBAO(STT, HoiNghi, NamToChuc, LoaiBaiBao, ChuDe) VALUES
(1, N'CITA', 2023, N'Toàn văn', N'Ứng dụng'),
(2, N'CITA', 2023, N'Tóm tắt', N'Nghiên cứu'),
(1, N'KES', 2022, N'Tóm tắt', N'Nghiên cứu'),
(1, N'KES', 2023, N'Toàn văn', N'Ứng dụng'),
(2, N'KES', 2023, N'Toàn văn', N'Ứng dụng')

UPDATE TOCHUC SET BaiBaoTieuBieu = 2 WHERE HoiNghi = N'CITA' AND NamToChuc = 2023
UPDATE TOCHUC SET BaiBaoTieuBieu = 1 WHERE HoiNghi = N'KES' AND NamToChuc = 2022
UPDATE TOCHUC SET BaiBaoTieuBieu = 2 WHERE HoiNghi = N'KES' AND NamToChuc = 2023

-- Cho địa điểm tổ chức hội nghị 'Tri thức và dữ liệu' Năm 2023
SELECT tc.DiaDiem 'Địa điểm tổ chức'
FROM HOINGHI hn JOIN TOCHUC tc ON hn.MaHoiNghi = tc.HoiNghi 
WHERE hn.TenHoiNghi = N'Tri thức và dữ liệu' and tc.NamToChuc = 2023

-- Cho danh sách tên hội nghị và tên quốc gia của các hội nghị đã từng được
-- tổ chức tại Nhật có bài báo tiêu biểu thuộc về chủ đề “Nghiên cứu” và không có
-- bài báo toàn văn nào thuộc chủ đề “Ứng dụng”.
SELECT hn.TenHoiNghi 'Tên hội nghị', hn.QuocGia 'Tên quốc gia'
FROM HOINGHI hn, BAIBAO bb, TOCHUC tc
WHERE tc.DiaDiem LIKE N'%Nhật%' AND bb.ChuDe = N'Nghiên cứu'
      AND hn.MaHoiNghi = tc.HoiNghi AND hn.MaHoiNghi = bb.HoiNghi AND bb.NamToChuc = tc.NamToChuc AND bb.HoiNghi = tc.HoiNghi
EXCEPT
SELECT hn.TenHoiNghi 'Tên hội nghị', hn.QuocGia 'Tên quốc gia'
FROM HOINGHI hn, BAIBAO bb, TOCHUC tc
WHERE tc.DiaDiem LIKE N'%Nhật%' AND bb.ChuDe = N'Ứng dụng'
      AND hn.MaHoiNghi = tc.HoiNghi AND hn.MaHoiNghi = bb.HoiNghi AND bb.NamToChuc = tc.NamToChuc AND bb.HoiNghi = tc.HoiNghi

-- Cho mã hội nghị, tên hội nghị, số lần hội nghị được tổ chức và số lượng
-- bài báo cho từng lần tổ chức.
SELECT bb.HoiNghi 'Mã hội nghị', hn.TenHoiNghi 'Tên hội nghị', COUNT(bb.STT) 'Số lần hội nghị được tổ chức', COUNT(*) 'Số lần bài báo cho từng lần tổ chức'
FROM HOINGHI hn, TOCHUC tc, BAIBAO bb
WHERE hn.MaHoiNghi = tc.HoiNghi AND tc.HoiNghi = bb.HoiNghi AND tc.NamToChuc = bb.NamToChuc
GROUP BY bb.HoiNghi, bb.NamToChuc, hn.TenHoiNghi
