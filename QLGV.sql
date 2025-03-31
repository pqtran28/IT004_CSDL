--USE master
--IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'QUANLYGIAOVU')
--BEGIN
--	ALTER DATABASE QUANLYGIAOVU SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--	DROP DATABASE QUANLYGIAOVU;
--END
--GO
CREATE DATABASE QUANLYGIAOVU

USE QUANLYGIAOVU;

CREATE TABLE GIAOVIEN(
	MAGV CHAR(4) NOT NULL,
	HOTEN VARCHAR(40),
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GIOITINH VARCHAR(3),
	NGSINH SMALLDATETIME,
	NGVL SMALLDATETIME,
	HESO NUMERIC(4,2),
	MUCLUONG MONEY,
	MAKHOA VARCHAR(4),
	CONSTRAINT PK_GIAOVIEN PRIMARY KEY(MAGV)
)
GO

CREATE TABLE KHOA(
	MAKHOA VARCHAR(4) NOT NULL,
	TENKHOA VARCHAR(4),
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4),
	CONSTRAINT FK_TRGKHOA FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV),
	CONSTRAINT PK_MAKHOA PRIMARY KEY (MAKHOA)
)
GO

ALTER TABLE GIAOVIEN ADD COSNTRAINT FK_GVKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA);

CREATE TABLE MONHOC(
	MAMH VARCHAR(10) NOT NULL,
	TENMH VARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4),
	CONSTRAINT FK_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA),
	CONSTRAINT PK_MAMH PRIMARY KEY (MAMH)
)
GO

CREATE TABLE DIEUKIEN(
	MAMH VARCHAR(10) NOT NULL,
	MAMH_TRUOC VARCHAR (10),
	CONSTRAINT FK_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	CONSTRAINT FK_MAMH_TRUOC FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY (MAMH, MAMH_TRUOC)
)
GO

CREATE TABLE HOCVIEN(
	MAHV CHAR(5) NOT NULL,
	HO VARCHAR (40),
	TEN VARCHAR(10),
	NGSINH SMALLDATETIME,
	GIOITINH VARCHAR(3),
	NOISINH VARCHAR (40),
	MALOP CHAR (3),
	CONSTRAINT PK_HOCVIEN PRIMARY KEY (MAHV)
)
GO

CREATE TABLE LOP(
	MALOP CHAR(3) NOT NULL,
	TENLOP VARCHAR(40),
	TRGLOP CHAR(5),
	SISO TINYINT,
	MAGVCN CHAR(4),
	CONSTRAINT FK_GVCN FOREIGN KEY (MAGVCN) REFERENCES GIAOVIEN(MAGV),
	CONSTRAINT FK_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV),
	CONSTRAINT PK_LOP PRIMARY KEY (MALOP)
)
GO

ALTER TABLE HOCVIEN ADD CONSTRAINT FK_MALOP FOREIGN KEY (MALOP) REFERENCES LOP (MALOP);

CREATE TABLE GIANGDAY(
	MALOP CHAR(3) NOT NULL,
	MAMH VARCHAR(10) NOT NULL,
	MAGV CHAR(4),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME,
	DENNGAY SMALLDATETIME,
	CONSTRAINT FK_MLOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
	CONSTRAINT FK_MMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	CONSTRAINT FK_MAGV FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV),
	CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP, MAMH)
)
GO

CREATE TABLE KETQUATHI(
	MAHV CHAR(5) NOT NULL,
	MAMH VARCHAR(10) NOT NULL,
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4,2),
	KQUA VARCHAR(10),
	CONSTRAINT FK_HV FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
	CONSTRAINT FK_MH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV, MAMH, LANTHI)
)
GO
--PHAN 1:
-- CAU 1:
ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(100), DIEMTB FLOAT, XEPLOAI VARCHAR(10);
GO
-- CAU 2:
ALTER TABLE HOCVIEN ADD CONSTRAINT CK_MAHV CHECK(MAHV LIKE '[A-Z][0-9][0-9][0-9][0-9]'); -- (????)
-- CAU 3:
ALTER TABLE HOCVIEN ADD CONSTRAINT CK_GIOITINH CHECK (GIOITINH IN ('Nam','Nu'));
-- CAU 4:
ALTER TABLE KETQUATHI ADD CONSTRAINT CK_DIEMTHI CHECK(DIEM >= 0 AND DIEM <= 10); -- (????)

--PHAN 2:
--CAU 1:
UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA);
--CAU 2:
ALTER TABLE HOCVIEN ADD DIEMTB NUMERIC(4,2);
GO
-- (????)
-- CAU 3:
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (SELECT DISTINCT MAHV FROM KETQUATHI WHERE (LANTHI = 3 AND DIEM < 5));
-- CAU 4:
UPDATE HOCVIEN
SET XEPLOAI = CASE
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB < 9 AND DIEMTB >= 8 THEN 'G'
	WHEN DIEMTB < 8 AND DIEMTB >= 6.5 THEN 'K'
	WHEN DIEMTB < 6.5 AND DIEMTB >= 5 THEN 'TB'
	ELSE 'Y'
END;
--PHAN 3:
--CAU 1:
SELECT MAHV, HO, TEN, NGSINH, MALOP
FROM HOCVIEN
WHERE MAHV IN (SELECT TRGLOP FROM LOP);
--CAU 2:
SELECT HOCVIEN.MAHV, HO, TEN, LANTHI, DIEM --ĐỂ HOCVIEN.MAHV THAY VÌ HV VÌ CẢ 2 BẢNG DỀU CÓ MAHV SQL KO BIẾT LẤY TỪ BẢNG NÀO
FROM HOCVIEN 
INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MALOP = 'K12' AND MAMH = 'CTRR'
ORDER BY HO, TEN;
--CAU 3:
SELECT HOCVIEN.MAHV, HO, TEN, TENMH
FROM HOCVIEN
INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
INNER JOIN MONHOC ON KETQUATHI.MAMH = MONHOC.MAMH
WHERE LANTHI = 1 AND KQUA = 'DAT'
--CAU 4:
SELECT HOCVIEN.MAHV, HO, TEN
FROM HOCVIEN
INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MALOP = 'K11' AND MAMH = 'CTRR' AND LANTHI = 1 AND KQUA = 'KHONG DAT'
--CAU 5:
SELECT HOCVIEN.MAHV, HO, TEN
FROM HOCVIEN
INNER JOIN KETQUATHI ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE MALOP = 'K' AND MAMH = 'CTRR'
GROUP BY HOCVIEN.MAHV, HO, TEN
HAVING COUNT(KQUA) = MAX(LANTHI)
--CAU 6:
SELECT TENMH
FROM MONHOC
INNER JOIN GIANGDAY ON MONHOC.MAMH = GIANGDAY.MAMH
INNER JOIN GIAOVIEN ON GIANGDAY.MAGV = GIAOVIEN.MAGV
WHERE HOTEN = 'Tran Tam Thanh' AND HOCKY = 1 AND NAM = 2006
--CAU 7:
SELECT MONHOC.MAMH, TENMH
FROM MONHOC
INNER JOIN GIANGDAY ON GIANGDAY.MAMH = MONHOC.MAMH
WHERE MAGV IN (SELECT MAGV FROM LOP WHERE MALOP = 'K11') AND HOCKY = 1 AND NAM = 2006
--CAU 8:
SELECT HO, TEN
FROM HOCVIEN
INNER JOIN LOP ON LOP.TRGLOP = HOCVIEN.MAHV
INNER JOIN GIANGDAY ON GIANGDAY.MALOP = LOP.MALOP
WHERE MAGV IN (SELECT MAGV FROM GIAOVIEN WHERE HOTEN = 'Nguyen To Lan ')AND MAMH IN (SELECT MAMH FROM MONHOC WHERE TENMH = 'Co So Du Lieu') AND HOCVIEN.MAHV = TRGLOP
--CAU 9:
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (SELECT MAMH_TRUOC FROM DIEUKIEN WHERE MAMH = 'CSDL')
--CAU 10:
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (SELECT MAMH FROM DIEUKIEN WHERE MAMH_TRUOC = 'CTRR')
--CAU 11:
SELECT GIAOVIEN.MAGV, HOTEN
FROM GIAOVIEN
INNER JOIN GIANGDAY ON GIANGDAY.MAGV = GIAOVIEN.MAGV
WHERE HOCKY = 1 AND NAM = 2006 AND MALOP = 'K11' AND MAMH = 'CTRR'
INTERSECT
SELECT GIAOVIEN.MAGV, HOTEN
FROM GIAOVIEN
INNER JOIN GIANGDAY ON GIANGDAY.MAGV = GIAOVIEN.MAGV
WHERE HOCKY = 1 AND NAM = 2006 AND MALOP = 'K12' AND MAMH = 'CTRR'
--CAU 12:Tìm những học viên (mã học viên, họ tên) thi 
--không đạt môn CSDL ở lần thi thứ 1 nhưng 
--chưa thi lại môn này
SELECT MAHV
FROM KETQUATHI
WHERE MAMH = 'CTRR' AND LANTHI = 1 AND KQUA = 'Khong Dat' AND MAHV NOT IN (SELECT MAHV FROM KETQUATHI WHERE MAMH = 'CTRR' AND LANTHI > 1)
--CAU 13:Tìm giáo viên (mã giáo viên, họ tên) 
--không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT MAGV FROM GIANGDAY)
--CAU 14: Tìm giáo viên (mã giáo viên, họ tên) không được phân công 
--giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách
--=> GV CHỈ DẠY NHƯNG MH KO CÓ TRONG KHOA MÌNH HOẶC GIÁO VIÊN CHƯA ĐƯỢC PHÂN CÔNG DẠY MÔN NÀO
SELECT GV.MAGV, HOTEN
FROM GIAOVIEN GV
WHERE MAGV NOT IN (SELECT MAGV FROM GIANGDAY) OR MAGV IN (SELECT MAGV FROM GIANGDAY WHERE MAMH NOT IN (SELECT MAMH FROM MONHOC WHERE MONHOC.MAKHOA != GV.MAKHOA))
--CAU 15:Tìm họ tên các học viên thuộc 
--lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat”
--hoặc thi lần thứ 2 môn CTRR được 5 điểm
SELECT MAHV, HO, TEN
FROM HOCVIEN
WHERE MALOP = 'K11' AND (MAHV IN (SELECT MAHV FROM KETQUATHI WHERE KQUA = 'Khong Dat' GROUP BY MAHV, MAMH HAVING COUNT(*) >= 3) OR MAHV IN (SELECT MAHV
FROM KETQUATHI
WHERE MAMH = 'CTRR' AND DIEM = 5))


--HỌC VIÊN THI 1 MÔN BẤT KỲ QUÁ 3 LẦN VẪN KO ĐẠT:
SELECT MAHV, MAMH, COUNT(*)
FROM KETQUATHI
WHERE KQUA = 'Khong Dat'
GROUP BY MAHV, MAMH
HAVING COUNT(*) >= 3
--HỌC VIÊN THI CTRR ĐƯỢC 5Đ
SELECT MAHV
FROM KETQUATHI
WHERE MAMH = 'CTRR' AND DIEM = 5


--CAU 16:Tìm họ tên giáo viên dạy môn CTRR cho ít nhất
--hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN
FROM GIAOVIEN
INNER JOIN (SELECT MAGV
FROM GIANGDAY
WHERE MAMH = 'CTRR'
GROUP BY MAGV, NAM, HOCKY
HAVING COUNT(MALOP) >= 2) AS BANGPC ON BANGPC.MAGV = GIAOVIEN.MAGV

--CAU 17:Danh sách học viên và điểm thi môn CSDL 
--(chỉ lấy điểm của lần thi sau cùng)
SELECT MAHV, DIEM
FROM KETQUATHI K1
WHERE MAMH = 'CSDL' AND LANTHI = (SELECT MAX(LANTHI) FROM KETQUATHI K2 WHERE MAMH = 'CSDL' AND K1.MAHV = K2.MAHV)


--CAU 18:Danh sách học viên và điểm thi môn 
--“Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT MAHV, DIEM
FROM KETQUATHI K1
WHERE MAMH = 'CSDL' AND DIEM = (SELECT MAX(DIEM) FROM KETQUATHI K2 WHERE MAMH = 'CSDL' AND K1.MAHV = K2.MAHV)
ORDER BY MAHV

--CAU 19:Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT K1.MAKHOA, K1.TENKHOA
FROM KHOA K1
WHERE K1.NGTLAP <= ALL(SELECT NGTLAP FROM KHOA K2)

--CAU 20: Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(*)
FROM GIAOVIEN
WHERE HOCHAM = 'GS' OR HOCHAM = 'PGS'

--CAU 21:Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi 
--khoa.

SELECT TENKHOA, HOCVI, COUNT(MAGV)
FROM GIAOVIEN
INNER JOIN KHOA ON KHOA.MAKHOA = GIAOVIEN.MAKHOA
WHERE HOCVI = 'CN' OR HOCVI = 'KS' OR HOCVI = 'Ths' OR HOCVI = 'TS' OR HOCVI = 'PTS'
GROUP BY TENKHOA, HOCVI
ORDER BY TENKHOA

--CAU 22: Mỗi môn học thống kê 
--số lượng học viên theo kết quả (đạt và không đạt)
SELECT K1.TENMH, DAT, KHONGDAT
FROM
(SELECT TENMH, COUNT(MAHV) AS DAT
FROM KETQUATHI JOIN MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH
WHERE KQUA = 'Dat'
GROUP BY TENMH) K1
INNER JOIN (SELECT TENMH, COUNT(MAHV) AS KHONGDAT
FROM KETQUATHI JOIN MONHOC ON MONHOC.MAMH = KETQUATHI.MAMH
WHERE KQUA = 'Khong Dat'
GROUP BY TENMH) K2 ON K1.TENMH = K2.TENMH

--CAU 23:Tìm giáo viên (mã giáo viên, họ tên) là giáo viên 
--chủ nhiệm của một lớp, đồng thời dạy cho 
--lớp đó ít nhất một môn học.
SELECT MAGVCN, HOTEN
FROM LOP L1
JOIN GIAOVIEN ON GIAOVIEN.MAGV = L1.MAGVCN
WHERE MAGVCN IN (SELECT MAGV FROM GIANGDAY WHERE L1.MALOP = GIANGDAY.MALOP)

--CAU 24:Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất
SELECT HO, TEN
FROM LOP JOIN HOCVIEN ON HOCVIEN.MAHV = LOP.TRGLOP
WHERE SISO >= ALL(SELECT SISO FROM LOP)

--CAU 25:* Tìm họ tên những LOPTRG thi không đạt quá 3 môn 
	--(mỗi môn đều thi không đạt ở tất cả các lần thi).

	---MÃ HV THI KO ĐẠT:
SELECT MAHV, MAMH
FROM KETQUATHI K1
WHERE LANTHI IN (SELECT MAX(LANTHI) FROM KETQUATHI K2 
					WHERE K1.MAHV = K2.MAHV AND K1.MAMH = K2.MAMH)
					AND KQUA = 'Khong Dat'
	--MÃ HV THI KO ĐẠT > 3 MÔN:
SELECT MAHV, COUNT(*) AS SOMON_KODAT
FROM (SELECT MAHV, MAMH
FROM KETQUATHI K1
WHERE LANTHI IN (SELECT MAX(LANTHI) FROM KETQUATHI K2 
					WHERE K1.MAHV = K2.MAHV AND K1.MAMH = K2.MAMH)
					AND KQUA = 'Khong Dat') K3
GROUP BY MAHV
HAVING COUNT(*) > 3

	--MÃ, TÊN LỚP TRƯỞNG THI KO ĐẠT >= 3 MÔN
SELECT TRGLOP, HO, TEN
FROM LOP JOIN HOCVIEN ON HOCVIEN.MAHV = LOP.TRGLOP
WHERE TRGLOP IN (SELECT MAHV
FROM (SELECT MAHV, MAMH
FROM KETQUATHI K1
WHERE LANTHI IN (SELECT MAX(LANTHI) FROM KETQUATHI K2 
					WHERE K1.MAHV = K2.MAHV AND K1.MAMH = K2.MAMH)
					AND KQUA = 'Khong Dat')K3)
--26. Tìm học viên (mã học viên, họ tên) 
--có số môn đạt điểm 9,10 nhiều nhất

SELECT MAHV,HO,TEN,SOMON 
FROM (SELECT KETQUATHI.MAHV, HO, TEN, COUNT(DISTINCT MAMH) AS SOMON
FROM KETQUATHI JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE DIEM BETWEEN 9 AND 10
GROUP BY KETQUATHI.MAHV, HO, TEN) K1
WHERE K1.SOMON >= ALL(SELECT COUNT(DISTINCT MAMH) AS SOMON
FROM KETQUATHI JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE DIEM BETWEEN 9 AND 10
GROUP BY KETQUATHI.MAHV, HO, TEN)

--27. Trong từng lớp, tìm học viên 
--(mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
--SQL yêu cầu tất cả các cột xuất hiện trong ORDER BY phải được nhóm lại trong 
--GROUP BY, trừ khi bạn áp dụng một hàm tổng hợp cho chúng.

WITH XEPHANG AS (SELECT MALOP, KETQUATHI.MAHV, HO, TEN, COUNT(DISTINCT MAMH) AS SOMON,
	RANK() OVER (PARTITION BY MALOP ORDER BY COUNT(DISTINCT MAMH)) AS RankNum
FROM KETQUATHI JOIN HOCVIEN ON HOCVIEN.MAHV = KETQUATHI.MAHV
WHERE DIEM BETWEEN 9 AND 10
GROUP BY HOCVIEN.MALOP, KETQUATHI.MAHV, HO, TEN)

SELECT LOP.MALOP, MAHV, HO, TEN, SOMON
FROM XEPHANG RIGHT JOIN LOP ON LOP.MALOP = XEPHANG.MALOP
WHERE RankNum = 1

--CAU 28: Trong từng học kỳ của từng năm, 
--mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp

SELECT NAM, HOCKY, MAGV, COUNT( DISTINCT MALOP) AS SOLOP, COUNT(DISTINCT  MAMH) AS SOMON_GD
FROM GIANGDAY
GROUP BY NAM, HOCKY, MAGV

--CAU 29:Trong từng học kỳ của từng năm, tìm giáo viên 
--(mã giáo viên, họ tên) giảng dạy nhiều nhất.

WITH XEPHANG_GV AS
(SELECT NAM, HOCKY, MAGV, COUNT( DISTINCT MALOP) AS SOLOP,
		RANK() OVER (PARTITION BY NAM, HOCKY ORDER BY COUNT( DISTINCT MALOP) DESC) AS RankNumGV
FROM GIANGDAY
GROUP BY NAM, HOCKY, MAGV)

SELECT NAM, HOCKY, XEPHANG_GV.MAGV, HOTEN, SOLOP
FROM XEPHANG_GV JOIN GIAOVIEN ON GIAOVIEN.MAGV = XEPHANG_GV.MAGV
WHERE RankNumGV = 1

--cau 30:Tìm môn học (mã môn học, tên môn học) có 
--nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
--=> đếm số lần học viên thi ko đạt ở lần thi 1, group by mamh

SELECT B1.MAMH, TENMH, SOHV_KD_L1
FROM (SELECT MAMH, COUNT(*) AS SOHV_KD_L1
FROM KETQUATHI
WHERE LANTHI = 1 AND KQUA = 'Khong Dat'
GROUP BY MAMH) B1
JOIN MONHOC ON MONHOC.MAMH = B1.MAMH
WHERE SOHV_KD_L1 >= ALL(SELECT COUNT(*) AS SOHV_KD_L1
FROM KETQUATHI
WHERE LANTHI = 1 AND KQUA = 'Khong Dat'
GROUP BY MAMH)

--cau 31:Tìm học viên (mã học viên, họ tên) 
--thi môn nào cũng đạt (chỉ xét lần thi thứ 1).

--các môn mà các hv đã thi
select mahv, count(distinct mamh)
from ketquathi
group by mahv

--các hv thi đạt ở lần đầu tiên
select mahv
from ketquathi
where lanthi = 1 and kqua = 'Dat'
group by mahv 

--hv thi môn nào cũng đạt ở lần đầu
SELECT k1.MAHV, ho, ten
FROM KETQUATHI k1 join hocvien on hocvien.mahv = k1.mahv
WHERE LANTHI = 1 AND KQUA = 'Dat'
GROUP BY k1.MAHV, ho, ten
HAVING COUNT(DISTINCT MAMH) = (select count(distinct mamh)
from ketquathi k2
where k1.mahv = k2.mahv
group by k2.mahv)

--cau 32: * Tìm học viên (mã học viên, họ tên) 
--thi môn nào cũng đạt (chỉ xét lần thi sau cùng)

--mã hv thi môn sau cùng đạt
select k1.mahv, ho, ten
from ketquathi k1 join hocvien on hocvien.mahv = k1.mahv
where lanthi = (select max(lanthi) 
	from ketquathi k2 where k2.mahv = k1.mahv and k1.mamh = k2.mamh) 
and kqua = 'Dat'
group by k1.mahv, ho, ten 
having count(distinct mamh) = (select count(distinct mamh)
from ketquathi k3
where k3.mahv = k1.mahv
group by k3.mahv)

select * from ketquathi

--cau 33: * Tìm học viên (mã học viên, họ tên) 
--đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).

--tất cả các môn:
select count(*)
from monhoc

--học viên (mã học viên, họ tên) 
--đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1)
select k1.mahv, ho, ten
from ketquathi k1 join hocvien on hocvien.mahv = k1.mahv
where lanthi = 1 and kqua = 'Dat'
group by k1.mahv, ho, ten 
having count(distinct mamh) = (select count(*) from monhoc)

--cau 34: * Tìm học viên (mã học viên, họ tên) đã thi 
--tất cả các môn đều đạt (chỉ xét lần thi sau cùng).
select k1.mahv, ho, ten
from ketquathi k1 join hocvien on hocvien.mahv = k1.mahv
where lanthi = (select max(lanthi) 
	from ketquathi k2 where k2.mahv = k1.mahv and k1.mamh = k2.mamh) 
and kqua = 'Dat'
group by k1.mahv, ho, ten 
having count(distinct mamh) = (select count(*) from monhoc)

--cau 35:** Tìm học viên (mã học viên, họ tên) 
--có điểm thi cao nhất trong từng môn (lấy điểm ở lần 
--thi sau cùng).
--> kiểu: mamh	 mahv	diem
--điểm cuối của các hv:
select mamh, mahv, diem,
from ketquathi k1
where lanthi = (select max(lanthi) from ketquathi k2
					where k1.mahv = k2.mahv and k1.mamh = k2.mamh)

--học viên (mã học viên, họ tên) 
--có điểm thi cao nhất trong từng môn (lấy điểm ở lần 
--thi sau cùng).
with xephangDiem as (select mamh, mahv, diem,
	rank() over (partition by mamh order by diem desc) as rank_score 
from ketquathi k1
where lanthi = (select max(lanthi) from ketquathi k2
					where k1.mahv = k2.mahv and k1.mamh = k2.mamh))
select mamh, xephangDiem.mahv, ho, ten, diem
from xephangDiem join hocvien on hocvien.mahv = xephangDiem.mahv
where rank_score = 1

--RÀNG BUỘC TV

--tạo rule thuộc tính GIOITINH chỉ có giá trị 'Nam' hoặc 'Nữ'
CREATE RULE GT AS @GT IN ('Nam', 'Nu')
--gán rule cho 2 thuộc tính GIOITINH của QHE HOCVIEN & GIAOVIEN
sp_bindrule GT, 'HOCVIEN.GIOITINH'
sp_bindrule GT, 'GIAOVIEN.GIOITINH'
--bỏ rule
sp_unbindrule 'HOCVIEN.GIOITINH'


CREATE TABLE GV(
	MAGV VARCHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(20),
	HESO NUMERIC(4,3),
	LUONG MONEY)
-- RB LIÊN BỘ CÓ BỐI CẢNH 1 QHE: KHI THAO TÁC VỚI THUỘC TÍNH LƯƠNG THÌ LƯƠNG > LƯƠNG CŨ
--VIẾT TRIGGER
--R1 | THEM | XOA | SUA
--GV |  -   |  -  |  + 

CREATE TRIGGER R1 ON GV FOR UPDATE AS
IF UPDATE(LUONG)
	BEGIN
	DECLARE @i int
	select @i = (select count(*) from inserted, deleted where inserted.magv = deleted.magv
							and inserted.luong <= deleted.luong)
	if @i > 0
		begin
		print 'Vi pham RBTV'
		rollback tran
		end
	end
go

insert into GV(magv,luong) values ('gv01',3400)
update gv set luong = 2300 where magv = 'gv01' -- bao loi
update gv set luong = 4000 where magv = 'gv01' -- ko loi

select * from gv

--r2: cung he so thi cung luong
--R2 | THEM | XOA | SUA
--GV |  +   |  -  |  +(heso, luong)


create trigger r2 on gv for insert, update as
	declare @i int
	select @i = (select count(*) from gv, inserted where gv.heso = inserted.heso and gv.luong <> inserted.luong)
	if @i > 0
	begin
		raiserror('cung he so thi cung luong', 16,1)
		rollback tran 
	end
go

update gv set heso = 2 where magv = 'gv01'
update gv set luong = 30000 where magv = 'gv01'
insert into gv values('gv02','tran a', 2, 30000)
update gv set luong = 45000 where magv = 'gv01' -- bao loi r2 => muon thay doi luong phai update heso
update gv set heso = 3 where magv = 'gv01'




























	-- ĐÃ NHẬP DL
Set dateformat dmy;
ALTER TABLE KHOA ALTER COLUMN TENKHOA NVARCHAR(200)
insert into KHOA(MAKHOA, TENKHOA, NGTLAP, TRGKHOA) values('KHMT','Khoa hoc may tinh','7/6/2005',Null)
insert into KHOA values('HTTT','He thong thong tin','7/6/2005',Null)
insert into KHOA values('CNPM','Cong nghe phan mem','7/6/2005',Null)
insert into KHOA values('MTT','Mang va truyen thong','10/20/2005',Null)
insert into KHOA values('KTMT','Ky thuat may tinh','12/20/2005',Null)

UPDATE KHOA
SET NGTLAP = '6/7/2005'
WHERE NGTLAP = '7/6/2005'

insert into MONHOC values('THDC','Tin hoc dai cuong',4,1,'KHMT')
insert into MONHOC values('CTRR','Cau truc roi rac',5,0,'KHMT')
insert into MONHOC values('CSDL','Co so du lieu',3,1,'HTTT')
insert into MONHOC values('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
insert into MONHOC values('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
insert into MONHOC values('DHMT','Do hoa may tinh',3,1,'KHMT')
insert into MONHOC values('KTMT','Kien truc may tinh',3,0,'KTMT')
insert into MONHOC values('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
insert into MONHOC values('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
insert into MONHOC values('HDH','He dieu hanh',4,0,'KTMT')
insert into MONHOC values('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
insert into MONHOC values('LTCFW','Lap trinh C for win',3,1,'CNPM')
insert into MONHOC values('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

insert into DIEUKIEN values('CSDL','CTRR')
insert into DIEUKIEN values('CSDL','CTDLGT')
insert into DIEUKIEN values('CTDLGT','THDC')
insert into DIEUKIEN values('PTTKTT','THDC')
insert into DIEUKIEN values('PTTKTT','CTDLGT')
insert into DIEUKIEN values('DHMT','THDC')
insert into DIEUKIEN values('LTHDT','THDC')
insert into DIEUKIEN values('PTTKHTTT','CSDL')

insert into GIAOVIEN values('GV01','Ho Thanh Son','PTS','GS','Nam','2/5/1950','11/1/2004',5,2250000,'KHMT')
insert into GIAOVIEN values('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004',4.5,2025000,'HTTT')
insert into GIAOVIEN values('GV03','Do Nghiem Phung','TS','GS','Nu','1/8/1950','23/9/2004',4,1800000,'CNPM')
insert into GIAOVIEN values('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','12/1/2005',4.5,2025000,'KTMT')
insert into GIAOVIEN values('GV05','Mai Thanh Danh','ThS','GV','Nam','12/3/1958','12/1/2005',3,1350000,'HTTT')
insert into GIAOVIEN values('GV06','Tran Doan Hung','TS','GV','Nam','11/3/1953','12/1/2005',4.5,2025000,'KHMT')
insert into GIAOVIEN values('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','1/3/2005',4,1800000,'KHMT')
insert into GIAOVIEN values('GV08','Le Thi Tran','KS',Null,'Nu','26/3/1974','1/3/2005',1.69,760500,'KHMT')
insert into GIAOVIEN values('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','1/3/2005',4,1800000,'HTTT')
insert into GIAOVIEN values('GV10','Le Tran Anh Loan','KS',Null,'Nu','17/7/1972','1/3/2005',1.86,837000,'CNPM')
insert into GIAOVIEN values('GV11','Ho Thanh Tung','CN','GV','Nam','12/1/1980','15/5/2005',2.67,1201500,'MTT')
insert into GIAOVIEN values('GV12','Tran Van Anh','CN',Null,'Nu','29/3/1981','15/5/2005',1.69,760500,'CNPM')
insert into GIAOVIEN values('GV13','Nguyen Linh Dan','CN',Null,'Nu','23/5/1980','15/5/2005',1.69,760500,'KTMT')
insert into GIAOVIEN values('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005',3,1350000,'MTT')
insert into GIAOVIEN values('GV15','Le Ha Thanh','ThS','GV','Nam','4/5/1978','15/5/2005',3,1350000,'KHMT')

insert into LOP values('K11','Lop 1 khoa 1',Null,11,'GV07')
insert into LOP values('K12','Lop 2 khoa 1',Null,12,'GV09')
insert into LOP values('K13','Lop 3 khoa 1',Null,12,'GV14')


insert into HOCVIEN values('K1101','Nguyen Van','A','27/1/1986','Nam','TpHCM','K11', NULL, NULL, NULL)
--GHICHU VARCHAR(100)
--DIEMTB FLOAT
--XEPLOAI VARCHAR(10)
ALTER TABLE HOCVIEN DROP COLUMN GHICHU
ALTER TABLE HOCVIEN DROP COLUMN DIEMTB
ALTER TABLE HOCVIEN DROP COLUMN XEPLOAI
insert into HOCVIEN values('K1102','Tran Ngoc','Han','14/3/1986','Nu','Kien Giang','K11')
insert into HOCVIEN values('K1103','Ha Duy','Lap','18/4/1986','Nam','Nghe An','K11')
insert into HOCVIEN values('K1104','Tran Ngoc','Linh','30/3/1986','Nu','Tay Ninh','K11')
insert into HOCVIEN values('K1105','Tran Minh','Long','27/2/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1106','Le Nhat','Minh','24/1/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1107','Nguyen Nhu','Nhut','27/1/1986','Nam','Ha Noi','K11')
insert into HOCVIEN values('K1108','Nguyen Manh','Tam','27/2/1986','Nam','Kien Giang','K11')
insert into HOCVIEN values('K1109','Phan Thi Thanh','Tam','27/1/1986','Nu','Vinh Long','K11')
insert into HOCVIEN values('K1110','Le Hoai','Thuong','5/2/1986','Nu','Can Tho','K11')
insert into HOCVIEN values('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11')
insert into HOCVIEN values('K1201','Nguyen Van','B','11/2/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1202','Nguyen Thi Kim','Duyen','18/1/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1203','Tran Thi Kim','Duyen','17/9/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1204','Truong My','Hanh','19/5/1986','Nu','Dong Nai','K12')
insert into HOCVIEN values('K1205','Nguyen Thanh','Nam','17/4/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1206','Nguyen Thi Truc','Thanh','4/3/1986','Nu','Kien Giang','K12')
insert into HOCVIEN values('K1207','Tran Thi Bich','Thuy','8/2/1986','Nu','Nghe An','K12')
insert into HOCVIEN values('K1208','Huynh Thi Kim','Trieu','8/4/1986','Nu','Tay Ninh','K12')
insert into HOCVIEN values('K1209','Pham Thanh','Trieu','23/2/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1210','Ngo Thanh','Tuan','14/2/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1211','Do Thi','Xuan','9/3/1986','Nu','Ha Noi','K12')
insert into HOCVIEN values('K1212','Le Thi Phi','Yen','12/3/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1301','Nguyen Thi Kim','Cuc','9/6/1986','Nu','Kien Giang','K13')
insert into HOCVIEN values('K1302','Truong Thi My','Hien','18/3/1986','Nu','Nghe An','K13')
insert into HOCVIEN values('K1303','Le Duc','Hien','21/3/1986','Nam','Tay Ninh','K13')
insert into HOCVIEN values('K1304','Le Quang','Hien','18/4/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1305','Le Thi','Huong','27/3/1986','Nu','TpHCM','K13')
insert into HOCVIEN values('K1306','Nguyen Thai','Huu','30/3/1986','Nam','Ha Noi','K13')
insert into HOCVIEN values('K1307','Tran Minh','Man','28/5/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1308','Nguyen Hieu','Nghia','8/4/1986','Nam','Kien Giang','K13')
insert into HOCVIEN values('K1309','Nguyen Trung','Nghia','18/1/1987','Nam','Nghe An','K13')
insert into HOCVIEN values('K1310','Tran Thi Hong','Tham','22/4/1986','Nu','Tay Ninh','K13')
insert into HOCVIEN values('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1312','Nguyen Thi Kim','Yen','7/9/1986','Nu','TpHCM','K13')

ALTER TABLE HOCVIEN ADD GHICHU VARCHAR(100)
ALTER TABLE HOCVIEN ADD DIEMTB FLOAT
ALTER TABLE HOCVIEN ADD XEPLOAI VARCHAR(10)

Set dateformat dmy;
insert into GIANGDAY values('K11','THDC','GV07',1,2006,'2/1/2006','12/5/2006')
insert into GIANGDAY values('K12','THDC','GV06',1,2006,'2/1/2006','12/5/2006')
insert into GIANGDAY values('K13','THDC','GV15',1,2006,'2/1/2006','12/5/2006')
insert into GIANGDAY values('K11','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
insert into GIANGDAY values('K12','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
insert into GIANGDAY values('K13','CTRR','GV08',1,2006,'9/1/2006','17/5/2006')
insert into GIANGDAY values('K11','CSDL','GV05',2,2006,'1/6/2006','15/7/2006')
insert into GIANGDAY values('K12','CSDL','GV09',2,2006,'1/6/2006','15/7/2006')
insert into GIANGDAY values('K13','CTDLGT','GV15',2,2006,'1/6/2006','15/7/2006')
insert into GIANGDAY values('K13','CSDL','GV05',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K13','DHMT','GV07',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K11','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K12','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K11','HDH','GV04',1,2007,'2/1/2007','18/2/2007')
insert into GIANGDAY values('K12','HDH','GV04',1,2007,'2/1/2007','20/3/2007')
insert into GIANGDAY values('K11','DHMT','GV07',1,2007,'18/2/2007','20/3/2007')

insert into KETQUATHI values('K1101','CSDL',1,'20/7/2006',10,'Dat')
insert into KETQUATHI values('K1101','CTDLGT',1,'28/12/2006',9,'Dat')
insert into KETQUATHI values('K1101','THDC',1,'20/5/2006',9,'Dat')
insert into KETQUATHI values('K1101','CTRR',1,'13/5/2006',9.5,'Dat')
insert into KETQUATHI values('K1102','CSDL',1,'20/7/2006',4,'Khong Dat')
insert into KETQUATHI values('K1102','CSDL',2,'27/7/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1102','CSDL',3,'10/8/2006',4.5,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',1,'28/12/2006',4.5,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',2,'5/1/2007',4,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',3,'15/1/2007',6,'Dat')
insert into KETQUATHI values('K1102','THDC',1,'20/5/2006',5,'Dat')
insert into KETQUATHI values('K1102','CTRR',1,'13/5/2006',7,'Dat')
insert into KETQUATHI values('K1103','CSDL',1,'20/7/2006',3.5,'Khong Dat')
insert into KETQUATHI values('K1103','CSDL',2,'27/7/2006',8.25,'Dat')
insert into KETQUATHI values('K1103','CTDLGT',1,'28/12/2006',7,'Dat')
insert into KETQUATHI values('K1103','THDC',1,'20/5/2006',8,'Dat')
insert into KETQUATHI values('K1103','CTRR',1,'13/5/2006',6.5,'Dat')
insert into KETQUATHI values('K1104','CSDL',1,'20/7/2006',3.75,'Khong Dat')
insert into KETQUATHI values('K1104','CTDLGT',1,'28/12/2006',4,'Khong Dat')
insert into KETQUATHI values('K1104','THDC',1,'20/5/2006',4,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',1,'13/5/2006',4,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',2,'20/5/2006',3.5,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',3,'30/6/2006',4,'Khong Dat')
insert into KETQUATHI values('K1201','CSDL',1,'20/7/2006',6,'Dat')
insert into KETQUATHI values('K1201','CTDLGT',1,'28/12/2006',5,'Dat')
insert into KETQUATHI values('K1201','THDC',1,'20/5/2006',8.5,'Dat')
insert into KETQUATHI values('K1201','CTRR',1,'13/5/2006',9,'Dat')
insert into KETQUATHI values('K1202','CSDL',1,'20/7/2006',8,'Dat')
insert into KETQUATHI values('K1202','CTDLGT',1,'28/12/2006',4,'Khong Dat')
insert into KETQUATHI values('K1202','CTDLGT',2,'5/1/2007',5,'Dat')
insert into KETQUATHI values('K1202','THDC',1,'20/5/2006',4,'Khong Dat')
insert into KETQUATHI values('K1202','THDC',2,'27/5/2006',4,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',1,'13/5/2006',3,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',2,'20/5/2006',4,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',3,'30/6/2006',6.25,'Dat')
insert into KETQUATHI values('K1203','CSDL',1,'20/7/2006',9.25,'Dat')
insert into KETQUATHI values('K1203','CTDLGT',1,'28/12/2006',9.5,'Dat')
insert into KETQUATHI values('K1203','THDC',1,'20/5/2006',10,'Dat')
insert into KETQUATHI values('K1203','CTRR',1,'13/5/2006',10,'Dat')
insert into KETQUATHI values('K1204','CSDL',1,'20/7/2006',8.5,'Dat')
insert into KETQUATHI values('K1204','CTDLGT',1,'28/12/2006',6.75,'Dat')
insert into KETQUATHI values('K1204','THDC',1,'20/5/2006',4,'Khong Dat')
insert into KETQUATHI values('K1204','CTRR',1,'13/5/2006',6,'Dat')
insert into KETQUATHI values('K1301','CSDL',1,'20/12/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1301','CTDLGT',1,'25/7/2006',8,'Dat')
insert into KETQUATHI values('K1301','THDC',1,'20/5/2006',7.75,'Dat')
insert into KETQUATHI values('K1301','CTRR',1,'13/5/2006',8,'Dat')
insert into KETQUATHI values('K1302','CSDL',1,'20/12/2006',6.75,'Dat')
insert into KETQUATHI values('K1302','CTDLGT',1,'25/7/2006',5,'Dat')
insert into KETQUATHI values('K1302','THDC',1,'20/5/2006',8,'Dat')
insert into KETQUATHI values('K1302','CTRR',1,'13/5/2006',8.5,'Dat')
insert into KETQUATHI values('K1303','CSDL',1,'20/12/2006',4,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',1,'25/7/2006',4.5,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',2,'7/8/2006',4,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',3,'15/8/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1303','THDC',1,'20/5/2006',4.5,'Khong Dat')
insert into KETQUATHI values('K1303','CTRR',1,'13/5/2006',3.25,'Khong Dat')
insert into KETQUATHI values('K1303','CTRR',2,'20/5/2006',5,'Dat')
insert into KETQUATHI values('K1304','CSDL',1,'20/12/2006',7.75,'Dat')
insert into KETQUATHI values('K1304','CTDLGT',1,'25/7/2006',9.75,'Dat')
insert into KETQUATHI values('K1304','THDC',1,'20/5/2006',5.5,'Dat')
insert into KETQUATHI values('K1304','CTRR',1,'13/5/2006',5,'Dat')
insert into KETQUATHI values('K1305','CSDL',1,'20/12/2006',9.25,'Dat')
insert into KETQUATHI values('K1305','CTDLGT',1,'25/7/2006',10,'Dat')
insert into KETQUATHI values('K1305','THDC',1,'20/5/2006',8,'Dat')
insert into KETQUATHI values('K1305','CTRR',1,'13/5/2006',10,'Dat')

update KHOA set TRGKHOA='GV01' where MAKHOA='KHMT'
update KHOA set TRGKHOA='GV02' where MAKHOA='HTTT'
update KHOA set TRGKHOA='GV03' where MAKHOA='MTT'
update KHOA set TRGKHOA='GV04' where MAKHOA='CNPM'

update LOP set TRGLOP='K1108' where MALOP='K11'
update LOP set TRGLOP='K1205' where MALOP='K12'
update LOP set TRGLOP='K1305' where MALOP='K13'
