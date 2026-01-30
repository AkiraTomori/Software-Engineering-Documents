--csdl quản lý đề tài
-- Cho danh sách các đề tài có tổng phụ cấp trong đề tài vượt quá kinh phí đề tài
--ví dụ: xét đề tài 01: 
--tính tổng các phụ cấp của dtai 01 (đã pcong chogv) (1)
--lấy kinh phí của dtai 01 (2)
--So sánh nếu (1)<=(2) thì hợp lệ. Ngược lại: không hợp lệ (đã vượt kinh phí)
--Tổng kquast cho tất cả đề tài khác.
alter proc DSDT
as
begin
	--declare @tongpc int, @kphi int
	--select @tongpc = sum(phucap) from THAMGIADT where MADT = '001'
	--select @kphi=kinhphi from detai where madt='001'
	--if(@tongpc >@kphi)
	--begin
	--	print ('De tai vươt kinh phi duoc cap')
	--	return
	--end
	--select * from detai where madt='001'
	select tg.madt, tendt, sum(phucap) as 'Tong Phu cap', KINHPHI
	from THAMGIADT tg, detai dt
	where tg.MADT = dt.MADT
	group by tg.madt, tendt, KINHPHI
	having sum(phucap)>KINHPHI
end
go
exec DSDT
select * from THAMGIADT where madt='001'

-- viết function đếm số công việc tham gia trong 1 đề tài của 1 gv cho trước
go
create function fn_DemCVTG (@madt varchar(5), @magv varchar(50))
returns int
begin
	return (select count(*) 
			from THAMGIADT 
			where madt = @madt and magv = @magv)
end
go
select dbo.fn_DemCVTG('002','001')

-- viết stored xuất danh sách các gv tham gia quá 3 công việc trong đề tài
go
create proc dsgv
as
begin
	select gv.magv,hoten from GIANGVIEN gv join THAMGIADT tg on gv.magv = tg.magv
	where dbo.fn_DemCVTG(tg.madt,gv.magv)>3
end
-- viết stored xuất danh sách các gv và số đề tài đã tham gia của giảng viên.
-- thực hiện phân công công việc cho giảng viên. Biết rằng, mỗi gv chỉ được tham gia tối đa 3 cv trong 1 đề tài
--1. Vẽ bảng tầm ảnh hưởng


insert into THAMGIADT (Magv,madt,stt) values ('003','001',3),('004','002',3),('003','002',1)
delete from THAMGIADT where magv='004' and madt='001' and stt=3
update THAMGIADT set stt = 3 where magv = '004' and madt='001' and stt=2
--2 với mỗi + trong bảng tầm ảnh hưởng --> kiểm tra
go
alter trigger tg_PCGV on ThamGiaDT
for insert, delete
as
begin
	--với mỗi gv được phân công trong inserted
	--đếm số cv trong mỗi đề tài của gv đó
	--so sánh >3 thì báo lỗi huỷ
	--ngược lại: thông báo thêm thành công
	if exists(select distinct magv,madt from inserted
			where dbo.fn_DemCVTG(madt,magv)>3)
		begin
			raiserror(N'GV không được tham gia quá 3 cv trong dtai. Phân Công ko hợp lệ',15,1)
			rollback --đưa csdl về trước khi insert xảy ra
		end
	else
		print('Them thanh cong')
end
go

sp1 3 100 300
sp2 1 50 50
hd: tổng: 350
insert into hoa don (mahd, ngaylap, 350)
--lấy mã hd mới thêm
thêm chi tiết hoá đơn
insert into cthd ct1, ct2
--Ngày bắt đầu công việc < ngày kết thúc và không quá 1 tháng kể từ ngày bắt đầu
-- Giảng viên tham gia đề tài phải cùng bộ môn với gvcn đề tài
--Tổng phụ cấp cấp cho gv tham gia mỗi đề tài không được vượt quá kinh phí của đề tài
inserted: GV1 dt2 3
deleted: gv1 dt1 cv3