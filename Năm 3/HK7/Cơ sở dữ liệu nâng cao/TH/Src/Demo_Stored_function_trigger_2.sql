--Thêm mới 1 công việc vào 1 đề tài
--xác định stt tiếp theo của cv ~tránh trùng khoá chính
--làm khoá
--ngaybdcv<ngaykthuccv: NUll
--stored procedure không tham số
--stored procedure có tham số input
--stored " có tham số output
--stored " có cả input & output
--stored " có return giá trị (int)
--kết hợp tất cả vào 1 stored
create proc LayDSGiangVien
as
	select * from GIANGVIEN
go

--gọi thực thi
exec LayDSGiangVien
go

--
--xuất ds gv của 1 bm bất kỳ
create proc LayDSGVTheoBoMon
	@mabm varchar(4)
as
begin
	select * from GIANGVIEN where mabm = @mabm
end
GO
--gọi thực thi
exec LayDSGVTheoBoMon 'HTTT'

--viết 1 thủ tục xác định stt kế tiếp của 1 madt:'001'
--lấy ds các stt đang có trong mã dt này 1-2-3
--lấy max (sott) của madt này: 3
--sttnext = sttmax + 1
--trả sttnext ra khỏi thủ tục để sử dụng tiếp
go
create proc XacDinhSTTCVTT
	@madt varchar(4),
	@sttkq int output
as
	select @sttkq = IsNULL(max(sott),0)+1 from CONGVIEC where madt = @madt

go
select * from detai
select * from CONGVIEC where madt = 'DT04'
select IsNULL(max(sott),0)+1 from CONGVIEC where madt = 'DT04'
go
alter proc ThemMoiCVVaoDT
	@madt varchar(4),
	@tencv nvarchar(50),
	@ngaybdau datetime,
	@ngaykt datetime
as
begin
	begin try
	declare @stt int
		exec XacDinhSTTCVTT @madt, @stt out
		insert into CONGVIEC values (@madt, @stt, @tencv,@ngaybdau,@ngaykt)
		print 'Theem thanh cong'
		return 0 --ko co loi
	end try
	begin catch
		print 'Them bi loi'
		return -1
	end catch
end
go
declare @kq int
exec @kq = ThemMoiCVVaoDT 'DT04',N'Cong viec x dt04',NULL,NULL
if @kq = 0 print 'Khoong co loi'
else print 'Co loi'
select * from CONGVIEC
--function
--voi moi bm, cho biet so nv nam, sonv nu
select mabm, tenbm, (select count(magv) 
					from GIANGVIEN
					where mabm = bm.mabm and
					Phai = 'Nam') as SoNVNam, 
					(select count(magv) 
					from GIANGVIEN
					where mabm = bm.mabm and
					Phai = N'Nữ') as SONVNU 
from Bomon bm
--c2
go
create function DemSoNVTheoGT(@mabm varchar(4),@phai nvarchar(3))
returns int
as
begin
	return (select count(magv) 
					from GIANGVIEN
					where mabm = @mabm and
					Phai = @Phai)
end
go
select mabm, tenbm, dbo.DemSoNVTheoGT(bm.mabm,'Nam') as SoNVNam,
					dbo.DemSoNVTheoGT(bm.mabm,N'Nữ') as SoNVNu
from BOMON bm

--trigger
--SoGV trong bm = tổng số gv thực sự có trong bảng gv của bm đó
--				T		X		S
--BoMon			+(sogv)	-		+(sogv)
--GiangVien		+		+		+(mabm)

--proc them moigv
--b1. them gv vào bảng gv
--b2: cập nhật tăng sogv của mabm của gv nay
go
alter trigger ThemGV1 ON GiangVien
for insert, update, delete
as
begin
	--lấy dòng mới được thêm vô trong bảng gv
	--lấy mabm ,kiểm tr số gv của mabm này có đúng count(gv) trong bm này ko)
	--C1:cập nhật lại cho đúng
	update BOMON set sogv = bomon.sogv + tmp.SoGV
	From (select mabm, count(magv) as SoGV
	from inserted
	group by mabm) as tmp
	where bomon.mabm = tmp.mabm
	--C2: kiểm tra khác thì báo lỗi, huỷ
end
go
insert into GIANGVIEN (magv, hoten, MABM)
values ('086',N'Trang','HTTT'),
('089',N'Trinh','CNTT')
select * from GIANGVIEN
select * from BOMON