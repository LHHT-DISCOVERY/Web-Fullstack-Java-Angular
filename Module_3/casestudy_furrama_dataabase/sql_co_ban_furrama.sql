use furama_managerment;

-- task 2 : Hiển thị thông tin của tất cả nhân viên có trong hệ thống 
-- có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự
select * from nhan_vien where ho_ten regexp '(^[a-zA-Z\\s]+\\s[htk][A-Za-z]+$)';

-- task 3 : Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
select * ,year(curdate())-year(ngay_sinh) as 'Tuổi' from khach_hang 
where ( 18<= year(curdate())-year(ngay_sinh) and  year(curdate())-year(ngay_sinh) <= 50) and (dia_chi like '%Đà Nẵng%' or dia_chi like '%Quảng Trị%');
 
 -- task 4.	Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. 
 -- Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng. 
 -- Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.
select c.ma_khach_hang, c.ho_ten, count(ct.ma_khach_hang) as 'số lần đặt ' from hop_dong as ct
left join khach_hang as c on c.ma_khach_hang = ct.ma_khach_hang
left join loai_khach as ts on ts.ma_loai_khach = c.ma_loai_khach
where ts.ma_loai_khach = 1    
group by ma_khach_hang
order by count(ct.ma_khach_hang) desc;

-- task 5 : Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
-- (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) 
-- cho tất cả các khách hàng đã từng đặt phòng. 
-- (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).
select kh.ma_khach_hang , kh.ho_ten , lk.ten_loai_khach ,
ifnull(ct.ma_hop_dong , 'Chưa có hợp đồng')  as 'Mã Hợp Đồng' ,
ifnull(dv.ten_dich_vu , 'chưa có dịch vụ') as 'Tên Dịch Vụ',
ifnull(ct.ngay_lam_hop_dong, 'chưa có ') as "ngày làm hợp đồng",
ifnull(ct.ngay_ket_thuc,'chưa có ') as "ngày kết thúc",
sum(ifnull(dv.chi_phi_thue ,0) + ifnull(ctc.so_luong,0)*ifnull(dvdk.gia,0))  as 'Tổng Tiền' 
from khach_hang kh
join loai_khach as lk on lk.ma_loai_khach = kh.ma_loai_khach
left join hop_dong ct on ct.ma_khach_hang = kh.ma_khach_hang
left join dich_vu as dv on ct.ma_dich_vu = dv.ma_dich_vu
left join hop_dong_chi_tiet as ctc on  ct.ma_hop_dong = ctc.ma_hop_dong
left join dich_vu_di_kem as dvdk on  ctc.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem
group by ct.ma_hop_dong , kh.ma_khach_hang
order by ma_khach_hang asc ;


-- 6.	Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ chưa từng được khách hàng thực hiện đặt từ quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3).
select ma_dich_vu , ten_dich_vu , dien_tich , chi_phi_thue , ten_loai_dich_vu from dich_vu join loai_dich_vu using (ma_loai_dich_vu)
where ma_dich_vu not in(
   select
            ma_dich_vu
        from
            dich_vu
            join hop_dong using (ma_dich_vu)
        where
            year(ngay_lam_hop_dong) = 2021 
            and 1 <= month(ngay_lam_hop_dong) <= 3);


-- 7.	Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ đã từng được khách hàng đặt phòng trong năm 2020 
-- nhưng chưa từng được khách hàng đặt phòng trong năm 2021.
select
    ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu
from dich_vu dv
join loai_dich_vu using(ma_loai_dich_vu)
where ma_dich_vu in (select ma_dich_vu from dich_vu join hop_dong using(ma_dich_vu) where year(ngay_lam_hop_dong) = 2020)
and ma_dich_vu not in (select ma_dich_vu from dich_vu join hop_dong using(ma_dich_vu) where year(ngay_lam_hop_dong) = 2021);

-- 8.Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau.
-- c1 :  
select ho_ten, count(*) as khach_hang_trung_ten from khach_hang
group by ho_ten;

-- c2 : 
select ho_ten from khach_hang union select ho_ten from khach_hang;

-- c3 :
select distinct(ho_ten) from khach_hang ;

-- 9.Thực hiện thống kê doanh thu theo tháng,
 -- nghĩa là tương ứng với mỗi tháng trong năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng.
 select month(hd.ngay_lam_hop_dong) as thang, count(ma_khach_hang) from hop_dong as hd
 where year(hd.ngay_lam_hop_dong) = 2021
 group by thang
 order by thang asc;
 
 -- 10. Hiển thị thông tin tương ứng với từng hợp đồng 
 -- thì đã sử dụng bao nhiêu dịch vụ đi kèm. Kết quả hiển thị bao gồm ma_hop_dong, ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc, so_luong_dich_vu_di_kem
 -- (được tính dựa trên việc sum so_luong ở dich_vu_di_kem).
select ma_hop_dong , ngay_lam_hop_dong , ngay_ket_thuc , tien_dat_coc from hop_dong 
left join hop_dong_chi_tiet using(ma_hop_dong)
group by ma_hop_dong
