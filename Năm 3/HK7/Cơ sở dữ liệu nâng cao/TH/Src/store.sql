GO
create or alter procedure sp_themmoiGV
    @magv varchar(10),
    @hoten nvarchar(20),
    @luong int,
    @phai nvarchar(5),
    @ngsinh date,
    @diachi nvarchar(50),
    @gvqlcm varchar(10),
    @mabm nvarchar(10)
as
begin
    if exists(select *
    from GIAOVIEN
    where MAGV = @magv)
    begin
        RAISERROR('GV da them roi', 15, 1)
        return -1
    end
    if (year(GETDATE() - year(@ngsinh)) < 22)
    BEGIN
        RAISERROR('GV chua du tuoi quy dinh', 15, 1)
        return -1
    END
    insert into GIAOVIEN
        (MAGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI, GVQLCM, MABM)
    VALUES
        (@magv, @hoten, @luong, @phai, @ngsinh, @diachi, @gvqlcm, @mabm)

    return 0
end

EXEC sp_themmoiGV '090', N'Tran A', '30000', 'Nam', null, null, null, null


go
create or alter procedure sp_XacDinhSTTCongViec
    @madt NVARCHAR(10),
    @sttnew int OUTPUT
AS
BEGIN
    SELECT @sttnew = ISNULL(MAX(CONGVIEC.STT), 0) + 1
    FROM CONGVIEC
    WHERE MADT = @madt
END

declare @sttnew int
exec sp_XacDinhSTTCongViec '001', @sttnew out
print @sttnew

GO
create or alter procedure sp_themmoiCV
    @madt NVARCHAR(10),
    @tenCv NVARCHAR(50),
    @ngaybd date,
    @ngatkt date
as
begin
    declare @stt int
    EXEC sp_XacDinhSTTCongViec @madt, @stt out
    if exists (select *
    from CONGVIEC
    where MADT = @madt and STT = @stt)
    begin
        RAISERROR('Trung cong viec', 15, 1)
    end
    INSERT into CONGVIEC
        (MADT, STT, TENCV, NGAYBD, NGAYKT)
    values
        (@madt, @stt, @tenCv, @ngaybd, @ngatkt)
    print 'Them thanh cong'
END


exec sp_themmoiCV N'007', N'Cong viec 7', '2025-03-02', null
select *
from CONGVIEC
where MADT = N'007'


go
create or alter procedure sp_KiemTraGVTonTai
    @magv varchar(10)
as
BEGIN
    IF EXISTS (Select *
    from GIAOVIEN
    where MAGV = @magv)
    BEGIN
        RAISERROR('Giao vien da ton tai roi.', 15, 1)
        return 1
    END
    print('Giao vien chua ton tai trong du lieu')
    RETURN -1
END

declare @check int
EXEC sp_KiemTraGVTonTai '001'


select bm.MABM, bm.TENBM,
    (select count(*)
    from GIAOVIEN
    where PHAI = N'Nam' and MABM = bm.MABM) AS SOGVNam
    ,
    (select count(*)
    from GIAOVIEN
    where PHAI = N'Nu' and MABM = bm.MABM) AS SOGVNu
from BOMON bm

GO
create or alter function fn_DemGV_Phai_BM(@mabm NVARCHAR(10), @phai NVARCHAR(5))
returns int
AS
begin
    return (select count(*)
    from GIAOVIEN
    where MABM = @mabm and PHAI = @phai)
end

select bm.MABM, bm.TENBM, dbo.DemGV_Phai_BM(bm.MABM, N'Nam') as SOGVNam
from BOMON bm

go
create or alter function fDSGV_HTTT(@mabm nvarchar(10))
returns table
as
    return (Select *
from GIAOVIEN
where MABM = @mabm)

select *
from dbo.fDSGV_HTTT('HTTT')
-- Trigger
update BOMON
set SoGV_BM = T.SoGV
from (select MABM, count(MAGV) as SoGV
    from GIAOVIEN
    GROUP BY MABM) as T
where BOMON.MABM = T.MABM

