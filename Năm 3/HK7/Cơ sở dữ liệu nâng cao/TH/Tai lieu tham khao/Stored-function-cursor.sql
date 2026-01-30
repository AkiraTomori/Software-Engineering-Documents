--Thực hiện phân công cv cho 1 gv:
--Mỗi GV chỉ tham gia tối đa 3 cv trong 1 đtai
--GV chỉ được tham gia tối đa 2 dtai tại cùng thời điểm
insert into THAMGIADT values ('001','003',1,100,NULL)
go
create proc PhanCong
	@magv varchar(5),
	@madt varchar(5),
	@stt int,
	@phucap int
as
begin
	--kiểm tra dkien
	--đếm số đt đang tgia của gv
	if (dbo.fn_DemSoDTTG(@magv) )=2
	begin
		print 'GV đã tgia đủ 2 dtai'
		return 0 --không pcong được
	end
	--Đếm số cviec trong detai cần pc
	if (select count(*) from THAMGIADT where madt = @madt and magv = @magv) =3
	begin
		print 'GV không tham gia quá 3 sv trong 1dtai'
		return 0 --không pcong được
	end
	--thoả hết dkien
	insert into THAMGIADT values (@magv,@madt,1,@phucap,NULL)
	return 1 --thành công
end
go
create function fn_DemSoDTTG(@magv varchar(5))
returns int
as
begin
	return (select count(distinct tg.madt)
	from THAMGIADT tg join detai dt on tg.madt = dt.MADT
	where magv = @magv and dt.NGAYKT is null) 
end

--Hãy xuất ds các gv như sau:
--magv: 1211
--Họ tên: Hoàng Vy
--STT	MaDT	TenDT	Tổng PC
--1		DT01	xxxx	100
--2...
--------------------
--magv: 1311
--STT	MaDT	TenDT	Tổng PC
--1		DT01	xxxx	100
--2...
go
create proc InDSGV
as
begin
	declare cur cursor for select magv, hoten from GIANGVIEN
	open cur
	declare @magv varchar(5), @hoten nvarchar(50), @stt int = 0
	--gán giá trị đọc được đầu tiên trong cursor vào 2 biên khai báo này
	fetch next from cur into @magv, @hoten
	--sau khi gán dl của dòng đầu trong cur vào hai biên, 
	--cần kiểm tra xem có lấy được dl ko.
	while @@FETCH_STATUS =0
	begin
		print 'MaGV: ' + @magv
		print 'Hoten: ' + @hoten
		print '--------------------------'
		print 'STT		MaDT	PhuCap'
		declare curCT cursor for select madt, sum(phucap) as TongPC 
								 from THAMGIADT 
								 where magv = @magv 
								 group by magv, madt
		open curCT
		declare @madt varchar(5), @pc int
		fetch next from curCT into @madt, @pc
		while @@FETCH_STATUS = 0
		begin
			set @stt = @stt + 1
			print cast(@stt as varchar(5))+'      ' + cast(@madt as varchar(5)) +'        '+ cast(@pc as varchar(3))
			fetch next from curCT into @madt, @pc
		end
		fetch next from cur into @magv, @hoten
		close curCT
		deallocate curCT
	end
	close cur --tạm thời đóng cursor, open lại nếu muốn xài tiếp
	deallocate cur --huỷ vùng nhớ cấp phát cho cur
end
go
exec InDSGV