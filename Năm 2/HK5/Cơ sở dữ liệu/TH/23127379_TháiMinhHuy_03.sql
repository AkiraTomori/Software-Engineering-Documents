CREATE DATABASE GK_23127379_BaiHat
GO
USE GK_23127379_BaiHat

CREATE TABLE BAIHAT
(
    IDTheLoai CHAR(10) NOT NULL,
    IDBaiHat CHAR(10) NOT NULL,
    TenBaiHat NVARCHAR(30),
    IDTacGia INT,
    PRIMARY KEY(IdTheLoai, IDBaiHat)
)

CREATE TABLE THELOAI
(
    IDTheLoai CHAR(10) NOT NULL,
    TenTheLoai NVARCHAR(30),
    IDTheLoaiCha CHAR(10),
    IDBaiHatTieuBieu CHAR(10),
    PRIMARY KEY(IDTheLoai)
)

CREATE TABLE TACGIA
(
    IDTacGia INT NOT NULL,
    HoTen NVARCHAR(30),
    IDTheLoaiSoTruongNhat CHAR(10),
    IDBaiHatTieuBieuNhat CHAR(10),
    PRIMARY KEY(IDTacGia)
)

ALTER TABLE TACGIA
ADD CONSTRAINT FK_TACGIA_BAIHAT
FOREIGN KEY(IDTheLoaiSoTruongNhat, IDBaiHatTieuBieuNhat)
REFERENCES BAIHAT(IDTheLoai, IDBaiHat)

ALTER TABLE BAIHAT
ADD CONSTRAINT FK_BAIHAT_TACGIA
FOREIGN KEY(IDTacGia)
REFERENCES TACGIA(IDTacGia)

ALTER TABLE BAIHAT
ADD CONSTRAINT FK_BAIHAT_THELOAI
FOREIGN KEY(IDTheLoai)
REFERENCES THELOAI(IDTheLoai)

ALTER TABLE THELOAI
ADD CONSTRAINT FK_THELOAI_THELOAI
FOREIGN KEY(IDTheLoaiCha)
REFERENCES THELOAI(IDTheLoai)

ALTER TABLE THELOAI
ADD CONSTRAINT FK_THELOAI_BAIHAT
FOREIGN KEY(IDTheLoai, IDBaiHatTieuBieu)
REFERENCES BAIHAT(IDTheLoai, IDBaiHat)

INSERT INTO THELOAI(IDTheLoai, TenTheLoai, IDTheLoaiCha, IDBaiHatTieuBieu) VALUES
('TL01', N'Nhạc trữ tình', 'TL00', NULL),
('TL02', N'Nhạc cách mạng', 'TL00', NULL),
('TL00', N'Nhạc Việt Nam', NULL, NULL)

INSERT INTO BAIHAT(IDTheLoai, IDBaiHat, TenBaiHat, IDTacGia) VALUES
('TL01', 'BH01', N'Ngẫu hứng lý qua cầu', NULL),
('TL01', 'BH02', N'Chuyến đò quê hương', NULL),
('TL02', 'BH01', N'Du kích sông Thao', NULL),
('TL02', 'BH02', N'Sợi nhớ sợi thương', NULL)

UPDATE THELOAI SET IDBaiHatTieuBieu = 'BH01' WHERE IDTheLoai = 'TL01'
UPDATE THELOAI SET IDBaiHatTieuBieu = 'BH02' WHERE IDTheLoai = 'TL02'

INSERT INTO TACGIA(IDTacGia, HoTen, IDTheLoaiSoTruongNhat, IDBaiHatTieuBieuNhat) VALUES
(1, N'Trần Tiến', 'TL01', 'BH01'),
(2, N'Đỗ Nhuận', 'TL02', 'BH01'),
(3, N'Phan Huỳnh Điểu', 'TL02', 'BH02'),
(4, N'Vi Nhật Tảo', 'TL01', 'BH02')

UPDATE BAIHAT SET IDTacGia = 1 WHERE IDTheLoai = 'TL01' AND IDBaiHat = 'BH01'
UPDATE BAIHAT SET IDTacGia = 4 WHERE IDTheLoai = 'TL01' AND IDBaiHat = 'BH02'
UPDATE BAIHAT SET IDTacGia = 2 WHERE IDTheLoai = 'TL02' AND IDBaiHat = 'BH01'
UPDATE BAIHAT SET IDTacGia = 3 WHERE IDTheLoai = 'TL02' AND IDBaiHat = 'BH02'

-- Cho danh sách bài hát thuộc thể loại “nhạc trữ tình” của tác giả Đỗ Nhuận
SELECT bh.TenBaiHat 'Tên bài hát'
FROM BAIHAT bh, THELOAI tl, TACGIA tg
WHERE bh.IDTacGia = tg.IDTacGia AND tg.IDTheLoaiSoTruongNhat = bh.IDTheLoai AND tg.IDBaiHatTieuBieuNhat = bh.IDBaiHat AND tg.HoTen = N'Đỗ Nhuận' AND tl.TenTheLoai = N'Nhạc trữ tình'

-- Cho danh sách các thể loại chưa có bài hát nào trong thể loại đó
SELECT IDTheLoai
FROM THELOAI
EXCEPT
SELECT tl.IDTheLoai
FROM THELOAI tl, BAIHAT bh
WHERE bh.IDTheLoai = tl.IDTheLoai 
-- Cho danh sách tác giả (mã, họ tên, số bài hát) của mỗi tác giả.
SELECT tg.IDTacGia 'Mã tác giả', tg.HoTen 'Họ tên tác giả', COUNT(bh.IDTacGia) 'Số bài hát'
FROM BAIHAT bh, TACGIA tg
WHERE bh.IDTacGia = tg.IDTacGia AND bh.IDTheLoai = tg.IDTheLoaiSoTruongNhat AND bh.IDBaiHat = tg.IDBaiHatTieuBieuNhat
GROUP BY tg.IDTacGia, tg.HoTen
