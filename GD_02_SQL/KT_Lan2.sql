USE MASTER
DROP DATABASE Db_qlgh
CREATE DATABASE DB_QLGH ON PRIMARY
(
	NAME = 'DBQLGH_PRIMARY',
	FILENAME = 'D:\08_2001190509_VoThiThuHa_KT2\DBQLGH_PRIMARY.mdf',
	SIZE = 5 MB,
	MAXSIZE = 10 MB,
	FILEGROWTH = 10%
)
LOG ON
(
	NAME = 'DBQLGH_LOG',
	FILENAME = 'D:\08_2001190509_VoThiThuHa_KT2\DBQLGH_LOG.ldf',
	SIZE = 2 MB,
	MAXSIZE = 5 MB,
	FILEGROWTH = 15%
)

USE DB_QLGH
GO
CREATE TABLE KHACHHANG
(
	MAKH CHAR(8) NOT NULL,
	TENCTY NVARCHAR(50),
	TENGD Char(3),
	DIACHI NVARCHAR(50),
	EMAIL VARCHAR(50),
	DIENTHOAI NCHAR(11)
)
GO

CREATE TABLE NHANVIEN
(
	MANV CHAR(8) NOT NULL,
	HOTEN NVARCHAR(50),
	NGAYSINH DATE,
	NGAYLAMVIEC DATE,
	DIACHI NVARCHAR(50),
	DIENTHOAI NCHAR(11),
	HESOLUONG NUMERIC (3,1),
	PHUCAP FLOAT
)
GO

CREATE TABLE LOAIHANG
(
	MALOAI CHAR(8) NOT NULL,
	TENLOAI NVARCHAR(50)
)

GO

CREATE TABLE MATHANG
(
	MAHANG CHAR(8) NOT NULL,
	TENHANG NVARCHAR(50),
	MACTY CHAR(8),
	MALOAI CHAR(8),
	SOLUONG INT,
	DONVITINH CHAR(8),
	GIAHANG INT
)
GO
CREATE TABLE NHACUNGCAP
(
	MACTY CHAR(8)NOT NULL,
	TENCTY NVARCHAR(50),
	TENGD Char(3),
	DIACHI NVARCHAR(50),
	EMAIL VARCHAR(50),
	DIENTHOAI NCHAR(11)
)
CREATE TABLE DONDATHANG 
(
	SOHD CHAR(8) NOT NULL,
	MAKH CHAR(8),
	MANV CHAR(8),
	NGAYDATHANG DATE,
	NGAYGIAOHANG DATE,
	NGAYCHUYENHANG DATE,
	NOIGIAOHANG NVARCHAR(50),
)

CREATE TABLE CHITIETDATHANG
(
	SOHD CHAR(8) NOT NULL,
	MAHANG CHAR(8) NOT NULL,
	GIABAN NUMERIC(10,2),
	SOLUONG INT,
	MUCGIAMGIA FLOAT
)

-- TẠO KHÓA CHÍNH
ALTER TABLE KHACHHANG  ADD CONSTRAINT PK_KH PRIMARY KEY (MAKH)
ALTER TABLE NHANVIEN  ADD CONSTRAINT PK_NV PRIMARY KEY (MANV)
ALTER TABLE DONDATHANG  ADD CONSTRAINT PK_DDH PRIMARY KEY (SOHD)
ALTER TABLE LOAIHANG  ADD CONSTRAINT PK_LH PRIMARY KEY (MALOAI)
ALTER TABLE MATHANG  ADD CONSTRAINT PK_MH PRIMARY KEY (MAHANG)
ALTER TABLE NHACUNGCAP  ADD CONSTRAINT PK_NCC PRIMARY KEY (MACTY)
ALTER TABLE CHITIETDATHANG  ADD CONSTRAINT PK_CTDH PRIMARY KEY (SOHD,MAHANG)
-- TẠO KHÓA NGOẠI
ALTER TABLE DONDATHANG ADD CONSTRAINT FK_DDH_KH FOREIGN KEY(MAKH) REFERENCES KHACHHANG (MAKH)
ALTER TABLE DONDATHANG ADD CONSTRAINT FK_DDDH_NV FOREIGN KEY(MANV) REFERENCES NHANVIEN (MANV)
ALTER TABLE MATHANG ADD CONSTRAINT FK_MH_LH FOREIGN KEY(MALOAI) REFERENCES LOAIHANG (MALOAI)
ALTER TABLE MATHANG ADD CONSTRAINT FK_MH_NCC FOREIGN KEY(MACTY) REFERENCES NHACUNGCAP (MACTY)
ALTER TABLE CHITIETDATHANG ADD CONSTRAINT FK_CTDH_MH FOREIGN KEY(MAHANG) REFERENCES MATHANG (MAHANG)
ALTER TABLE CHITIETDATHANG ADD CONSTRAINT FK_CTDH_DDH FOREIGN KEY(SOHD) REFERENCES DONDATHANG (SOHD)
-- Thiết lập đơn vị tính mặc định là cái
alter table mathang add constraint df_dvt default N'cái' for donvitinh
-- Thiết lập ngày giao hàng phải lớn hơn ngày đặt hàng 
alter table dondathang add constraint ck_dh1 check (ngaydathang< ngaygiaohang)
alter table nhanvien add constraint ck_nlv check (ngaylamviec<=getdate())
-- thiết lập 
-- NHẬP BẢNG KHÁCH HÀNG
insert into KHACHHANG  values
('KH01', N'HƯNG THỊNH', 'MUA', N'BẾN TRE','','0982347678'),
('KH02', N'NGỌC LAN', 'BÁN', N'BẾN TRE','','0912341238'),
('KH03', N'CHẤN SANG', 'BÁN', N'ĐỒNG NAI','','0931234560'),
('KH04', N'TRÍ TÍNH', 'BÁN', N'BẾN TRE','','0922226666'),
('KH05', N'ĐẠI THÀNH', 'MUA', N'ĐỒNG THÁP','','0912341238'),
('KH06', N'HOA ANH ĐÀO', 'BÁN', N'LÂM ĐỒNG','','0912341238')
-- NHẬP BẢNG NHÂNV VIÊN
insert into nhanvien values 
('NV01',N'VÕ THÀNH CÔNG', '1975-03-15','2008-04-05','TPHCM','0912333789', 3.3, 500000),
('NV02',N'lÊ VĂN LANG', '1970-08-16','2007-04-04','TPHCM','0912333789', 2.0, 500000),
('NV03',N'TRẦN VĂN TRÀ', '1981-05-06','2009-06-07','LONG AN','', 2.0, 500000),
('NV04',N'TRẦN BÍCH HẠNH', '1979-12-02','2010-07-07',N'ĐỒNG THÁP','', 3.6, 0),
('NV05',N'LÊ THU HÀ', '1974-12-02','2008-10-12',N'ĐỒNG THÁP','', 3.9, 0),
('NV06',N'NGUYỄN MINH ANH', '1972-01-02','2009-10-12',N'BÌNH THUẬN','', 4.3, 0)
-- NHẬP BẢNG LOẠI HÀNG
insert into LOAIHANG values
('LH01', N'SỮA'),
('LH02', N'ĐƯỜNG'),
('LH03', N'BỘT NGỌT'),
('LH04', N'KẸO'),
('LH05', N'XÀ BÔNG'),
('LH06', N'NƯỚC MẮM')
--NHẬP NHÀ CUNG CẤP
insert into NHACUNGCAP  values
('CC01', N'ABORT CO', 'SU1', N'BẾN TRE','','0982347678'),
('CC02', N'ĐƯỜNG BIÊN HÒA', 'DU1', N'ĐỒNG NAI','','0992456678'),
('CC03', N'BỘT NGỌT AJINO', 'BN1', N'ĐỒNG NAI','','0972451234'),
('CC04', N'BỘT NGỌT MIWON', 'BN2', N'ĐỒNG NAI','','0900987658'),
('CC05', N'ĐƯỜNG BOURBON', 'DU2', N'TÂY NINH','','0387953978'),
('CC06', N'ĐƯỜNG THỐT NỐT DUY AN', 'DU3', N'AN GIANG','','037795226')
-- chèn bảng mặt hàng
insert into mathang values 
('MH01',N'SỮA ĐẶC CÓ ĐƯỜNG', 'CC01','LH01', 300,N'HỘP', 17000),
('MH02',N'SỮA ĐẶC TĂNG TRƯỞNG', 'CC01','LH01', 500,N'HỘP', 100000),
('MH03',N'Bột ngọt AJI1', 'CC03','LH03', 500,N'TÚI', 120000),
('MH04',N'Bột ngọt MIWON2', 'CC04','LH03', 200,N'TÚI', 55000),
('MH05',N'Bột ngọt MIWON2', 'CC04','LH03', 100,N'TÚI', 110000),
('MH06',N'ĐƯỜNG ORGANIC', 'CC05','LH02', 100,N'TÚI', 60000),
('MH07',N'ĐƯỜNG phèn', 'CC05','LH02', 100,N'TÚI', 50000),
('MH08',N'ĐƯỜNG đen', 'CC05','LH02', 50,N'TÚI', 30000),
('MH09',N'ĐƯỜNG Thốt Nốt', 'CC05','LH02', 30,N'TÚI', 80000),
('MH10',N'Bột ngọt Cholimex', 'CC03','LH03', 500,N'TÚI', 120000),
('MH11',N'Bột ngọt Chinsu', 'CC03','LH03', 500,N'TÚI', 120000)

-- nhập bảng đơn đặt hàng
insert into DONDATHANG values
('HD01', 'KH01','NV01', '2019/03/02', '2019/03/15', '2019/03/19', N'SƠN LA'),
('HD02', 'KH01','NV02', '2019/05/03', '2019/05/8', '2019/05/12', N'PHÚ YÊN'),
('HD03', 'KH02','NV01', '2018/03/02', '2019/03/6', '2018/03/7', N'HÀ NỘI'),
('HD04', 'KH03','NV01', '2017/12/02', '2019/12/7', '2019/12/9', N'CÀ MAU'),
('HD05', 'KH01','NV01', '2019/06/04', '2019/06/15', '2019/06/19',N'BÌNH ĐỊNH'),
('HD06', 'KH04','NV03', '2019/07/01', '2019/07/4', '2019/07/8', N'SƠN LA')
-- nhập bảng giao hàng
insert into CHITIETDATHANG values
('HD01','MH01', 20000, 5, 0.05 ),
('HD01','MH02', 150000, 10, 0.04 ),
('HD01','MH06', 80000, 3, 0 ),
('HD02','MH03', 150000, 8, 0.01 ),
('HD02','MH04', 60000, 5, 0 ),
('HD03','MH02', 120000, 8, 0.02 ),
('HD06','MH01', 20000, 5, 0.05 ),
('HD06','MH02', 150000, 10, 0.04 ),
('HD06','MH06', 80000, 3, 0 )
go
--Cho 2 biến @sohd (số hóa đơn) có giá trị là „HD01‟và biến @tong dùng để tính tổng tiền của của mỗi hóa đơn (tổng tiền = số lượng * giá bán)
--a.  (0,75 đ) Tiến hành khai báo 2 biến trên và dùng lệnh print để in ra tổng tiền của hóa đơn „HD01‟
declare @sohd CHAR(10),@TONG NUMERIC(10,2)
set @sohd='HD01'
SELECT @TONG=SUM(SOLUONG*GIABAN) FROM CHITIETDATHANG WHERE SOHD=@SOHD
PRINT 'HOÁ ĐƠN '+RTRIM(@SOHD)+N' CÓ TỔNG TIỀN LÀ:'+CAST(@TONG AS VARCHAR(50))+' VN DONG'

--b.  (0,75 đ) Thực hiện bổ sung thêm vào câu a nội dung ghi chú như sau: Nếu tổng tiền trên 1 triệu thì ghi chú là “Giao hàng miễn phí”, ngược lại ghi là “Giao hàng có tính phí”
IF(@TONG>1000000)
PRINT 'HOÁ ĐƠN '+RTRIM(@SOHD)+N' CÓ TỔNG TIỀN LÀ:'+CAST(@TONG AS VARCHAR(50))+N' VN DONG THUỘC DIỆN GIAO HÀNG MIỄN PHÍ'
ELSE
PRINT 'HOÁ ĐƠN '+RTRIM(@SOHD)+N' CÓ TỔNG TIỀN LÀ:'+CAST(@TONG AS VARCHAR(50))+N' VN DONG THUỘC DIỆN GIAO HÀNG CÓ TÍNH PHÍ'

--Câu 2: (3 điểm)
--a.  (1,5 đ) Viết thủ tục  Cập Nhật Chi Tiết Đặt Hàng (không có tham số) như sau:
---    Cập nhật Giá bán bằng 250% giá hàng (giá hàng lấy trong bảng Mặt Hàng)
---    Cập nhật Mức giảm giá bằng
--o 5% nếu số lượng hàng từ 10 trở lên,
--o 1% nếu số lượng từ 5 đến 9
--o 0% nếu số lượng dưới 5
GO
CREATE PROC PROC_CAU2
AS
BEGIN
	

	UPDATE CHITIETDATHANG SET GIABAN=2.5*(SELECT GIAHANG FROM MATHANG WHERE MATHANG.MAHANG=CHITIETDATHANG.MAHANG),
	MUCGIAMGIA=CASE WHEN SOLUONG>9 THEN 0.05
					WHEN SOLUONG>4 THEN 0.01
					ELSE 0 END										
END
--THỰC THI
EXEC PROC_CAU2
--b.  (1,5 đ) Viết thủ tục Chèn Đơn Hàng có 3 tham số là: Số hóa đơn, Mã hàng, Số lượng. Thủ tục thực hiện chèn một mẩu tin mới vào bảng ChiTietDatHang và gồm các yêu cầu sau:
---    Mỗi hóa đơn chỉ tối đa 3 mặt hàng
---    In ra thông báo lỗi nếu số hóa đơn truyền vào là rỗng
---    In ra thông báo lỗi nếu mã hàng không có trong danh mục hàng hóa
---	In ra thông báo lỗi nếu chi tiết đặt hàng đó (số hóa đơn và mã hàng) đã tồn tại trong Chi Tiết Đặt Hàng 
CREATE PROC PROC_CAU2B
@SOHD CHAR(10),@MAHANG CHAR(10),@SOLUONG INT
AS
BEGIN
	
	IF(@SOHD='')
	PRINT N'HOÁ ĐƠN KHÔNG ĐƯỢC RỖNG'
	ELSE
	IF NOT EXISTS(SELECT *FROM MATHANG WHERE MAHANG=@MAHANG)
	PRINT N'MÃ HÀNG không có trong danh mục hàng hóa'
	ELSE
	IF EXISTS(SELECT *FROM CHITIETDATHANG WHERE MAHANG=@MAHANG AND SOHD=@SOHD)
	PRINT N'Số hóa đơn và mã hàng) đã tồn tại trong Chi Tiết Đặt Hàng'
	ELSE
	BEGIN
		DECLARE @COUNT INT
		SELECT @COUNT=COUNT(*) FROM CHITIETDATHANG WHERE SOHD=@SOHD
		IF(@COUNT>=3)
		PRINT N'Mỗi hóa đơn chỉ tối đa 3 mặt hàng'
		ELSE
		BEGIN
		DECLARE @GIABAN NUMERIC(10,2),@MUCGIAMGIA FLOAT
		SELECT @GIABAN=GIAHANG*2.5 FROM MATHANG WHERE MATHANG.MAHANG=@MAHANG
		SET @MUCGIAMGIA=CASE WHEN @SOLUONG>9 THEN 0.05
					WHEN @SOLUONG>4 THEN 0.01
					ELSE 0 END		
		INSERT INTO CHITIETDATHANG VALUES(@SOHD,@MAHANG,@GIABAN,@SOLUONG,@MUCGIAMGIA)
		END
	END
END
EXEC PROC_CAU2B 'HD03','MH03',2
--Câu 3: (3 điểm)
--a.  (1,5 đ) Viết hàm truyền vào tham số là mã khách hàng và trả về tổng tiền thanh toán của khách hàng đó. Biết tổng tiền thanh toán bao gồm tổng tiền hàng và thuế như sau:
---    Tiền hàng= số lượng  * giá bán- giảm giá ( trong đó giảm giá = số lượng * giá
--bán *mức giảm giá)
---    Thuế= 10% tiền hàng
CREATE PROC PROC_CAU3A
@MAKH CHAR(10)
AS 
BEGIN
RETURN (SELECT SUM(SOLUONG*GIABAN-SOLUONG*GIABAN*MUCGIAMGIA) FROM DONDATHANG,CHITIETDATHANG WHERE DONDATHANG.SOHD=CHITIETDATHANG.SOHD
AND MAKH=@MAKH)*0.9
END
DECLARE @TONG NUMERIC(10,2)
EXEC @TONG= PROC_CAU3A 'KH01'
PRINT N'TỔNG TIỀN:'+ CAST(@TONG AS VARCHAR(50))
--b.  (1,5 đ) Viết hàm truyền vào mã khách hàng và trả về danh sách là thông tin mua hàng liên quan đến khách hàng đó. Danh sách gồm: Số hóa đơn, tên hàng, số lượng, giá bán, thành tiền, chiết khấu. Biết:
---    Thành tiền= số lượng * giá bán
---	Chiết khấu = 10% của thành tiền nếu số lượng hàng từ 5 trở lên, ngược lại chiết khấu bằng 0

CREATE PROC PROC_CAU3B 
@MAKH CHAR(10)
AS
BEGIN
SELECT DONDATHANG.SOHD,TENHANG,CHITIETDATHANG.SOLUONG,CHITIETDATHANG.GIABAN,CHITIETDATHANG.SOLUONG*GIABAN 'THÀNH TIỀN',CASE WHEN CHITIETDATHANG.SOLUONG>4 THEN CHITIETDATHANG.SOLUONG*0.1*GIABAN ELSE 0 END 'CHIẾT KHẤU'
 FROM DONDATHANG,CHITIETDATHANG,MATHANG WHERE DONDATHANG.SOHD=CHITIETDATHANG.SOHD AND MATHANG.MAHANG=CHITIETDATHANG.MAHANG
AND MAKH=@MAKH
END
EXEC PROC_CAU3B 'KH01'
--Câu 4: (1 điểm) Cài đặt Trigger
--a.  (0,5đ) Khi nhập hoặc sửa dữ liệu trong bảng ChiTietDatHang thì số lượng phải luôn
--lớn hơn 0.
SELECT *FROM CHITIETDATHANG
CREATE TRIGGER TRG_CAU4A ON CHITIETDATHANG
FOR INSERT,UPDATE
AS
BEGIN
	IF((SELECT SOLUONG FROM inserted)<=0)
	BEGIN
		PRINT N'SỐ LƯỢNG PHẢI LỚN HƠN 0'
		ROLLBACK TRAN
	END
END
insert into CHITIETDATHANG values
('HD01','MH05', 20000, 0, 0.05 )
insert into CHITIETDATHANG values
('HD01','MH05', 20000, 1, 0.05 )
--b.  (0,5đ) Cài đặt mỗi khi xóa các hóa đơn trong DonDatHang thì cũng tự động xóa các hóa đơn có liên quan trong ChiTietDatHang.
CREATE TRIGGER TRG_CAU4B ON DONDATHANG
INSTEAD OF DELETE
AS
BEGIN
DECLARE @SOHD CHAR(10)
	SELECT @SOHD=SOHD FROM deleted
	DELETE CHITIETDATHANG WHERE SOHD=@SOHD
	DELETE DONDATHANG WHERE SOHD=@SOHD
END
DELETE DONDATHANG WHERE SOHD='HD01'
--Câu 5: (1,5 điểm) Câu hỏi về Cursor
--a.  (0,5 đ) Viết cursor thực hiện in ra tên hàng chưa được bán. Lưu ý chỉ in một mặt
--hàng đầu tiên trong danh sách các tên hàng, không in hết toàn bộ.
DECLARE CS_CAU5A CURSOR
FOR SELECT MAHANG FROM MATHANG WHERE MAHANG NOT IN (SELECT DISTINCT MAHANG FROM CHITIETDATHANG)
	OPEN CS_CAU5A
			DECLARE @MAHANG CHAR(10)
			FETCH NEXT FROM CS_CAU5A INTO @MAHANG
			IF(@@FETCH_STATUS=0)
			BEGIN
				DECLARE @TENHANG NVARCHAR(50)
				SELECT @TENHANG=TENHANG FROM MATHANG WHERE MAHANG=@MAHANG
				PRINT 'TÊN HÀNG:'+@TENHANG
			END
	CLOSE CS_CAU5A
	DEALLOCATE CS_CAU5A


GO
DECLARE CS_CAU5A CURSOR
FOR SELECT MAHANG FROM MATHANG 
OPEN CS_CAU5A
DECLARE @MAHANG CHAR(10)
FETCH NEXT FROM CS_CAU5A INTO @MAHANG
DECLARE @COUNT INT
SET @COUNT=1
WHILE(@@FETCH_STATUS=0)
BEGIN	
	IF(@COUNT>=@VITRILAST)
 SET @COUNT+=1
FETCH NEXT FROM CS_CAU5A INTO @MAHANG

END
CLOSE CS_CAU5A
DEALLOCATE CS_CAU5A

SELECT *FROM MATHANG

--b.  (0,5 đ) Viết thủ tục có tham số kết hợp với cursor in ra tên các mặt hàng chưa bán.
--Yêu cầu chỉ in ra n mẩu tin tính từ mẩu tin bắt đầu nào đó, không in hết toàn bộ mẩu tin.
CREATE PROC PROC_CAU5B
@BATDAU INT,@SOMAUTIN INT
AS
BEGIN
DECLARE CS_CAU5A CURSOR
SCROLL
FOR SELECT TENHANG FROM MATHANG WHERE MAHANG NOT IN (SELECT DISTINCT MAHANG FROM CHITIETDATHANG)
OPEN CS_CAU5A
DECLARE @TENHANG NVARCHAR(50),@COUNT INT
SELECT @COUNT=1
FETCH NEXT FROM CS_CAU5A INTO @TENHANG	
WHILE(@@FETCH_STATUS=0)
BEGIN	
	IF(@COUNT>=@BATDAU AND (@COUNT-@BATDAU)<@SOMAUTIN)
	PRINT @TENHANG+' '
	SET @COUNT+=1
	FETCH NEXT FROM CS_CAU5A INTO @TENHANG	
END
CLOSE CS_CAU5A
DEALLOCATE CS_CAU5A
END
EXEC PROC_CAU5B 2,3
--Gợi ý: Thủ tục có 2 tham số đầu vào là vị trí mẩu tin bắt đầu và số mẩu tin được duyệt.

--c.  (0,5 đ) Kết hợp cursor, viết hàm truyền vào mã nhân viên và in ra danh sách các 
--thông tin liên quan đến nhân viên đó gồm: họ tên nhân viên, mã hóa đơn, mã hàng, thành tiền (=số lượng * giá bán)
CREATE FUNCTION FUNC_CAU5C(@MANV CHAR(10))
RETURNS @BANGTHONGKE TABLE(HOTEN NVARCHAR(50),SOHD CHAR(10),MAHANG CHAR(10),THANHTIEN NUMERIC(10,2))
AS
BEGIN
DECLARE CS_CAU5C CURSOR 
FOR SELECT DONDATHANG.SOHD,MAHANG,HOTEN FROM DONDATHANG,NHANVIEN,CHITIETDATHANG WHERE NHANVIEN.MANV=DONDATHANG.MANV AND CHITIETDATHANG.SOHD=DONDATHANG.SOHD AND NHANVIEN.MANV=@MANV
OPEN CS_CAU5C
DECLARE @SOHD CHAR(10),@MAHANG CHAR(10),@HOTEN NVARCHAR(50)
FETCH NEXT FROM CS_CAU5C INTO @SOHD,@MAHANG,@HOTEN
WHILE(@@FETCH_STATUS=0)
BEGIN
	DECLARE @THANHTIEN NUMERIC(10,2)
	SELECT @THANHTIEN=SOLUONG*GIABAN FROM CHITIETDATHANG WHERE SOHD=@SOHD AND MAHANG=@MAHANG
	INSERT INTO @BANGTHONGKE SELECT @HOTEN,@SOHD,@MAHANG,@THANHTIEN
	FETCH NEXT FROM CS_CAU5C INTO @SOHD,@MAHANG,@HOTEN
END
CLOSE CS_CAU5C
DEALLOCATE CS_CAU5C
RETURN
END
SELECT *FROM DBO.FUNC_CAU5C('NV03')




































----Câu 1: (1,5 điểm)
----Cho 2 biến @sohd (số hóa đơn) có giá trị là „HD01‟và biến @tong dùng để tính tổng tiền của của mỗi hóa đơn (tổng tiền = số lượng * giá bán)
--CREATE PROC CAU_1( @SOHD NCHAR(10),@TONG INT OUT)
--AS
--BEGIN 
--	SET @TONG=(SELECT SUM(SOLUONG*GIABAN)
--	FROM CHITIETDATHANG 
--	WHERE @SOHD=SOHD)
--end

--GO
	
----a.  (0,75 đ) Tiến hành khai báo 2 biến trên và dùng lệnh print để in ra tổng tiền của hóa đơn „HD01‟
--declare @SOHD NCHAR(10),@TONG INT 
--	EXEC CAU_1 'HD01',@TONG OUT
--	PRINT   @TONG


--	GO
----b.  (0,75 đ) Thực hiện bổ sung thêm vào câu a nội dung ghi chú như sau: Nếu tổng tiền trên 1 triệu thì ghi chú là “Giao hàng miễn phí”, ngược lại ghi là “Giao hàng có tính phí”
--CREATE PROC CAU_1B  (@SOHD NCHAR(10),@TONG INT OUT,@GH NVARCHAR(50) OUT)
--AS
--BEGIN
--	SET @TONG=(SELECT SUM(SOLUONG *GIABAN) FROM CHITIETDATHANG WHERE @SOHD=SOHD)
--	IF(@TONG>1000000)
--	BEGIN	
--		SET @GH=N'Giao hàng miễn phí'
--		END 
--			ELSE
--			SET @GH=N'Giao hàng có tính phí'
--			END
		
--GO

--SELECT*FROM CHITIETDATHANG
--DECLARE @SOHD NCHAR(10),@GH NVARCHAR(50), @TONG INT
--	EXEC dbo.CAU_1B 'HD01' ,@TONG OUT,@GH OUT
--	PRINT @TONG+CAST(@GH AS NVARCHAR(50))





	

--	GO

----Câu 2: (3 điểm)
----a.  (1,5 đ) Viết thủ tục  Cập Nhật Chi Tiết Đặt Hàng (không có tham số) như sau:
-----    Cập nhật Giá bán bằng 250% giá hàng (giá hàng lấy trong bảng Mặt Hàng)
-----    Cập nhật Mức giảm giá bằng
----o 5% nếu số lượng hàng từ 10 trở lên,
----o 1% nếu số lượng từ 5 đến 9
----o 0% nếu số lượng dưới 5
--SELECT*FROM CHITIETDATHANG
--GO
--CREATE PROC CAU2_A(@SOHD NCHAR(10),@TONG INT OUT)
--AS
--BEGIN
--	SET @TONG=(SELECT SUM(SOLUONG*GIABAN) FROM CHITIETDATHANG
--	WHERE @SOHD=SOHD)
--	END
--GO
------GOI THUC THI
--DECLARE @SOHD NCHAR(10),@TONG INT
--EXEC CAU2_A'HD01',@TONG OUT

--PRINT @TONG




----b.  (1,5 đ) Viết thủ tục Chèn Đơn Hàng có 3 tham số là: Số hóa đơn, Mã hàng, Số lượng. Thủ tục thực hiện chèn một mẩu tin mới vào bảng ChiTietDatHang và gồm các yêu cầu sau:
-----    Mỗi hóa đơn chỉ tối đa 3 mặt hàng
-----    In ra thông báo lỗi nếu số hóa đơn truyền vào là rỗng
-----    In ra thông báo lỗi nếu mã hàng không có trong danh mục hàng hóa
-----	In ra thông báo lỗi nếu chi tiết đặt hàng đó (số hóa đơn và mã hàng) đã tồn tại trong Chi Tiết Đặt Hàng 

----Câu 3: (3 điểm)
----a.  (1,5 đ) Viết hàm truyền vào tham số là mã khách hàng và trả về tổng tiền thanh toán của khách hàng đó. Biết tổng tiền thanh toán bao gồm tổng tiền hàng và thuế như sau:
-----    Tiền hàng= số lượng  * giá bán- giảm giá ( trong đó giảm giá = số lượng * giá
----bán *mức giảm giá)
-----    Thuế= 10% tiền hàng


--select*from MATHANG
--select*from CHITIETDATHANG

--CREATE function CAU3A(@MAKH char (10))
--returns int 
--as
--begin
--			declare @TONGTIEN int
--			set @TONGTIEN=(select SUM(SOLUONG*GIABAN)-(SUM(SOLUONG*GIABAN*MUCGIAMGIA)) 
--			from CHITIETDATHANG,DONDATHANG 
--			WHERE CHITIETDATHANG.SOHD=DONDATHANG.SOHD AND @MAKH=DONDATHANG.MAKH)
--			return @TONGTIEN*0.9
--end
--declare @TONGTIEN int
--set @TONGTIEN= dbo.CAU3A ('KH01')
--select @TONGTIEN as 'SO TIEN'

----b.  (1,5 đ) Viết hàm truyền vào mã khách hàng và trả về danh sách là thông tin mua hàng liên quan đến khách hàng đó. Danh sách gồm: Số hóa đơn, tên hàng, số lượng, giá bán, thành tiền, chiết khấu. Biết:
-----    Thành tiền= số lượng * giá bán
-----	Chiết khấu = 10% của thành tiền nếu số lượng hàng từ 5 trở lên, ngược lại chiết khấu bằng 0

--CREATE FUNCTION CAU3_B (@MAKH CHAR(50))
--RETURNS TABLE 
--AS
--BEGIN
--	DECLARE @THANHTIEN FLOAT
--	SET @THANHTIEN=(SELECT SUM(SOLUONG*GIABAN)
--	FROM CHITIETDATHANG,DONDATHANG
--	WHERE @MAKH=MAKH AND DONDATHANG.SOHD=CHITIETDATHANG.SOHD)

--	DECLARE @CHIETKHAU FLOAT

--	IF((SELECT SOLUONG FROM CHITIETDATHANG,DONDATHANG
--	    WHERE @MAKH=MAKH AND DONDATHANG.SOHD=CHITIETDATHANG.SOHD)>5)
--		SET @CHIETKHAU=@THANHTIEN*0.1



--		RETURN (SELECT CHITIETDATHANG.SOHD,TENHANG,CHITIETDATHANG.SOLUONG,GIABAN,
--		@THANHTIEN AS THANHTIEN,@CHIETKHAU AS CHIETKHAU


--		FROM CHITIETDATHANG,MATHANG,DONDATHANG
--		WHERE CHITIETDATHANG.MAHANG=MATHANG.MAHANG AND DONDATHANG.SOHD=CHITIETDATHANG.SOHD AND @MAKH=MAKH)

--END
--GO

----Câu 4: (1 điểm) Cài đặt Trigger
----a.  (0,5đ) Khi nhập hoặc sửa dữ liệu trong bảng ChiTietDatHang thì số lượng phải luôn
----lớn hơn 0.

--SELECT*FROM CHITIETDATHANG

--CREATE TRIGGER CAU4_A ON CHITIETDATHANG
--FOR INSERT,UPDATE
--AS 
--	IF((SELECT SOLUONG FROM inserted)<0)
--		BEGIN
--		 PRINT'số lượng phải luôn lớn hơn 0'
--		 ROLLBACK TRAN
--		END


-----GOI THUC THI

--INSERT INTO  CHITIETDATHANG VALUES('HD07','MH01',20000,-1,0.05)



----b.  (0,5đ) Cài đặt mỗi khi xóa các hóa đơn trong DonDatHang thì cũng tự động xóa các hóa đơn có liên quan trong ChiTietDatHang.

--SELECT*FROM DONDATHANG
--CREATE TRIGGER CAU4_B
--ON DONDATHANG
--FOR DELETE
--AS
--		BEGIN
--			DELETE FROM CHITIETDATHANG WHERE SOHD=(SELECT SOHD FROM deleted)
--	END
--	SS

----Câu 5: (1,5 điểm) Câu hỏi về Cursor
----a.  (0,5 đ) Viết cursor thực hiện in ra tên hàng chưa được bán. Lưu ý chỉ in một mặt
----hàng đầu tiên trong danh sách các tên hàng, không in hết toàn bộ.

----b.  (0,5 đ) Viết thủ tục có tham số kết hợp với cursor in ra tên các mặt hàng chưa bán.
----Yêu cầu chỉ in ra n mẩu tin tính từ mẩu tin bắt đầu nào đó, không in hết toàn bộ mẩu tin.

----Gợi ý: Thủ tục có 2 tham số đầu vào là vị trí mẩu tin bắt đầu và số mẩu tin được duyệt.

----c.  (0,5 đ) Kết hợp cursor, viết hàm truyền vào mã nhân viên và in ra danh sách các thông tin liên quan đến nhân viên đó gồm: họ tên nhân viên, mã hóa đơn, mã hàng, thành tiền (=số lượng * giá bán)


