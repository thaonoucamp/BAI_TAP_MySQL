-- BÀI TẬP ÔN TẬP SQL
-- Bài quản lý sản phẩm
USE DEMO2006;
-- 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.

select * from `order` where time between'2006-06-19' and '2006-06-20';

-- 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).

select o.id, sum(p.price * od.quantity) as total
from demo2006.order o, orderDetail od, product p
where od.productid = p.id and od.orderid = o.id 
and month(o.time) = 6 and year(o.time) = 2006
group by o.id
order by o.time and total desc;

-- 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 19/06/2007.

select c.id, c.name
from customer c join demo2006.order o on o.customerId = c.id
where o.time like '2006-06-20';

-- 10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.

select p.id, p.name 
from product p join orderDetail od on p.id = od.productid
join `order` o on od.orderid = o.id
join customer c on c.id = o.customerid
where c.name = 'Nguyễn Văn A' and o.time like '2006-10%';

-- 11. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”.

select od.orderid
from orderdetail od join demo2006.order o on od.orderid = o.id
join product p on p.id = od.productid
where p.name in ('tủ lạnh','máy giặt')
group by o.id;

-- 12. Tìm các số hóa đơn đã mua sản phẩm “Máy giặt” hoặc “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.

select o.id
from `order` o join orderdetail od  on od.orderid = o.id
join product p on p.id = od.productid
where p.name in ('máy giặt','tủ lạnh') and od.quantity between 1 and 20
group by o.id;

-- 13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm “Máy giặt” và “Tủ lạnh”, mỗi sản phẩm mua với số lượng từ 10 đến 20.

create view maygiat as
select o.id
from `order` o join orderdetail od  on od.orderid = o.id
join product p on p.id = od.productid
where p.name like 'máy giặt' and od.quantity between 1 and 20;

create view tulanh as
select o.id
from `order` o join orderdetail od  on od.orderid = o.id
join product p on p.id = od.productid
where p.name like 'tủ lạnh' and od.quantity between 1 and 20;

select maygiat.orderid
from maygiat join tulanh on maygiat.orderid = tulanh.orderid;

-- 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được

select id, name
from product 
where id not in (
select productid
from orderdetail);

-- 16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.

select id, name
from product
where id not in(select productid 
from orderdetail od join `order` o on o.id = od.orderid 
where year(o.time) = 2006);

-- 17. In ra danh sách các sản phẩm (MASP,TENSP) có giá >300 sản xuất bán được trong năm 2006.


select id, name, price
from product
where price > 300 and id in(
select productid 
from orderdetail od 
join `order` o on o.id = od.orderid
where year(o.time) = 2006);

-- 18. Tìm số hóa đơn đã mua tất cả các sản phẩm có giá >200.

select id, name, price
from product
where price > 200 and id in(
select productid
from orderdetail od join `order` o on o.id = od.orderid);

-- 19. Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm có giá <300.

select id, name, price
from product
where price < 300 and id in(
select productid
from orderdetail od join `order` o on o.id = od.orderid
where year(o.time) = 2006);

-- 21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.

select count(id) as sp_khacnhau
from product
where id in(
select productid
from orderdetail od join `order` o on o.id = od.orderid
where year(o.time) = 2006);

-- 22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?

create view total as 
select o.id, sum(p.price * od.quantity) as total, o.time
from product p join orderdetail od on p.id = od.productid
join `order` o on od.orderid = o.id
group by o.id;

select min(total), max(total) from total;

-- 23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?

create view total_23 as
select o.id, sum(p.price * od.quantity) as total
from product p join orderdetail od on p.id = od.productid
join `order` o on o.id = od.orderid
where year(o.time) = 2006
group by o.id;

select avg(total_23.total) from total_23;

-- 24. Tính doanh thu bán hàng trong năm 2006.

select sum(total_23.total) from total_23;

-- 25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.

select id
from total_23
where total_23.total = (select max(total_23.total) from total_23);

-- 26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.

select c.id, c.name, o.id
from customer c join `order` o on c.id = o.customerid
where o.id=(select id
from total_23
where total_23.total = (select max(total_23.total) from total_23)
);

-- 27. In ra danh sách 3 khách hàng (MAKH, HOTEN) mua nhiều hàng nhất (tính theo số lượng).

select o.customerid, c.name, sum(od.quantity) as totalQuantity
from customer c join demo2006.order o on c.id = o.customerid
join orderdetail od on o.id = od.orderid
group by o.customerid
order by totalQuantity desc
limit 3;

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.

create view view_28 as
select p.price
from demo2006.product p
group by p.price
order by p.price desc
limit 3;

-- 29. In ra danh sách các sản phẩm (MASP, TENSP) có tên bắt đầu bằng chữ M, có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).


-- 32. Tính tổng số sản phẩm giá <300.
-- 33. Tính tổng số sản phẩm theo từng giá.
-- 34. Tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm bắt đầu bằng chữ M.
-- 35. Tính doanh thu bán hàng mỗi ngày.
-- 36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
-- 37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
-- 38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
-- 39. Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).
-- 40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
-- 41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
-- 42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
-- 45. Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
