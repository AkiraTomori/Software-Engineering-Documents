--thêm mới một nhân viên 
--họ tên, luong, phái, ngsinh, không được trống
--phải tối thiẻu là cn dh trở lên. >=22 tuổi
--gvqlcm có thể trống
--magv là do phòng tchc cấp (đảm bảo không trùng)
--cần kiểm tra là gv này đã được nhập vào hệ thống chưa.
--insert into GIANGVIEN (magv, hoten, luong, phai, NGSINH, DCHI,
--GVQLCM,mabm)
--values()
go
create proc ThemMoiGV
	@magv char(3),
	@hoten nvarchar(30),
	@luong int,
	@phai nvarchar(3),
	@ngsinh date,
	@dchi nvarchar(50),
	@gvqlcm char(3),
	@mabm char(5)
as
begin
	begin tran
	--kiểm tra trùng khoá
	if exists (select 1 from GIANGVIEN where magv = @magv)
	begin
		raiserror('GV đã thêm rồi',15,1)
		rollback
		return -1
	end
	if year(getdate())-year(@ngsinh) <22
	begin
		raiserror('GV chưa đủ tuổi quy định',15,1)
		rollback
		return -1
	end
	insert into GIANGVIEN (magv, hoten, luong, phai, NGSINH, DCHI,
	GVQLCM,mabm)
	values(@magv,@hoten,@luong,@phai,@ngsinh,@dchi,@gvqlcm,@mabm)
	return 0 --thành công và ko có lỗi xảy ra
	
end
go
declare @loi int
exec @loi = ThemMoiGV '090',N'Trần A',30000,'Nam',NULL,NULL,NULL,NULL
if @loi = 0 print N'thực hiện thành công'
else print N'Thêm bị lỗi'

--output
--thêm mới 1 công việc của 1 madt 001
--Madt, sott --> xác định sott max đang có trong dtai
--xác định sott tiếp theo = sottmax + 1
--có được macv (001,sott tiếp theo)
--B1: xác định mã cv
--B2: thêm mới công việc vào đề tài
go
create proc XacDinhSTTCV
	@madt varchar(4),
	@sttnew int output
as
begin
	SELECT @sttnew =  ISNULL(MAX(SOTT), 0) + 1
	FROM CONGVIEC
	WHERE MaDt = @MaDt;
end
go
declare @sttnew int
exec XacDinhSTTCV '001',@sttnew out
print @sttnew
select * from CONGVIEC where madt = '001'
go
create proc ThemMoiCongViec
	@madt varchar(4),
	@tencv nvarchar(50),
	@ngaybd datetime,
	@ngaykt datetime
as
begin
	declare @stt int
	exec XacDinhSTTCV @madt,@stt out
	--if exists (select 1 from CONGVIEC where madt = @madt and SOTT = @stt)
	--begin
	--	raiserror('Trùng công việc',15,1)
	--end
	insert into CONGVIEC values (@madt,@stt,@tencv,@ngaybd,@ngaykt)
	print 'Thêm thành công'
end
go
exec ThemMoiCongViec '007','Công việc 7','2025-03-02',NULL
select * from CONGVIEC where madt = '007'

--function
--cho biết mabm, tenbn, sogv nam, sogv nữ của bm
select mabm, tenbm, (select count(*) from
						GIANGVIEN
						where phai = 'Nam' and mabm = bm.MABM ) as SOGVNam, 
					(select count(*) from
						GIANGVIEN
						where phai = N'Nữ' and mabm = bm.MABM
					) as SOGVNu
from BOMON bm
go
create function DemGV_PHai_BM(@mabm varchar(5),@phai nvarchar(3))
returns int
as
begin
	return (select count(*) 
			from GIANGVIEN 
			where mabm = @mabm and phai = @phai)
end
go
select mabm, tenbm, dbo.DemGV_PHai_BM(bm.MABM,'Nam') as SOGVNam, 
					dbo.DemGV_PHai_BM(bm.MABM,N'Nữ') as SOGVNu
from BOMON bm
go
--trigger
update BOMON
set SoGV_BM = T.SoGV
from (select mabm, count(magv) as SoGV 
		from GIANGVIEN 
		group by mabm) as T
where BoMon.mabm = T.MABM
select * from BOMON
--RB: soGV trong bảng bm = count(magv) 
--trong giangvien của mabm đó 
--Hành động nào (thêm/xoá/sửa) sẽ gây vi phạm RB?
--Khi thêm mới 1 gv -> có vi phạm
--Khi xoá 1 gv --> có vi phạm
--Khi cập nhật 1 gv ->có vi phậm
--vẽ bảng tầm ảnh hưởng
--			T		X	S
--GiangVien	+		+	+(mabm)
--BoMon		+(sogv)	-	-
--Khi thêm mới bm, gán sogv = 0, không cho nhập giá trị này
--Thiết kế giao diện thêm mới bm, ko cho phép nhập 
--không phải cứ + là cài trigger, chúng ta có thể
--cài thông qua các ràng buộc đơn giản khác
--VD: cài trigger cho hành động thêm mới gv
go
alter trigger KT_ThemGV
on giangvien
for insert,delete,update --đã insert rồi mới raise trigger
as
begin
	--cần lấy ra các dòng gv mới thêm vào
	--select * from inserted
	--select * from deleted
	if exists(select * from inserted)
	begin
		update BOMON set SoGV_BM = T.SoGV
		from (
		select mabm, count(*) as SoGV
		from GIANGVIEN 
		where mabm in (select mabm from inserted)
		group by mabm
		) as T
		where BOMON.mabm = T.MABM
	end
end
go
select mabm from GIANGVIEN
insert into GIANGVIEN (magv, hoten,mabm)
values ('083','Khang','HTTT'),('084','Trang','CNTT')
select * from BOMON