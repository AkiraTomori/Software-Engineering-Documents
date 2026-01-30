--stored procedure
--thực hiện thêm 1 phân công cho 1 giảng
--viên
--input: magv, madt, stt, phụ cấp, thời gian
--output: thêm thành công/thất bại
go
create proc ThemPhanCongGV
	@magv varchar(5),
	@madt varchar(5),
	@stt int,
	@phucap int
as --bắt đầu stored
begin --không có cũng được, ko bắt buộc
	if not exists (select 1 from GIANGVIEN where magv = @magv)
	begin
		return 0 --input ko hợp lệ
	end
	if not exists (select 1 from CONGVIEC where madt = @madt and SOTT=@stt)
	begin
		return 0 --input ko hợp lệ
	end
	--kiểm tra các ràng buộc khác
	--ví dụ: mỗi gv không tham gia quá 3 công việc trong 1 đề tài
	--và ko tham gia 3 đề tài cùng lúc
	--đếm số cv đã phân công cho gv trong @madt
	--đếm số đề tài đang tham gia: ngày kết thúc: NULL
	if(select count(*) from THAMGIADT 
		where magv=@magv and madt=@madt)>=3
		begin
			raiserror('GV đã tham gia đủ số cv',15,1)
			return 0
		end
	if (select count(distinct tg.madt) from THAMGIADT tg
		join Detai dt on tg.madt = dt.MADT 
		where NGAYKT is NULL)>=2
		begin
			raiserror('GV đã tham gia đủ số dt',15,1)
			return 0
		end
	insert into THAMGIADT values
	(@magv,@madt, @stt,@phucap,NULL)
	return 1 --thêm thành công
end

go

select * from THAMGIADT
--cho ds các mabm, số gv nam, số gv nữ của mỗi bm
go
create function fn_DemSoGV(@gioitinh nvarchar(3),@mabm varchar(5))
returns int
as
begin --bắt buộc đối với scalar function
	return (select count(magv) from GIANGVIEN where PHAI = @gioitinh
	and mabm = @mabm)
end
go
alter proc ThongKeGV
as
begin
	select mabm, dbo.fn_DemSoGV('Nam',mabm) as SoGVNam, dbo.fn_DemSoGV(N'Nữ',mabm) as SoGVNu
	from BOMON
end
exec ThongKeGV

--trigger
select * from BOMON
--rb: số gv (bộ môn) = số gv của bm đó trong (GiangVien)
	--		T		X		S
--BoMon		+(sogv)	-		- (ko sửa khoá chính)
--GiangVien +		+		+(mabm)
--xét + thêm trên bảng bm
--có cần cài trigger ko? --> default: 0, disable ko cho nhập giá trị này
--cài trigger xl thêm 1 gv
--~ insert into giangvien values (magv, hoten, ngaysinh, diachi...,mabm)
--dl đã thêm thành công rồi
--sau đó, trigger mới được raise lên để kiểm tra
--kiểm tra cái gì?
--lấy mabm của gv vừa thêm --> cập nhật sogv của bm đó tăng 1
--làm sao biết gv nào vừa thêm vào db?
--sử dụng 2 bảng tam: inserted và deleted
go
alter trigger ThemGiangVien 
ON GiangVien
For insert,delete
as
begin
	--đếm số gv vừa thêm của mỗi bm trong inserted
	--update BOMON set sogv = sogv + SoGVThem
	update BOMON set sogv = Tmp.SOGVSauThem
	From 
	--(select i.mabm, count(*) as SOGVThem from inserted i
	--group by i.MABM
	(select distinct i.mabm, count(*) as SOGVSauThem from inserted i
	join giangvien gv on i.mabm = gv.mabm
	group by i.MABM
	) as Tmp
	where BOMON.mabm = tmp.MABM
end
go
select * from BOMON
select * from GIANGVIEN
insert into GIANGVIEN (magv, HOTEN,mabm)
values ('015',N'Gia Hong', 'HTTT')