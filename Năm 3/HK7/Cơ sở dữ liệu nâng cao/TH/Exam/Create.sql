USE QuanLyChuyenXe;
GO

-- ==========================================
-- 2. TẠO BẢNG TAI XE
-- ==========================================
CREATE TABLE TaiXe (
    ma_tai_xe       CHAR(10)        PRIMARY KEY,
    ho_ten          NVARCHAR(100)   NOT NULL,
    ngay_sinh       DATE            NOT NULL,
    so_dien_thoai   VARCHAR(15)     NOT NULL,
    bang_lai        NVARCHAR(50),
    trang_thai_hoat_dong NVARCHAR(20) CHECK (trang_thai_hoat_dong IN (N'Hoạt động', N'Tạm nghỉ', N'Ngừng')),
    ngay_tham_gia   DATE            DEFAULT GETDATE()
);
GO

-- ==========================================
-- 3. TẠO BẢNG XE
-- ==========================================
CREATE TABLE Xe (
    ma_xe              CHAR(10)       PRIMARY KEY,
    bien_so            VARCHAR(20)    NOT NULL UNIQUE,
    hang_xe            NVARCHAR(50),
    mau_xe             NVARCHAR(30),
    nam_san_xuat       INT            CHECK (nam_san_xuat >= 2000),
    ma_tai_xe          CHAR(10),
    trang_thai_hoat_dong NVARCHAR(20) CHECK (trang_thai_hoat_dong IN (N'Hoạt động', N'Bảo dưỡng', N'Ngừng')),
    FOREIGN KEY (ma_tai_xe) REFERENCES TaiXe(ma_tai_xe)
);
GO

-- ==========================================
-- 4. TẠO BẢNG CHUYEN XE
-- ==========================================
CREATE TABLE ChuyenXe (
    ma_chuyen          CHAR(10)       PRIMARY KEY,
    thoi_gian_dat      DATETIME       NOT NULL,
    thoi_gian_ket_thuc DATETIME,
    ma_tai_xe          CHAR(10)       NOT NULL,
    ma_xe              CHAR(10)       NOT NULL,
    diem_don           NVARCHAR(100),
    diem_tra           NVARCHAR(100),
    trang_thai         NVARCHAR(20)   CHECK (trang_thai IN (N'Đang chạy', N'Hoàn thành', N'Hủy')),
    cuoc_co_ban        DECIMAL(12,2)  CHECK (cuoc_co_ban >= 0),
    phu_phi_cao_diem   DECIMAL(12,2)  DEFAULT 0,
    ma_thanh_pho       NVARCHAR(50),
    FOREIGN KEY (ma_tai_xe) REFERENCES TaiXe(ma_tai_xe),
    FOREIGN KEY (ma_xe) REFERENCES Xe(ma_xe)
);
GO

-- ==========================================
-- 5. TẠO BẢNG GIẢM GIÁ CHUYẾN
-- ==========================================
CREATE TABLE GiamGiaChuyen (
    ma_chuyen       CHAR(10),
    ma_khuyen_mai   CHAR(10),
    so_tien_giam    DECIMAL(12,2) CHECK (so_tien_giam >= 0),
    PRIMARY KEY (ma_chuyen, ma_khuyen_mai),
    FOREIGN KEY (ma_chuyen) REFERENCES ChuyenXe(ma_chuyen)
);
GO

-- ==========================================
-- 6. TẠO BẢNG THÙ LAO TÀI XẾ
-- ==========================================
CREATE TABLE ThuLaoTaiXe (
    ma_chuyen     CHAR(10),
    ma_tai_xe     CHAR(10),
    so_tien_tra   DECIMAL(12,2) CHECK (so_tien_tra >= 0),
    thoi_gian_tra DATETIME      DEFAULT GETDATE(),
    PRIMARY KEY (ma_chuyen, ma_tai_xe),
    FOREIGN KEY (ma_chuyen) REFERENCES ChuyenXe(ma_chuyen),
    FOREIGN KEY (ma_tai_xe) REFERENCES TaiXe(ma_tai_xe)
);
GO

-- ==========================================
-- 7. TẠO BẢNG HOÀN TIỀN
-- ==========================================
CREATE TABLE HoanTien (
    ma_chuyen     CHAR(10) PRIMARY KEY,
    so_tien_hoan  DECIMAL(12,2) CHECK (so_tien_hoan >= 0),
    thoi_gian_hoan DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ma_chuyen) REFERENCES ChuyenXe(ma_chuyen)
);
GO

-- ==========================================
-- 8. TẠO BẢNG HỦY CHUYẾN
-- ==========================================
CREATE TABLE HuyChuyen (
    ma_chuyen      CHAR(10) PRIMARY KEY,
    ly_do_huy      NVARCHAR(200),
    phi_thu_khach  DECIMAL(12,2) CHECK (phi_thu_khach >= 0),
    phat_tai_xe    DECIMAL(12,2) CHECK (phat_tai_xe >= 0),
    FOREIGN KEY (ma_chuyen) REFERENCES ChuyenXe(ma_chuyen)
);
GO

-- ==========================================
-- 9. DỮ LIỆU MẪU
-- ==========================================
INSERT INTO TaiXe VALUES 
('TX001', N'Nguyễn Văn A', '1985-06-12', '0909123456', N'B2', N'Hoạt động', '2020-01-05'),
('TX002', N'Trần Văn B', '1990-09-21', '0909234567', N'C', N'Hoạt động', '2021-03-10'),
('TX003', N'Lê Văn C', '1988-11-15', '0909345678', N'B2', N'Tạm nghỉ', '2019-12-20');

INSERT INTO Xe VALUES 
('XE001', '51A-12345', N'Toyota', N'Đen', 2019, 'TX001', N'Hoạt động'),
('XE002', '51B-67890', N'Hyundai', N'Bạc', 2020, 'TX002', N'Hoạt động'),
('XE003', '51C-11223', N'Kia', N'Đỏ', 2018, 'TX003', N'Bảo dưỡng');

INSERT INTO ChuyenXe VALUES 
('CX001', '2025-10-30 08:00', '2025-10-30 09:00', 'TX001', 'XE001', N'Quận 1', N'Quận 5', N'Hoàn thành', 100000, 20000, N'HCM'),
('CX002', '2025-10-31 07:30', NULL, 'TX002', 'XE002', N'Quận 3', N'Quận 7', N'Đang chạy', 120000, 30000, N'HCM'),
('CX003', '2025-10-31 06:45', NULL, 'TX003', 'XE003', N'Tân Bình', N'Bình Tân', N'Hủy', 90000, 0, N'HCM');

INSERT INTO GiamGiaChuyen VALUES 
('CX001', 'KM01', 15000),
('CX002', 'KM02', 20000);

INSERT INTO ThuLaoTaiXe VALUES 
('CX001', 'TX001', 70000, '2025-10-30 10:00'),
('CX002', 'TX002', 85000, '2025-10-31 12:00');

INSERT INTO HoanTien VALUES 
('CX003', 50000, '2025-10-31 08:30');

INSERT INTO HuyChuyen VALUES 
('CX003', N'Khách hủy chuyến đột xuất', 10000, 0);
GO