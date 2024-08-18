USE MASTER
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name='QLTHOITRANG')
BEGIN
    DROP DATABASE QLTHOITRANG;
END

CREATE DATABASE QLTHOITRANG
GO

USE QLTHOITRANG
GO

CREATE TABLE TheLoai(
MaTL			INT IDENTITY(1,1)		NOT NULL,
TenTL			NVARCHAR(50)			NOT NULL,
Mota			NVARCHAR(MAX)					,
CONSTRAINT PK_THELOAI PRIMARY KEY(MaTL)
)
GO

CREATE TABLE NhaCungCap(
MaNCC			INT IDENTITY(1,1)	NOT NULL,
TenNCC			NVARCHAR(50)		NOT NULL,
DiaChi			NVARCHAR(200)				,
Mota			NVARCHAR(MAX)				,
SDT				VARCHAR(50)					,
EMAIL			VARCHAR(100)		UNIQUE	,
CONSTRAINT PK_NHACUNGCAP PRIMARY KEY(MaNCC)
)
GO


CREATE TABLE KichThuoc(

MaKT			INT IDENTITY(1,1)	NOT NULL,
TenKT			Nvarchar(50)		NOT NULL
CONSTRAINT	PK_KichThuoc PRIMARY KEY(MaKT)
)
GO


CREATE TABLE MauSac(

MaMau			INT IDENTITY(1,1)	NOT NULL,
TenMau			NVARCHAR(50)		NOT NULL,

CONSTRAINT	PK_MauSac	PRIMARY KEY(MaMau)
)
GO

CREATE TABLE SanPham (
MaSP			NVARCHAR(50)	NOT NULL,
MaTL			INT				NOT NULL,
MaNCC			INT				NOT NULL,
TenSP			NVARCHAR(max)	NOT NULL,
GiaBan			DECIMAL(18,2)	NOT NULL,
GiamGia			INT						,
HinhSP			NVARCHAR(500)			,
Mota			NVARCHAR(MAX)			,
MotaTT			NvarChar(1000)			,
NgayCapNhat		DATETIME				,
NgayTao			DATETIME				,
LuotXem			INT						,
BanChay			BIT				NOT NULL,
PhoBien			BIT				NOT NULL,
Duyet			BIT				NOT NULL,
CONSTRAINT PK_SANPHAM PRIMARY KEY(MaSp),
CONSTRAINT FK_THELOAI FOREIGN KEY(MaTL) REFERENCES THELOAI(MaTL),
CONSTRAINT FK_NHACUNGCAP FOREIGN KEY(MaNCC) REFERENCES NHACUNGCAP(MaNCC)
)
GO

CREATE TABLE SanPham_KichThuoc_MauSac (
MaSP		NVARCHAR(50)	NOT NULL,
MaKT		INT				NOT NULL,
MaMau		INT				NOT NULL,
CONSTRAINT PK_SanPham_KichThuoc_MauSac PRIMARY KEY (MaSP, MaKT, MaMau),
CONSTRAINT FK_SP FOREIGN KEY (MaSP) REFERENCES SanPham (MaSP),
CONSTRAINT FK_KichThuoc FOREIGN KEY (MaKT) REFERENCES KichThuoc (MaKT),
CONSTRAINT FK_MauSac FOREIGN KEY (MaMau) REFERENCES MauSac (MaMau)
)

CREATE TABLE KhachHang (
MaKH			INT IDENTITY(1,1)	NOT NULL,
HoTen			NVARCHAR(50)		NOT NULL,
GioiTinh		BIT							,
NgaySinh		DATETIME					,
HinhDD			NVARCHAR(MAX)				,
SDT				VARCHAR(50)					,
DiaChi			NVARCHAR(50)				,
TenDangNhap		VARCHAR(50)			UNIQUE	,
MatKhau			VARCHAR(max)		NOT NULL,
LastLogin		DATETIME					,
NgayTao			DATETIME					,
EMAIL			VARCHAR(100)		UNIQUE	,
CONSTRAINT PK_KHACHHANG PRIMARY KEY(MaKH)
)
GO


CREATE TABLE PhanQuyen(
MaQuyen			INT	IDENTITY(1,1)	NOT NULL,
TenQuyen		NVARCHAR(50)		NOT NULL,
Mota			NVARCHAR(MAX)				,
CONSTRAINT PK_PHANQUYEN PRIMARY KEY(MaQuyen)
)
GO


CREATE TABLE TaiKhoan(
MaTK			INT IDENTITY(1,1)	NOT NULL,
TenDangNhap		NVARCHAR(50)		NOT NULL,
MatKhau			VARCHAR(max)		NOT NULL,
HoTen			NVARCHAR(50)				,
SDT				VARCHAR(50)					,
DiaChi			NVARCHAR(200)				,
EMAIL			VARCHAR(100) UNIQUE			,
MaQuyen			INT							,
CONSTRAINT PK_TAIKHOAN PRIMARY KEY(MaTK),
CONSTRAINT FK_PHANQUYEN FOREIGN KEY(MaQuyen) REFERENCES PHANQUYEN(MaQuyen)
)
GO



CREATE TABLE BaiViet(
MaBV			INT IDENTITY(1,1)	NOT NULL,
TenBV			NVARCHAR(200)		NOT NULL,
NoiDung			NVARCHAR(MAX)				,
NoiDungTT		NVARCHAR(MAX)				,
HinhAnh			NVARCHAR(MAX)				,
LoaiTin			NVARCHAR(30)				,
NgayDang		DATETIME					,
LuotXem			INT							,
DaDuyet			BIT							,
MaTK			INT							,
CONSTRAINT PK_MABV PRIMARY KEY(MaBV),
CONSTRAINT FK_TAIKHOAN FOREIGN KEY(MaTK) REFERENCES TAIKHOAN(MaTK)
)
GO

CREATE TABLE DonDatHang(
MaDH			INT	IDENTITY(1,1)	NOT NULL,
MaKH			INT					NOT NULL,
NgayDatHang		DATETIME					,
NgayGiao		DATETIME					,
HoTen			NVARCHAR(500)				,
SDT				NVARCHAR(20)				,
Email			NVARCHAR(50)				,
GhiChu			VARCHAR(MAX)				,
DiaChi			NVARCHAR(200)				,
TenDH			NVARCHAR(max)				,
DaThanhToan		bit					NOT NULL,
TrangThaiDH		bit					NOT NULL,
CONSTRAINT PK_DONDATHANG PRIMARY KEY(MaDH),
CONSTRAINT FK_KHACHHANG FOREIGN KEY(MaKH) REFERENCES KHACHHANG(MaKH)
)
GO



CREATE TABLE CTDonHang(
MaCTDH			INT	IDENTITY(1,1)	NOT NULL,
MaDH			INT					NOT NULL,
MaSP			NVARCHAR(50)		NOT NULL,
MaKT			INT					NOT NULL,
MaMau			INT					NOT NULL,
NgayTao			DATETIME					,				
GiaBan			DECIMAL(18,2) 		NOT NULL,
SoLuong			INT							,
GiamGia			INT							,
TongTien		DECIMAL(18,2)				,
CONSTRAINT PK_CTDONHANG PRIMARY KEY(MaCTDH) ,
CONSTRAINT FK_SANPHAM FOREIGN KEY(MaSP) REFERENCES SANPHAM(MaSP),
CONSTRAINT FK_DONDATHANG FOREIGN KEY(MaDH) REFERENCES DONDATHANG(MaDH)
)
GO



CREATE TABLE LienHe(
MaLH INT,
HoTen NVARCHAR(50) NOT NULL,
EMAIL VARCHAR(100) UNIQUE,
NoiDung NVARCHAR(MAX),
NgayGui DATETIME,
CONSTRAINT PK_LIENHE PRIMARY KEY(MaLH)
)
GO


INSERT INTO PhanQuyen (TenQuyen,Mota)
VALUES (N'Admin',N'Quan tri'),
		(N'User',N'nhan vien')

INSERT INTO TaiKhoan (TenDangNhap,MatKhau,HoTen,SDT,DiaChi,EMAIL,MaQuyen)
VALUES (N'admin',N'e10adc3949ba59abbe56e057f20f883e',N'Admin',N'0786763520',N'ABC',N'admin@gmail.com',1)


INSERT INTO KhachHang (HoTen,TenDangNhap,MatKhau,EMAIL)
values (N'Admin',N'admin',N'e10adc3949ba59abbe56e057f20f883e',N'admin@gmail.com')


INSERT INTO NhaCungCap (TenNCC,EMAIL)
Values (N'Gucci',N'Gucci@gmail.com')


INSERT INTO TheLoai(TenTL)
Values	(N'Áo Khoác'),
		(N'Áo Sơ Mi'),
		(N'Áo Thun'),
		(N'Quần Tây'),
		(N'Quần JOGGER'),
		(N'Quần Jean')


INSERT INTO KichThuoc(TenKT)
VALUES ('S'),
('M'),
('L'),
('XL'),
('XXL'),
('29'),
('30'),
('31'),
('32'),
('33')




INSERT INTO MauSac (TenMau)
VALUES (N'Xám'),
(N'Đen'),
(N'Trắng'),
(N'Xanh')


INSERT INTO SanPham (MaSP,MaTL,MaNCC,TenSP,GiaBan,GiamGia,HinhSP,BanChay,PhoBien,Duyet)
Values	(N'SP01',1,1,N'Áo khoác chống nắng Denim',300000,30,N'SP01.jpg',1,0,1),
		(N'SP02',2,1,N'Áo Sơ Mi Họa Tiết The Days Eye',257000,15,N'SP02.jpg',0,1,1),
		(N'SP03',1,1,N'Áo Khoác Vải Dù Chống Nắng Họa Tiết Có Nón Y2010 Originals',427000,0,N'SP03.jpg',0,1,1),
		(N'SP04',3,1,N'Áo Thun Vải Cotton Compact 2S Thấm Hút Mềm Mại Y2010 Originals',257000,50,N'SP04.jpg',1,1,1),
		(N'SP05',3,1,N'Áo Polo Vải Cotton Compact 2S Thấm Hút Mềm Mại The Days Eye',327000,20,N'SP05.jpg',0,1,1),
		(N'SP06',3,1,N'Áo Thun Sweater Vải Cotton Double Face Bền Bỉ Thoáng Khí Y2010 Originals',357000,20,N'SP06.jpg',1,1,1), 

		(N'SP07',4,1,N'Quần Tây Tối Giản HG17',325000,20,N'SP07.jpg',0,1,1), 
		(N'SP08',5,1,N'Quần Dài Vải Cotton Double Face Co Giãn Thoáng khí Nhanh Khô Y2010 Originals',397000,10,N'SP08.jpg',1,1,1), 

		(N'SP09',4,1,N'Quần Tây Đơn Giản Y Nguyên Bản Ver22',427000 ,20,N'SP09.jpg',1,0,1), 

		(N'SP10',5,1,N'Quần Dài Vải Linh Vật Bbuff Ver7',325000,10,N'SP10.jpg',1,0,1), 
		(N'SP11',6,1,N'Quần Jean Straight TSONS 47',397000 ,10,N'SP11.jpg',1,1,1), 
		(N'SP12',6,1,N'Quần Jean Slimfit TSONS 36',427000,10,N'SP12.jpg',1,0,1)		





INSERT INTO SanPham_KichThuoc_MauSac (MaSP, MaKT, MaMau)
VALUES
	('SP01', 2, 2),   -- Màu Đen, Size M
	('SP01', 3, 2),   -- Màu Đen, Size L
	('SP01', 4, 2),   -- Màu Đen, Size XL
	('SP01', 5, 2),   -- Màu Đen, Size XXL
	('SP01', 2, 3),   -- Màu Trắng, Size M
	('SP01', 3, 3),   -- Màu Trắng, Size L
	('SP01', 4, 3),   -- Màu Trắng, Size XL
	('SP01', 5, 3),   -- Màu Trắng, Size XXL
	('SP02', 1, 1),   -- Màu Xám, Size S
	('SP02', 2, 1),   -- Màu Xám, Size M
	('SP02', 3, 1),   -- Màu Xám, Size L
	('SP02', 4, 1),   -- Màu Xám, Size XL
	('SP03', 1, 2),   -- Màu Đen, Size S
	('SP03', 2, 2),   -- Màu Đen, Size M
	('SP03', 3, 2),   -- Màu Đen, Size L
	('SP03', 4, 2),   -- Màu Đen, Size XL
	('SP04', 1, 2),   -- Màu Đen, Size S
	('SP04', 2, 2),   -- Màu Đen, Size M
	('SP04', 3, 2),   -- Màu Đen, Size L
	('SP04', 4, 2),   -- Màu Đen, Size XL
	('SP05', 1, 2),   -- Màu Đen, Size S
	('SP05', 2, 2),   -- Màu Đen, Size M
	('SP05', 3, 2),   -- Màu Đen, Size L
	('SP05', 4, 2),   -- Màu Đen, Size XL
	('SP06', 6, 3),   -- Màu Xanh, Size S
	('SP06', 3, 3),   -- Màu Xanh, Size L
	('SP06', 4, 3),   -- Màu Xanh, Size XL
	('SP07', 6, 2),   -- Màu Đen, Size 29
	('SP07', 7, 2),   -- Màu Đen, Size 30
	('SP07', 8, 2),   -- Màu Đen, Size 31
	('SP07', 9, 2),	  -- Màu Đen, Size 32
	('SP07', 10, 2),  -- Màu Đen, Size 33
	('SP08', 1, 1),   -- Màu Xám, Size S
	('SP08', 3, 1),   -- Màu Xám, Size L
	('SP09', 7, 2),   -- Màu Đen, Size 30
	('SP09', 8, 2),   -- Màu Đen, Size 31
	('SP09', 9, 2),  -- Màu Đen, Size 32
	('SP09', 10, 2),  -- Màu Đen, Size 33
	('SP10', 3, 1),   -- Màu Trắng, Size L
	('SP10', 4, 1),   -- Màu Trắng, Size XL
	('SP10', 5, 3),   -- Màu Xanh, Size S
	('SP11', 6, 4),   -- Màu Xanh, Size 29
	('SP11', 7, 4),   -- Màu Xanh, Size 30
	('SP11', 9, 4),   -- Màu Xanh, Size 31
	('SP11', 10, 4),  -- Màu Xanh, Size 33
	('SP12', 7, 2),   -- Màu Đen, Size 30
	('SP12', 8, 2),   -- Màu Đen, Size 31
	('SP12', 9, 2),   -- Màu Đen, Size 32
	('SP12', 10, 2);  -- Màu Đen, Size 33



GO

DECLARE @counter INT = 1

WHILE @counter <= 5
BEGIN
    INSERT INTO BaiViet(TenBV,NoiDung,NoiDungTT,HinhAnh,LoaiTin,NgayDang,LuotXem,DaDuyet,MaTK)
values (N'Tầm quan trọng của thời trang trong cuộc sống hiện đại',N'<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Ch&uacute;ng ta thường nhắc nhiều về thời trang. Nhiều t&iacute;n đồ y&ecirc;u th&iacute;ch thời trang cũng ưu &aacute;i m&agrave; cho rằng: C&oacute; người con người, l&agrave; c&oacute; thời trang.</span></p>
<figure id="attachment_9456" class="wp-caption aligncenter" style="box-sizing: border-box; display: block; margin-top: 0px; margin-bottom: 2em; clear: both; max-width: 100%; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; width: 800px;" aria-describedby="caption-attachment-9456"><img class="size-full wp-image-9456" style="box-sizing: border-box; border-style: none; max-width: 100%; height: auto; display: inline-block; vertical-align: middle; transition: opacity 0.5s linear 0.2s; opacity: 1;" src="https://cdn.shortpixel.ai/spai2/w_981+q_lossless+ret_img+to_webp/https://zofal.vn/wp-content/uploads/2021/07/vai-tro-thoi-trang-260621-6.jpg" sizes="(max-width: 800px) 100vw, 800px" alt="Tầm quan trọng của thời trang trong cuộc sống hiện đại" width="800" height="466" data-spai="1" data-spai-upd="785" />
<figcaption id="caption-attachment-9456" class="wp-caption-text" style="box-sizing: border-box; padding: 0.4em; font-size: 0.9em; background: rgba(0, 0, 0, 0.05); font-style: italic;">H&igrave;nh ảnh: Tầm quan trọng của thời trang trong cuộc sống hiện đại</figcaption>
</figure>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">C&oacute; nhiều định nghĩa kh&aacute;c nhau về thời trang. Nh&igrave;n chung thời trang c&oacute; thể hiểu l&agrave; kh&aacute;i niệm để chỉ một th&oacute;i quen hay một phong c&aacute;ch n&agrave;o đ&oacute; li&ecirc;n quan đến quần &aacute;o, gi&agrave;y d&eacute;p hay phụ kiện thời trang. Ngo&agrave;i ra, thời trang đ&ocirc;i khi kh&ocirc;ng chỉ l&agrave; xu hướng m&agrave; một ai đ&oacute; theo đuổi, đ&ocirc;i khi đ&oacute; đơn giản chỉ l&agrave; c&aacute;ch ch&uacute;ng ta lựa chọn trang phục h&agrave;ng ng&agrave;y. Thời trang trở th&agrave;nh một phần quan trọng của cuộc sống.</span></p>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Trong cuộc sống hiện đại, thời trang mang &yacute; nghĩa như thế n&agrave;o? C&ugrave;ng&nbsp;<span style="box-sizing: border-box; font-weight: bolder;">ZOFAL</span>&nbsp;điểm qua những &yacute; nghĩa kh&ocirc;ng thể bỏ qua.</span></p>
<div id="toc_container" class="no_bullets" style="box-sizing: border-box; background: #f9f9f9; border: 1px solid #aaaaaa; padding: 10px; margin-bottom: 1em; width: auto; display: table; font-size: 16.15px; color: #383838; font-family: sans-serif;"></div>
<h2 style="box-sizing: border-box; color: #0c0c0c; width: 785px; margin-top: 0px; margin-bottom: 0.5em; text-rendering: optimizespeed; font-size: 1.6em; line-height: 1.3; font-family: sans-serif; background-color: #ffffff; text-align: justify;"><span id="Thoi_trang_8211_Mot_dien_mao_be_ngoai_chin_chu" style="box-sizing: border-box; -webkit-box-decoration-break: clone;"><span style="box-sizing: border-box; font-weight: 400;">Thời trang &ndash; Một diện mạo bề ngo&agrave;i chỉn chu</span></span></h2>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Chắc chắn &yacute; nghĩa đầu ti&ecirc;n của thời trang đối với con người đ&oacute; ch&iacute;nh l&agrave; gi&uacute;p t&ocirc;n l&ecirc;n diện mạo bề ngo&agrave;i của người mặc. Mỗi m&agrave;u sắc, họa tiết, kiểu d&aacute;ng, chất liệu vải,&hellip; kh&aacute;c nhau sẽ mang đến cho Qu&yacute; c&ocirc; sự lựa chọn ho&agrave;n hảo với diện mạo ấn tượng nhất. &ldquo;Người đẹp v&igrave; lụa&rdquo; cũng ch&iacute;nh l&agrave; v&igrave; thế.</span></p>
<figure id="attachment_9452" class="wp-caption aligncenter" style="box-sizing: border-box; display: block; margin-top: 0px; margin-bottom: 2em; clear: both; max-width: 100%; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; width: 800px;" aria-describedby="caption-attachment-9452"><img class="size-full wp-image-9452" style="box-sizing: border-box; border-style: none; max-width: 100%; height: auto; display: inline-block; vertical-align: middle; transition: opacity 0.5s linear 0.2s; opacity: 1;" src="https://cdn.shortpixel.ai/spai2/w_981+q_lossless+ret_img+to_webp/https://zofal.vn/wp-content/uploads/2021/07/vai-tro-thoi-trang-260621-2.jpg" sizes="(max-width: 800px) 100vw, 800px" alt="Thời trang - Một diện mạo bề ngo&agrave;i chỉn chu" width="800" height="397" data-spai="1" data-spai-upd="785" />
<figcaption id="caption-attachment-9452" class="wp-caption-text" style="box-sizing: border-box; padding: 0.4em; font-size: 0.9em; background: rgba(0, 0, 0, 0.05); font-style: italic;">H&igrave;nh ảnh: Thời trang &ndash; Một diện mạo bề ngo&agrave;i chỉn chu</figcaption>
</figure>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Du bạn muốn trở th&agrave;nh Qu&yacute; c&ocirc; thanh lịch, sang trọng hay c&ocirc; n&agrave;ng duy&ecirc;n d&aacute;ng, nữ t&iacute;nh cho đến những c&ocirc; g&aacute;i mạnh mẽ, c&aacute; t&iacute;nh,&hellip;. th&igrave; thời trang ch&iacute;nh l&agrave; c&aacute;ch để bạn c&oacute; thể mang đến cho c&ocirc; n&agrave;ng bề ngo&agrave;i ấn tượng nhất.</span></p>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Đ&oacute; cũng ch&iacute;nh l&agrave; l&yacute; do tại sao mỗi thiết kế trang phục lu&ocirc;n được &ldquo;ưu &aacute;i&rdquo; để mang đến những thiết kế trang phục ng&agrave;y trở th&agrave;nh &ldquo;người cộng sự&rdquo; để c&aacute;c Qu&yacute; c&ocirc; tự tin, tỏa s&aacute;ng nhất với bề ngo&agrave;i của m&igrave;nh.</span></p>
<h2 style="box-sizing: border-box; color: #0c0c0c; width: 785px; margin-top: 0px; margin-bottom: 0.5em; text-rendering: optimizespeed; font-size: 1.6em; line-height: 1.3; font-family: sans-serif; background-color: #ffffff; text-align: justify;"><span id="Thoi_trang_8211_Ngon_ngu_chan_thuc_nhat_cua_nguoi_mac" style="box-sizing: border-box; -webkit-box-decoration-break: clone;"><span style="box-sizing: border-box; font-weight: 400;">Thời trang &ndash; Ng&ocirc;n ngữ ch&acirc;n thực nhất của người mặc</span></span></h2>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box; font-weight: bolder;"><em style="box-sizing: border-box;">&ldquo;Don&rsquo;t be into trends. Don&rsquo;t make fashion own you, but you decide what you are, what you want to express by the way you dress and the way to live.&rdquo;&nbsp;</em></span><span style="box-sizing: border-box;">&mdash;Gianni Versace</span></p>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Một trong những l&yacute; do khiến thời trang trở th&agrave;nh một phần tất yếu của cuộc sống bởi đ&acirc;y ch&iacute;nh l&agrave; lựa chọn h&agrave;ng đầu để ch&uacute;ng ta thể hiện ng&ocirc;n ngữ ri&ecirc;ng của ch&iacute;nh m&igrave;nh. Cũng như con người, mỗi thiết kế, mỗi phụ kiện hay mỗi phần của thời trang đều mang những c&aacute; t&iacute;nh ri&ecirc;ng, c&acirc;u chuyện v&agrave; một &yacute; nghĩa ri&ecirc;ng. Do đ&oacute;, để n&oacute;i l&ecirc;n tiếng n&oacute;i ri&ecirc;ng của bản th&acirc;n, nhiều người lựa chọn cho m&igrave;nh thời trang như một c&aacute;ch thể hiện.</span></p>
<figure id="attachment_9451" class="wp-caption aligncenter" style="box-sizing: border-box; display: block; margin-top: 0px; margin-bottom: 2em; clear: both; max-width: 100%; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; width: 800px;" aria-describedby="caption-attachment-9451"><img class="size-full wp-image-9451" style="box-sizing: border-box; border-style: none; max-width: 100%; height: auto; display: inline-block; vertical-align: middle; transition: opacity 0.5s linear 0.2s; opacity: 1;" src="https://cdn.shortpixel.ai/spai2/w_981+q_lossless+ret_img+to_webp/https://zofal.vn/wp-content/uploads/2021/07/vai-tro-thoi-trang-260621-1.jpg" sizes="(max-width: 800px) 100vw, 800px" alt="Thời trang - Ng&ocirc;n ngữ ch&acirc;n thực nhất của người mặc" width="800" height="596" data-spai="1" data-spai-upd="785" />
<figcaption id="caption-attachment-9451" class="wp-caption-text" style="box-sizing: border-box; padding: 0.4em; font-size: 0.9em; background: rgba(0, 0, 0, 0.05); font-style: italic;">H&igrave;nh ảnh: Thời trang &ndash; Ng&ocirc;n ngữ ch&acirc;n thực nhất của người mặc</figcaption>
</figure>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Do đ&oacute;, thời trang ng&agrave;y nay kh&ocirc;ng chỉ với mục đ&iacute;ch đơn giản l&agrave; &ldquo;mặc&rdquo;, m&agrave; n&oacute; c&ograve;n thể hiện được t&iacute;nh c&aacute;ch cũng như lối sống của người mặc một c&aacute;ch ch&acirc;n thực nhất. Thời trang cho ta thấy được c&aacute; t&iacute;nh, phong c&aacute;ch của mỗi người qua c&aacute;ch m&agrave; họ lựa chọn kiểu d&aacute;ng trang phục cũng như c&aacute;ch phối đồ. D&ugrave; rằng, họ c&oacute; đang &yacute; thức được điều n&agrave;y hay kh&ocirc;ng.</span></p>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">V&igrave; vậy, người phụ nữ hiện đại nhất định kh&ocirc;ng qu&ecirc;n cho m&igrave;nh những outfit ph&ugrave; hợp để c&oacute; thể khẳng định bản th&acirc;n m&igrave;nh r&otilde; r&agrave;ng nhất.</span></p>
<h2 style="box-sizing: border-box; color: #0c0c0c; width: 785px; margin-top: 0px; margin-bottom: 0.5em; text-rendering: optimizespeed; font-size: 1.6em; line-height: 1.3; font-family: sans-serif; background-color: #ffffff; text-align: justify;"><span id="Thoi_trang_8211_Su_ton_trong_doi_voi_ban_than_va_nguoi_khac" style="box-sizing: border-box; -webkit-box-decoration-break: clone;"><span style="box-sizing: border-box; font-weight: 400;">Thời trang &ndash; Sự t&ocirc;n trọng đối với bản th&acirc;n v&agrave; người kh&aacute;c</span></span></h2>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box; font-weight: bolder;"><em style="box-sizing: border-box;">&ldquo;What you wear is how you present yourself to the world, especially today, when human contact is so quick. Fashion is instant language.&rdquo; &mdash;Miuccia Prada</em></span></p>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Đ&uacute;ng như trong thời đời ph&aacute;t triển hiện nay, sự kết nối giữa người với người diễn ra nhanh ch&oacute;ng hơn bao giờ hết. V&igrave; vậy, sự chuẩn bị chỉn chu trong từng chi tiết sẽ gi&uacute;p bạn ghi điểm nhất đối với người xung quanh, mang đến ấn tượng tốt.</span></p>
<figure id="attachment_9454" class="wp-caption aligncenter" style="box-sizing: border-box; display: block; margin-top: 0px; margin-bottom: 2em; clear: both; max-width: 100%; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; width: 800px;" aria-describedby="caption-attachment-9454"><img class="size-full wp-image-9454" style="box-sizing: border-box; border-style: none; max-width: 100%; height: auto; display: inline-block; vertical-align: middle; transition: opacity 0.5s linear 0.2s; opacity: 1;" src="https://cdn.shortpixel.ai/spai2/w_981+q_lossless+ret_img+to_webp/https://zofal.vn/wp-content/uploads/2021/07/vai-tro-thoi-trang-260621-4.jpg" sizes="(max-width: 800px) 100vw, 800px" alt="Thời trang - Sự t&ocirc;n trọng đối với bản th&acirc;n v&agrave; người kh&aacute;c" width="800" height="533" data-spai="1" data-spai-upd="785" />
<figcaption id="caption-attachment-9454" class="wp-caption-text" style="box-sizing: border-box; padding: 0.4em; font-size: 0.9em; background: rgba(0, 0, 0, 0.05); font-style: italic;">H&igrave;nh ảnh: Thời trang &ndash; Sự t&ocirc;n trọng đối với bản th&acirc;n v&agrave; người kh&aacute;c</figcaption>
</figure>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Nhiều quan điểm chỉ ra, ch&uacute;ng ta &ldquo;mặc đẹp&rdquo; kh&ocirc;ng phải v&igrave; bất kỳ ai m&agrave; v&igrave; ch&iacute;nh ch&uacute;ng ta. Điều n&agrave;y ho&agrave;n đ&uacute;ng! V&igrave; khi tạo cho ch&iacute;nh m&igrave;nh c&aacute;ch thể hiện ra b&ecirc;n ngo&agrave;i tốt nhất th&igrave; cho thấy &ldquo;bạn y&ecirc;u thương bản th&acirc;n v&agrave; t&ocirc;n trọng m&igrave;nh&rdquo;. Đ&acirc;y cũng ch&iacute;nh l&agrave; c&aacute;ch tạo cho người đối diện sự tr&acirc;n trọng của bạn đối với họ. Đ&oacute; l&agrave; minh chứng rằng bạn t&ocirc;n trọng những người xung quanh, lu&ocirc;n c&oacute; sự tỉ mỉ tr&acirc;n trọng.</span></p>
<h2 style="box-sizing: border-box; color: #0c0c0c; width: 785px; margin-top: 0px; margin-bottom: 0.5em; text-rendering: optimizespeed; font-size: 1.6em; line-height: 1.3; font-family: sans-serif; background-color: #ffffff; text-align: justify;"><span id="Thoi_trang_giup_ban_tu_tin" style="box-sizing: border-box; -webkit-box-decoration-break: clone;"><span style="box-sizing: border-box; font-weight: 400;">Thời trang gi&uacute;p bạn tự tin</span></span></h2>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Mỗi người sẽ c&oacute; những đặc điểm kh&aacute;c nhau, c&oacute; điểm mạnh v&agrave; những điểm yếu. Để c&oacute; thể t&ocirc;n l&ecirc;n được điểm mạnh v&agrave; hạn chế được những điểm chưa tốt của bản th&acirc;n m&igrave;nh th&igrave; chắc chắn phải nhắc đến vai tr&ograve; của thời trang.</span></p>
<figure id="attachment_9455" class="wp-caption aligncenter" style="box-sizing: border-box; display: block; margin-top: 0px; margin-bottom: 2em; clear: both; max-width: 100%; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; width: 800px;" aria-describedby="caption-attachment-9455"><img class="size-full wp-image-9455" style="box-sizing: border-box; border-style: none; max-width: 100%; height: auto; display: inline-block; vertical-align: middle; transition: opacity 0.5s linear 0.2s; opacity: 1;" src="https://cdn.shortpixel.ai/spai2/w_981+q_lossless+ret_img+to_webp/https://zofal.vn/wp-content/uploads/2021/07/vai-tro-thoi-trang-260621-5.jpg" sizes="(max-width: 800px) 100vw, 800px" alt="Thời trang tiếng n&oacute;i của sự tự tin nhất" width="800" height="1200" data-spai="1" data-spai-upd="785" />
<figcaption id="caption-attachment-9455" class="wp-caption-text" style="box-sizing: border-box; padding: 0.4em; font-size: 0.9em; background: rgba(0, 0, 0, 0.05); font-style: italic;">H&igrave;nh ảnh: Thời trang tiếng n&oacute;i của sự tự tin nhất</figcaption>
</figure>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Chẳng phải v&igrave; vậy m&agrave; nhiều c&ocirc; n&agrave;ng c&oacute; chiều cao &ldquo;hơi nấm l&ugrave;n&rdquo; lại lựa mang lại ấn tượng với phong c&aacute;ch thời trang cực xịn, tạo thu h&uacute;t. Đừng bỏ qua items như quần short, &aacute;o croptop, ch&acirc;n v&aacute;y chữ A,&hellip; để n&agrave;ng c&oacute; thể &ldquo;hack d&aacute;ng&rdquo; hiệu quả.&nbsp;</span></p>
<p style="box-sizing: border-box; margin-bottom: 1.3em; margin-top: 0px; color: #383838; font-family: sans-serif; font-size: 17px; background-color: #ffffff; text-align: justify;"><span style="box-sizing: border-box;">Khi bạn hiểu r&otilde; được điểm mạnh, điểm yếu của m&igrave;nh cũng như hiểu được thời trang th&igrave; chắc chắn bạn sẽ trở th&agrave;nh c&ocirc; n&agrave;ng trẻ trung.</span></p>',
N'',N'HBV6382566173283208321.jpg',N'Tin tuc','2023-07-22 22:28:52.833',5000,1,1)


    SET @counter = @counter + 1
END

