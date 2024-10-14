﻿USE master
IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME = 'QUANLYBANHANG')
BEGIN
	ALTER DATABASE QUANLYBANHANG SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE QUANLYBANHANG;
END
GO
CREATE DATABASE QUANLYBANHANG
GO
USE QUANLYBANHANG
GO
CREATE TABLE KHACHHANG(
	MAKH CHAR (4) NOT NULL UNIQUE,
	HOTEN VARCHAR (40),
	DCHI VARCHAR(50),
	SODT VARCHAR(20),
	NGSINH SMALLDATETIME,
	DOANHSO MONEY,
	NGDK SMALLDATETIME,
	CONSTRAINT PK_KHACHHANG PRIMARY KEY (MAKH)
)
GO
CREATE TABLE NHANVIEN(
	MANV CHAR(4) NOT NULL UNIQUE,
	HOTEN VARCHAR(40) NOT NULL,
	NGVL SMALLDATETIME NOT NULL,
	SODT VARCHAR(20) NOT NULL,
	CONSTRAINT PK_NHANVIEN PRIMARY KEY (MANV)
)
GO
CREATE TABLE SANPHAM(
	MASP CHAR(4) NOT NULL UNIQUE,
	TENSP VARCHAR(40) NOT NULL,
	DVT VARCHAR(20) NOT NULL,
	NUOCSX VARCHAR(40) NOT NULL,
	GIABAN MONEY NOT NULL,
	CONSTRAINT PK_SANPHAM PRIMARY KEY (MASP)
)
GO
CREATE TABLE HOADON(
	SOHD INT NOT NULL UNIQUE,
	NGHD SMALLDATETIME NOT NULL,
	MAKH CHAR(4),
	MANV CHAR(4) NOT NULL,
	TRIGIA MONEY NOT NULL,
	CONSTRAINT FK_HDKH FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
	CONSTRAINT FK_HDNV FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV),
	CONSTRAINT PK_HOADON PRIMARY KEY (SOHD)
)
GO
CREATE TABLE CTHD(
	SOHD INT NOT NULL,
	MASP CHAR(4) NOT NULL,
	SL INT NOT NULL,
	CONSTRAINT FK_CTHOADON FOREIGN KEY (SOHD) REFERENCES HOADON(SOHD),
	CONSTRAINT FK_CTSANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP),
	CONSTRAINT PK_CTHD PRIMARY KEY (SOHD,MASP)
)
GO
--PHAN 1:
--CAU 2:
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20);
--CAU 3:
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT;
--CAU 4:
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100);
--CAU 5:
ALTER TABLE SANPHAM DROP COLUMN GHICHU;
--CAU 6:
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(20);
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_LOAIKH CHECK(LOAIKH IN ('Nam', 'Nu'));
--số -> chuỗi : ok, chuỗi -> số : NOOOOO
--SMALLDATETIME/ DATETIME -> '20210420' ( đặt ngày vào dấu nháy chuỗi '')
--CAU 7:
ALTER TABLE SANPHAM ADD CONSTRAINT CK_DVT CHECK (DVT IN ('Cay','Hop', 'Cai', 'Quyen', 'Chuc'));
--CAU 8:
ALTER TABLE SANPHAM ADD CONSTRAINT CK_GIA CHECK (GIABAN >= 500);
--CAU 9:
ALTER TABLE HOADON ADD CONSTRAINT CK_MUAITNHAT1 CHECK (TRIGIA > 0);
--CAU 10:
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_NGAY CHECK (NGSINH < NGDK);
--BUOI2:
--CAU 11:
ALTER TABLE HOADON ADD CONSTRAINT CK_NGAYHD CHECK (NGHD >= KHACHHANG.NGDK); -- CHECK() KHÔNG ĐƯỢC DÙNG KHI THAM CHIẾU ĐẾN BẢNG KHÁC
--PHAN 2:
--CAU 1:
Set dateformat dmy
go
ALTER TABLE KHACHHANG DROP CONSTRAINT CK_LOAIKH
ALTER TABLE KHACHHANG DROP COLUMN LOAIKH
insert into KHACHHANG values('KH01','Nguyen Van A','731 Tran Hung Dao, Q5, TpHCM','08823451','22/10/1960',13060000,'22/07/2006')
insert into KHACHHANG values('KH02','Tran Ngoc Han','23/5 Nguyen Trai, Q5, TpHCM','0908256478','3/4/1974',280000,'30/07/2006')
insert into KHACHHANG values('KH03','Tran Ngoc Linh','45 Nguyen Canh Chan, Q1, TpHCM','0938776266','12/6/1980',3860000,'05/08/2006')
insert into KHACHHANG values('KH04','Tran Minh Long','50/34 Le Dai Hanh, Q10, TpHCM','0917325476','9/3/1965',250000,'02/10/2006')
insert into KHACHHANG values('KH05','Le Nhat Minh','34 Truong Dinh, Q3, TpHCM','08246108','10/3/1950',21000,'28/10/2006')
insert into KHACHHANG values('KH06','Le Hoai Thuong','227 Nguyen Van Cu, Q5, TpHCM','08631738','31/12/1981',915000,'24/11/2006')
insert into KHACHHANG values('KH07','Nguyen Manh Tam','32/3 Tran Binh Trong, Q5, TpHCM','0916783565','6/4/1971',12500,'01/12/2006')
insert into KHACHHANG values('KH08','Phan Thi Thanh Tam','45/2 An Duong Vuong, Q5, TpHCM','0938435756','10/1/1971',365000,'13/12/2006')
insert into KHACHHANG values('KH09','Le Ha Vinh','873 Cach Mang Thang Tam, QTB, TpHCM','08654763','3/9/1979',70000,'14/01/2007')
insert into KHACHHANG values('KH10','Ha Duy Lap','34/34B Nguyen Trai, Q1, TpHCM','08768904','2/5/1983',67500,'16/01/2007')
ALTER TABLE KHACHHANG ADD LOAIKH VARCHAR(20)
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_LOAIKH CHECK(LOAIKH IN ('Nam', 'Nu'));

insert into NHANVIEN(MANV, HOTEN, SODT, NGVL) values('NV01','Nguyen Nhu Nhut','0927345678','13/4/2006')
insert into NHANVIEN(MANV, HOTEN, SODT, NGVL) values('NV02','Le Thi Phi Yen','0987567390','21/4/2006')
insert into NHANVIEN(MANV, HOTEN, SODT, NGVL) values('NV03','Nguyen Van B','0997047382','27/4/2006')
insert into NHANVIEN(MANV, HOTEN, SODT, NGVL) values('NV04','Ngo Thanh Tuan','0913758498','24/6/2006')
insert into NHANVIEN(MANV, HOTEN, SODT, NGVL) values('NV05','Nguyen Thi Truc Thanh','0918590387','20/7/2006')

insert into SANPHAM values('BC01','But chi','cay','Singapore',3000)
insert into SANPHAM values('BC02','But chi','cay','Singapore',5000)
insert into SANPHAM values('BC03','But chi','cay','Viet Nam',3500)
insert into SANPHAM values('BC04','But chi','hop','Viet Nam',30000)
insert into SANPHAM values('BB01','But bi','cay','Viet Nam',5000)
insert into SANPHAM values('BB02','But bi','cay','Trung Quoc',7000)
insert into SANPHAM values('BB03','But bi','hop','Thai Lan',100000)
insert into SANPHAM values('TV01','Tap 100 trang giay mong','quyen','Trung Quoc',2500)
insert into SANPHAM values('TV02','Tap 200 trang giay mong','quyen','Trung Quoc',4500)
insert into SANPHAM values('TV03','Tap 100 trang giay tot','quyen','Viet Nam',3000)
insert into SANPHAM values('TV04','Tap 200 trang giay tot','quyen','Viet Nam',5500)
insert into SANPHAM values('TV05','Tap 100 trang','chuc','Viet Nam',23000)
insert into SANPHAM values('TV06','Tap 200 trang','chuc','Viet Nam',53000)
insert into SANPHAM values('TV07','Tap 100 trang','chuc','Trung Quoc',34000)
insert into SANPHAM values('ST01','So tay 500 trang','quyen','Trung Quoc',40000)
insert into SANPHAM values('ST02','So tay loai 1','quyen','Viet Nam',55000)
insert into SANPHAM values('ST03','So tay loai 2','quyen','Viet Nam',51000)
insert into SANPHAM values('ST04','So tay','quyen','Thai Lan',55000)
insert into SANPHAM values('ST05','So tay mong','quyen','Thai Lan',20000)
insert into SANPHAM values('ST06','Phan viet bang','hop','Viet Nam',5000)
insert into SANPHAM values('ST07','Phan viet bang khong bui','hop','Viet Nam',7000)
insert into SANPHAM values('ST08','Bong bang','cai','Viet Nam',1000)
insert into SANPHAM values('ST09','But long','cay','Viet Nam',5000)
insert into SANPHAM values('ST10','But long mau','cay','Trung Quoc',7000)

insert into HOADON values(1001,'23/07/2006','KH01','NV01',320000)
insert into HOADON values(1002,'12/8/2006','KH01','NV02',840000)
insert into HOADON values(1003,'23/08/2006','KH02','NV01',100000)
insert into HOADON values(1004,'1/9/2006','KH02','NV01',180000)
insert into HOADON values(1005,'20/10/2006','KH01','NV02',3800000)
insert into HOADON values(1006,'16/10/2006','KH01','NV03',2430000)
insert into HOADON values(1007,'28/10/2006','KH03','NV03',510000)
insert into HOADON values(1008,'28/10/2006','KH01','NV03',440000)
insert into HOADON values(1009,'28/10/2006','KH03','NV04',200000)
insert into HOADON values(1010,'1/11/2006','KH01','NV01',5200000)
insert into HOADON values(1011,'4/11/2006','KH04','NV03',250000)
insert into HOADON values(1012,'30/11/2006','KH05','NV03',21000)
insert into HOADON values(1013,'12/12/2006','KH06','NV01',5000)
insert into HOADON values(1014,'31/12/2006','KH03','NV02',3150000)
insert into HOADON values(1015,'1/1/2007','KH06','NV01',910000)
insert into HOADON values(1016,'1/1/2007','KH07','NV02',12500)
insert into HOADON values(1017,'2/1/2007','KH08','NV03',35000)
insert into HOADON values(1018,'13/01/2007','KH08','NV03',330000)
insert into HOADON values(1019,'13/01/2007','KH01','NV03',30000)
insert into HOADON values(1020,'14/01/2007','KH09','NV04',70000)
insert into HOADON values(1021,'16/01/2007','KH10','NV03',67500)
insert into HOADON values(1022,'16/01/2007',Null,'NV03',7000)
insert into HOADON values(1023,'17/01/2007',Null,'NV01',330000)

insert into CTHD values(1001,'TV02',10)
insert into CTHD values(1001,'ST01',5)
insert into CTHD values(1001,'BC01',5)
insert into CTHD values(1001,'BC02',10)
insert into CTHD values(1001,'ST08',10)
insert into CTHD values(1002,'BC04',20)
insert into CTHD values(1002,'BB01',20)
insert into CTHD values(1002,'BB02',20)
insert into CTHD values(1003,'BB03',10)
insert into CTHD values(1004,'TV01',20)
insert into CTHD values(1004,'TV02',10)
insert into CTHD values(1004,'TV03',10)
insert into CTHD values(1004,'TV04',10)
insert into CTHD values(1005,'TV05',50)
insert into CTHD values(1005,'TV06',50)
insert into CTHD values(1006,'TV07',20)
insert into CTHD values(1006,'ST01',30)
insert into CTHD values(1006,'ST02',10)
insert into CTHD values(1007,'ST03',10)
insert into CTHD values(1008,'ST04',8)
insert into CTHD values(1009,'ST05',10)
insert into CTHD values(1010,'TV07',50)
insert into CTHD values(1010,'ST07',50)
insert into CTHD values(1010,'ST08',100)
insert into CTHD values(1010,'ST04',50)
insert into CTHD values(1010,'TV03',100)
insert into CTHD values(1011,'ST06',50)
insert into CTHD values(1012,'ST07',3)
insert into CTHD values(1013,'ST08',5)
insert into CTHD values(1014,'BC02',80)
insert into CTHD values(1014,'BB02',100)
insert into CTHD values(1014,'BC04',60)
insert into CTHD values(1014,'BB01',50)
insert into CTHD values(1015,'BB02',30)
insert into CTHD values(1015,'BB03',7)
insert into CTHD values(1016,'TV01',5)
insert into CTHD values(1017,'TV02',1)
insert into CTHD values(1017,'TV03',1)
insert into CTHD values(1017,'TV04',5)
insert into CTHD values(1018,'ST04',6)
insert into CTHD values(1019,'ST05',1)
insert into CTHD values(1019,'ST06',2)
insert into CTHD values(1020,'ST07',10)
insert into CTHD values(1021,'ST08',5)
insert into CTHD values(1021,'TV01',7)
insert into CTHD values(1021,'TV02',10)
insert into CTHD values(1022,'ST07',1)
insert into CTHD values(1023,'ST04',6)


--CAU 2:
DROP TABLE SANPHAM1
DROP TABLE KHACHHANG1
SELECT * INTO SANPHAM1 FROM SANPHAM;
SELECT * INTO KHACHHANG1 FROM KHACHHANG;
--CAU 3:
UPDATE SANPHAM1 SET GIABAN = GIABAN*1.05 WHERE NUOCSX ='Thai Lan';
--CAU 4:
UPDATE SANPHAM1 SET GIABAN = GIABAN*0.95 WHERE (NUOCSX = 'Trung Quoc') AND (GIABAN <= 10000)

--PHAN 3:
--CAU 1:
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
--CAU 2:
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT IN ('cay', 'quyen')
--CAU 3:
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%01'
--CAU 4:
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIABAN BETWEEN 30000 AND 40000
--CAU 5:
SELECT MASP, TENSP
FROM SANPHAM
WHERE (NUOCSX = 'Trung Quoc' OR NUOCSX = 'Thai Lan') AND GIABAN BETWEEN 30000 AND 40000
--CAU 6:
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD = '1/1/2007'OR NGHD = '2/1/2007'
--CAU 7:
SELECT SOHD, NGHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007 -- NGHD BETWEEN '1/1/2007' AND '31/1/2007' HOẶC DÙNG >=, <=
ORDER BY NGHD ASC, TRIGIA DESC
--CAU 8:
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE MAKH IN (SELECT MAKH FROM HOADON WHERE NGHD = '1/1/2007')
--SỬA:
SELECT KHACHHANG.MAKH, HOTEN -- LIỆT KÊ TẤT CẢ THUỘC TÍNH : TABLE_NAME.*
FROM KHACHHANG
INNER JOIN HOADON ON KHACHHANG.MAKH = HOADON.MAKH -- ĐK THỰC HIỆN PHÉP KẾT: THUỘC TÍNH ĐIỀU KIỆN PHẢI LÀ KHÓA CHÍNH HOẶC KHÓA NGOẠI CỦA 2 BẢNG, NẾU KO THÌ LÀM PHÉP TÍCH
WHERE NGHD = '1/1/2007'
--HOẶC
SELECT KHACHHANG.MAKH, HOTEN
FROM KHACHHANG, HOADON
WHERE NGHD = '1/1/2007' AND KHACHHANG.MAKH = HOADON.MAKH
--CAU 9:
SELECT SOHD, TRIGIA
FROM HOADON
INNER JOIN NHANVIEN ON HOADON.MANV = NHANVIEN.MANV
WHERE HOTEN = 'Nguyen Van B' AND NGHD = '28/10/2006'
--CAU 10:
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM
INNER JOIN CTHD ON SANPHAM.MASP = CTHD.MASP
INNER JOIN HOADON ON HOADON.SOHD = CTHD.SOHD
INNER JOIN KHACHHANG ON KHACHHANG.MAKH = HOADON.MAKH
WHERE HOTEN = 'Nguyen Van A' AND MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
--CAU 11:
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01' OR MASP = 'BB02'
--CAU 12:
SELECT DISTINCT SOHD -- SOHD CÓ THỂ TRÙNG NHAU
FROM CTHD
WHERE (MASP = 'BB01' OR MASP = 'BB02') AND SL BETWEEN 10 AND 20
--CAU 13:
SELECT DISTINCT SOHD
FROM CTHD
WHERE (MASP = 'BB01') AND (SL BETWEEN 10 AND 20) AND (SOHD IN (SELECT DISTINCT SOHD FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20)) -- CÓ THỂ LỌC ĐK KHÁC = NOT IN (PHÉP TRỪ)
--PHÉP GIAO: INTERSECT, AND... IN(), AND EXISTS

--1/DÙNG INTERSECT:
SELECT DISTINCT SOHD FROM CTHD WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20
INTERSECT
SELECT DISTINCT SOHD FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20

--2/IN (DÙNG SUBQUERY)

--3/EXISTS + MỆNH ĐỀ = (PHÉP CHIA)
SELECT DISTINCT SOHD
FROM CTHD C1
WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20 AND EXISTS (SELECT DISTINCT * FROM CTHD WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20)

--4/LỒNG NHAU
SELECT DISTINCT C1.SOHD
FROM CTHD C1, CTHD C2
WHERE C1.MASP = 'BB01' AND C1.SL BETWEEN 10 AND 20
		AND C2.MASP = 'BB02' AND C2.SL BETWEEN 10 AND 20
		AND C1.SOHD = C2.SOHD
--PHÉP HỘI: UNION/OR...IN()/ OR EXISTS
--PHÉP TRỪ
--CAU 14: KHÔNG ĐƯỢC DÙNG INNER JOIN (KẾT BẰNG) VÌ SẼ LOẠI NHỮNG SP DO TQ SX NHƯNG CHƯA CÓ NG MUA)
--DÙNG IN()
SELECT DISTINCT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' OR MASP IN (SELECT DISTINCT MASP FROM CTHD INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD WHERE NGHD = '1/1/2007')
--CAU 15:
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (SELECT MASP FROM CTHD)
--cách 2: dùng not exists
SELECT MASP, TENSP
FROM SANPHAM
WHERE NOT EXISTS (SELECT * FROM CTHD WHERE CTHD.MASP = SANPHAM.MASP)
--CAU 16:
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (SELECT DISTINCT MASP FROM CTHD INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD WHERE YEAR(NGHD) = 2006)
--CAU 17:
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND MASP NOT IN (SELECT DISTINCT CTHD.MASP FROM CTHD INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD INNER JOIN SANPHAM ON SANPHAM.MASP = CTHD.MASP WHERE YEAR(NGHD) = 2006 AND NUOCSX = 'Trung Quoc' )