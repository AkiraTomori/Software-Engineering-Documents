use QLYDETAI

-- stored procedure
-- thực hiện thêm 1 phân công cho 1 giảng viên
-- Input: magv, madt, stt, phu cap, thoi gian
-- output: thêm thành công, thất bại

go 
create or alter procedure ThemPhanCongGV
    @magv varchar(10),
    @madt nvarchar(10),
    @stt int,
    @phucap int
as
begin 
    if not exists (select * from GIAOVIEN where MAGV = @magv) 
    BEGIN
        return 0
    end
    if not exists (select * from CONGVIEC where MADT = @madt and STT = @stt)
    BEGIN
        return 0
    END
    -- Kiểm tra các ràng buộc khác
    -- ví dụ: mỗi giáo viên không tham gia quá 3 công việc trong 1 đề tài
    -- và không tham gia 3 đề tài cùng lúc
    -- đếm số công việc đã phân công cho gv trong @madt
    -- đếm số đề tài đang tham gia: ngày kết thúc: null
    if (select count(*) from THAMGIADT
        where MAGV = @magv and MADT = @madt) >= 3
        BEGIN
            RAISERROR('GV đã tham gia đủ số công việc', 15, 1)
            return 0
        END
    if (select count(distinct tg.MADT) from THAMGIADT tg
        join DETAI dt on tg.MADT = dt.MADT where NGAYKT is NULL) >= 3
        BEGIN
            RAISERROR('GV đã tham gia đủ số đề tài', 15, 1)
            return 0
        END
    insert into THAMGIADT VALUES
    (@magv, @madt, @stt, @phucap, null)
    return 1
end

