-- MSSV: 23127379
-- Họ tên: Thái Minh Huy
-- Lớp: 23HTTT2
-- Môn: CSDLNC. KT Thực hành
-- Ngày: 17-11-2025. Giờ: 7h55 - 8h55
-- Hệ quản trị CSDL: SQL Server

USE QuanLyChuyenXe;
GO

-- 1. Function tính giá thực tế phải trả cho một mã chuyến xe cho trước:

GO
create or alter function fn_TinhGiaThucTe(@ma_chuyen char(10))
returns decimal(12, 2)
AS
BEGIN
    declare @giathucte decimal(12, 2)
    declare @cuoccoban decimal(12, 2)
    declare @phuphi decimal(12, 2)
    declare @tonggiamgia decimal(12, 2)

    select @cuoccoban = cx.cuoc_co_ban, @phuphi = cx.phu_phi_cao_diem
    from ChuyenXe cx
    where cx.ma_chuyen = @ma_chuyen

    select @tonggiamgia = isnull(sum(so_tien_giam), 0)
    from GiamGiaChuyen GiamGia
    where GiamGia.ma_chuyen = @ma_chuyen

    set @giathucte = @cuoccoban + @phuphi - @tonggiamgia

    if @giathucte < 0
        set @giathucte = 0
    return @giathucte
END

GO
select dbo.fn_TinhGiaThucTe('CX001') as GiaThucTeChuyen1
select dbo.fn_TinhGiaThucTe('CX002') as GiaThucTeChuyen2
select dbo.fn_TinhGiaThucTe('CX003') as GiaThucTeChuyen3

-- 2
-- 2.1 Thêm cột_tongTien
alter table ChuyenXe add Tong_tien decimal(12, 2)

-- 2.2 Thêm thủ tục
GO
create or alter procedure sp_CapNhatTongTien
AS
BEGIN
    update ChuyenXe set Tong_tien = dbo.fn_TinhGiaThucTe(ma_chuyen)
    print N'Cập nhật thành công'
END

exec sp_CapNhatTongTien

select *
from ChuyenXe

-- 3. Thủ tục thực hiện hủy chuyến và tự động tính phí phạt + hoàn tiền

GO
create or alter procedure sp_HuyChuyen
    @ma_chuyen char(10),
    @ma_tai_xe_huy char(10) = null
AS
BEGIN
    declare @cuoc_co_ban decimal(12, 2)
    declare @phat_tai_xe decimal(12, 2) = 0
    declare @phi_thu_khach decimal(12, 2) = 0
    declare @ly_do nvarchar(200)
    declare @ma_xe char(10)
    declare @ma_tx_hien_tai char(10)
    declare @tong_tien_thuc_te decimal(12, 2)

    select @cuoc_co_ban = cx.cuoc_co_ban,
        @ma_xe = cx.ma_xe,
        @ma_tx_hien_tai = cx.ma_tai_xe, 
        @tong_tien_thuc_te = cx.Tong_tien
    from ChuyenXe cx
    where cx.ma_chuyen = @ma_chuyen

    if @cuoc_co_ban is NULL
    BEGIN
        print N'Không tìm thấy chuyến xe'
        return
    END

    if @ma_tai_xe_huy is not null
    BEGIN
        set @phat_tai_xe = @cuoc_co_ban * 0.5
        set @phi_thu_khach = 0
        set @ly_do = N'Tài xế hủy chuyến(Mã TX: ' + @ma_tai_xe_huy + ')'
    END
    else
    BEGIN
        set @phat_tai_xe = 0
        set @phi_thu_khach = 0.1 * @cuoc_co_ban
        set @ly_do = N'Khách hàng hủy chuyến'

        if @tong_tien_thuc_te is null
            set @tong_tien_thuc_te = dbo.fn_TinhGiaThucTe(@ma_chuyen)

        insert into HoanTien
            (ma_chuyen, so_tien_hoan, thoi_gian_hoan)
        values
            (@ma_chuyen, @tong_tien_thuc_te - @phi_thu_khach, GETDATE())
    END

    insert into HuyChuyen
        (ma_chuyen, ly_do_huy, phi_thu_khach, phat_tai_xe)
    values
        (@ma_chuyen, @ly_do, @phi_thu_khach, @phat_tai_xe)

    update ChuyenXe set trang_thai = N'Hủy', thoi_gian_ket_thuc = GETDATE() where ma_chuyen = @ma_chuyen

    update Xe set trang_thai_hoat_dong = N'Ngừng' where ma_xe = @ma_xe

    update TaiXe set trang_thai_hoat_dong = N'Tạm nghỉ' where ma_tai_xe = @ma_tx_hien_tai

    print N'Xử lý hủy thành công'
END

GO
EXEC sp_HuyChuyen 'CX002', 'TX002'
exec sp_HuyChuyen 'CX001', null


go
create or alter trigger trg_TuDongTraThuLao on ChuyenXe
after UPDATE
AS
begin
    if update(trang_thai)
    BEGIN
        insert into ThuLaoTaiXe(ma_chuyen, ma_tai_xe, so_tien_tra, thoi_gian_tra)
        select 
            i.ma_chuyen,
            i.ma_tai_xe,
            0.6 * (i.cuoc_co_ban + i.phu_phi_cao_diem),
            GETDATE()
        from inserted i
        join deleted d on i.ma_chuyen = d.ma_chuyen
        where i.trang_thai = N'Hoàn thành' and d.trang_thai <> N'Hoàn thành'
    END
END

-- update ChuyenXe set trang_thai = N'Hoàn Thành' where ma_chuyen = 'CX002'
-- select * from ThuLaoTaiXe where ma_chuyen = 'CX002'