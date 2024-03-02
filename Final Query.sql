-- Truy vấn nhiều bảng
-- Đếm số lượng nhân viên làm ở mỗi cửa hàng. Thông tin gồm: store_id, store_name, amount
USE qlyxemay;

SELECT 
	so.store_id,
	store_name,
	COUNT(*) amount
FROM stores so
JOIN staffs sa
ON sa.store_id = so.store_id
GROUP BY so.store_id, store_name
ORDER BY Amount,store_name;

-- Tính tổng thành tiền của mỗi hóa đơn. Thông tin gồm: order_id, total
SELECT
	order_id,
	SUM(quantity*price) total
FROM order_items o
JOIN products p
ON o.product_id = p.product_id
GROUP BY order_id
ORDER BY order_id;

-- Tìm số hóa đơn mỗi cửa hàng đã thực hiện trong tháng 4. Thông tin gồm: store_id, store_name, total_bill 
SELECT
	sta.store_id,
	store_name,
	COUNT(*) total_bill
FROM orders o
JOIN staffs sta ON o.staff_id = sta.staff_id
JOIN stores sto ON sta.store_id = sto.store_id
WHERE MONTH(order_date) = 4
GROUP BY sta.store_id, store_name;

-- Tính tổng doanh thu mà mỗi nhân viên đã bán được tháng 4. Thông tin gồm: staff_id, staff_name, total_per_staff
WITH total AS
	(
		SELECT
			order_id,
			SUM(quantity*price) total
		FROM order_items o
		JOIN products p
		ON o.product_id = p.product_id
		GROUP BY order_id
	),
sale AS
	(
		SELECT
			o.staff_id,
			s.staff_name,
			SUM(total) total_per_staff
		FROM orders o 
		JOIN total t ON o.order_id = t.order_id
		JOIN staffs s ON o.staff_id = s.staff_id
		WHERE MONTH(order_date) = 4
		GROUP BY o.staff_id, s.staff_name
	),
non_sale AS
	(
		SELECT
			staff_id,
			staff_name,
			0 total_per_staff
		FROM staffs
		WHERE staff_id NOT IN
					(
						SELECT 
							DISTINCT o.staff_id
						FROM orders o
						JOIN staffs s 
						ON o.staff_id = s.staff_id
						WHERE MONTH(order_date) = 4
					)
	)

SELECT *
FROM non_sale
	UNION 
SELECT *
FROM sale
ORDER BY staff_id;
			 
-- Truy vấn tính toán
-- Tính giá trị trung bình các sản phẩm ở từng kho. Thông tin gồm stock_id, avg_value
SELECT
	stock_id,
	CAST(AVG(price * inventory) AS DECIMAL(18,0)) avg_value
FROM products
GROUP BY stock_id;

-- Sản phẩm đắt nhất mỗi loại xe mà cửa hàng sở hữu. Thông tin gồm category_id, category_name, product_name, price
WITH max_price AS
	(
		SELECT
			c.category_id,
			c.category_name,
			MAX(price) price
		FROM products p
		JOIN categories c
		ON p.category_id = c.category_id
		GROUP BY c.category_id, c.category_name
	)

SELECT
	m.category_id,
	category_name,
	product_name,
	m.price
FROM max_price m
JOIN products p
ON p.price = m.price
ORDER BY m.category_id;

-- Tốc độ tăng trưởng doanh thu tháng 5 so với tháng 4. 
WITH total AS
	(
		SELECT
			order_id,
			SUM(quantity*price) total
		FROM order_items o
		JOIN products p
		ON o.product_id = p.product_id
		GROUP BY order_id
	),
total_per_month AS
	(
		SELECT
			MONTH(order_date) months,
			SUM(total) total_per_month
		FROM orders o
		JOIN total t
		ON o.order_id = t.order_id
		GROUP BY MONTH(order_date)
	)

SELECT
	((SELECT total_per_month FROM total_per_month WHERE months = 5)
	- (SELECT total_per_month FROM total_per_month WHERE months = 4)) 
	/ (SELECT total_per_month FROM total_per_month WHERE months = 4) rate;

/* Tính lương của mỗi nhân viên trong tháng 4 biết rằng với mỗi đơn hàng được thực hiện họ sẽ được trích 1% đơn hàng
Thông tin gồm staff_id, staff_name, income */
WITH total AS
	(
		SELECT
			order_id,
			SUM(quantity*price) total
		FROM order_items o
		JOIN products p
		ON o.product_id = p.product_id
		GROUP BY order_id
	),
sale AS
	(
		SELECT
			o.staff_id,
			s.staff_name,
			salary,
			SUM(total) total_per_staff
		FROM orders o 
		JOIN total t ON o.order_id = t.order_id
		JOIN staffs s ON o.staff_id = s.staff_id
		WHERE MONTH(order_date) = 4
		GROUP BY o.staff_id, s.staff_name, salary
	),
sale_income AS
	(
		SELECT 
			staff_id,
			staff_name,
			CONVERT(INT, (salary + 1.0/100 * total_per_staff)) income
		FROM sale
	),
non_sale_income AS
	(
		SELECT
			staff_id,
			staff_name,
			salary income
		FROM staffs
		WHERE staff_id NOT IN
					(
						SELECT 
							DISTINCT o.staff_id
						FROM orders o
						JOIN staffs s 
						ON o.staff_id = s.staff_id
						WHERE MONTH(order_date) = 4
					)
	)

SELECT *
FROM non_sale_income
	UNION 
SELECT *
FROM sale_income
ORDER BY staff_id;

-- Truy vấn gom nhóm có điều kiện
-- Tìm những sản phẩm được đặt với số lượng lớn hơn 3 trong tháng 4. Thông tin gồm product_id, product_name, sum_quantity
SELECT
	oi.product_id,
	p.product_name,
	SUM(quantity) sum_quantity
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE MONTH(order_date) = 4
GROUP BY oi.product_id, p.product_name
HAVING SUM(quantity) > 3
ORDER BY sum_quantity DESC;

--	Tìm những hãng xe được mua với số lượng lớn hơn 5 trong tháng 4. Thôn tin gồm brand_id, brand_name, sum_quantity
WITH sum_quantity AS
	(
		SELECT
			oi.product_id,
			p.product_name,
			brand_id,
			SUM(quantity) sum_quantity
		FROM order_items oi
		JOIN orders o ON oi.order_id = o.order_id
		JOIN products p ON oi.product_id = p.product_id
		WHERE MONTH(order_date) = 4
		GROUP BY oi.product_id, p.product_name, brand_id
	)

SELECT
	s.brand_id,
	b.brand_name,
	SUM(s.sum_quantity) sum_quantity
FROM sum_quantity s
JOIN brands b ON s.brand_id = b.brand_id
GROUP BY s.brand_id, b.brand_name
HAVING SUM(s.sum_quantity) > 5
ORDER BY SUM(s.sum_quantity) DESC;

-- Tìm những hóa đơn có giá trị lớn hơn 500 triệu. Thông tin gồm order_id, total
SELECT
	order_id,
	SUM(quantity*price) total
FROM order_items o
JOIN products p
ON o.product_id = p.product_id
GROUP BY order_id
HAVING SUM(quantity*price) > 500000000
ORDER BY total DESC;

/*Tìm nhân viên đạt được mức hoa hồng lớn hơn 10 triệu trong tháng 4. Biết mỗi nhân viên có thể trích 1% từ hóa đơn bán được
Thông tin gồm staff_id, staff_name, tip*/
WITH total AS
	(
		SELECT
			order_id,
			SUM(quantity*price) total
		FROM order_items o
		JOIN products p
		ON o.product_id = p.product_id
		GROUP BY order_id
	)

SELECT
	o.staff_id,
	s.staff_name,
	CONVERT(INT, (1.0/100 * SUM(total))) tip
FROM orders o 
JOIN total t ON o.order_id = t.order_id
JOIN staffs s ON o.staff_id = s.staff_id
WHERE MONTH(order_date) = 4
GROUP BY o.staff_id, s.staff_name, salary
HAVING CONVERT(INT, (1.0/100 * SUM(total))) > 10000000;

-- Truy vấn con
-- Tìm tổng hóa đơn do các nhân viên cấp quản lý thực hiện trong tháng 4. Thông tin gồm: manager_id, manager_name, total_bill
SELECT
	o.staff_id manager_id,
	s.staff_name manager_name,
	COUNT(*) total_bill	
FROM orders o
JOIN staffs s
ON o.staff_id = s.staff_id
WHERE o.staff_id IN (SELECT manager_id FROM stores)
GROUP BY o.staff_id, s.staff_name;

-- Tìm nhân viên có số tuổi lớn nhất trong mỗi cơ sở. Thông tin gồm: store_id,store_name, staff_name, birthday, age
SELECT
	sa.store_id,
	store_name,
	staff_name,
	FORMAT(birthday, 'dd-MM-yyyy') birthday,
	YEAR(GETDATE()) - YEAR(birthday) age
FROM staffs sa
JOIN stores so 
ON sa.store_id = so.store_id
WHERE YEAR(GETDATE()) - YEAR(birthday) IN 
									(
										SELECT
											MAX(YEAR(GETDATE()) - YEAR(birthday))
										FROM staffs
										GROUP BY store_id
									)
ORDER BY store_id;

-- Tìm thông tin khách hàng đã thanh toán nhiều hóa đơn nhất trong tháng 4. Thông tin gồm: customer_id, customer_name, total_bill
SELECT
	o.customer_id,
	customer_name,
	COUNT(*) total_bill
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, customer_name
HAVING COUNT(*) IN 
			(
				SELECT 
					TOP 1 COUNT(*)
				FROM orders
				WHERE MONTH(order_date) = 4
				GROUP BY customer_id
				ORDER BY COUNT(*) DESC
			);

/* Biết rằng mỗi nhân viên cấp quản lý ngoài 1% từ hóa đơn còn có 10% hoa hồng của nhân viên dưới cấp.
Tính lương thực nhận của nhân viên cấp quản lý trong tháng 4. Thông tin gồm: store_name, manager_id, manager_name, real_income*/
WITH total AS
	(
		SELECT
			order_id,
			SUM(quantity*price) total
		FROM order_items o
		JOIN products p
		ON o.product_id = p.product_id
		GROUP BY order_id
	),
sale AS
	(
		SELECT
			o.staff_id,
			s.staff_name,
			salary,
			store_id,
			SUM(total) total_per_staff
		FROM orders o 
		JOIN total t ON o.order_id = t.order_id
		JOIN staffs s ON o.staff_id = s.staff_id
		WHERE MONTH(order_date) = 4
		GROUP BY o.staff_id, s.staff_name, salary, store_id
	),
sale_income AS
	(
		SELECT 
			store_id,
			CONVERT(INT, SUM(salary + 1.0/100 * total_per_staff)) income
		FROM sale
		WHERE staff_id NOT IN (SELECT manager_id FROM stores)
		GROUP BY store_id
	)

SELECT
	store_name,
	manager_id,
	sta.staff_name manager_name,
	CONVERT(INT, (sta.salary + 1.0/10 * income + 1.0/100 * total_per_staff)) real_income
FROM sale_income si
JOIN stores s ON si.store_id = s.store_id
JOIN staffs sta ON sta.staff_id = s.manager_id
JOIN sale sal ON sal.staff_id = s.manager_id;

-- hàm tìm mức giá trị cao nhất trong các sản phẩm ở cửa hàng
CREATE FUNCTION dbo.MaxPrice()
RETURNS VARCHAR(100)
AS
BEGIN
	RETURN
		(
			SELECT
				TOP(1) price
			FROM products
			ORDER BY price DESC
		)
END;

-- Sử dụng hàm MaxPrice
SELECT 
	product_id,
	product_name,
	price
FROM products
WHERE price IN (dbo.MaxPrice())

-- hàm xuất ra tổng tiền mỗi hóa đơn
CREATE FUNCTION dbo.SumBill()
RETURNS @SumBill TABLE (order_id int, total_bill int)
AS
BEGIN
	INSERT INTO @SumBill
		SELECT
			order_id,
			SUM(price*quantity) total_bill
		FROM order_items o 
		JOIN products p
		ON o.product_id = p.product_id
		GROUP BY order_id	
	RETURN;
END;

-- sử dụng hàm SumBill
SELECT *
FROM dbo.SumBill();

-- Thủ tục thêm dữ liệu của một hóa đơn mới
CREATE PROCEDURE InsertOrder(@order_id int, @order_date datetime, @customer_id int, @staff_id int)
AS
BEGIN
	IF EXISTS(SELECT customer_id FROM customers WHERE @customer_id = customer_id)
	BEGIN
		IF EXISTS(SELECT staff_id FROM staffs WHERE @staff_id = staff_id)
		BEGIN
			IF NOT EXISTS(SELECT order_id FROM orders WHERE order_id = @order_id)
			BEGIN
				INSERT INTO orders(order_id, order_date, customer_id, staff_id) 
				VALUES (@order_id, @order_date, @customer_id, @staff_id);
				PRINT N'Thêm thành công';				
			END
			ELSE
				PRINT N'Thêm thất bại do hóa đơn '+ LTRIM(STR(@order_id)) + N' đã tồn tại';
		END
		ELSE
			PRINT N'Thêm thất bại do nhân viên '+ LTRIM(STR(@staff_id)) + N' chưa tồn tại';
	END
	ELSE
		PRINT N'Thêm thất bại do khách hàng '+ LTRIM(STR(@customer_id)) + N' chưa tồn tại';
END;

-- Sử dụng thủ tục InsertOrder
EXEC InsertOrder '1', '4/13/2022', '1', '1' 

-- Thủ tục thêm dữ liệu một sản phẩm mới
CREATE PROCEDURE InsertProduct(@product_id int, @product_name varchar(100), @brand_id int, @category_id int, @stock_id int, @model_year int, @price decimal(18, 0), @inventory int)
AS
BEGIN
	IF EXISTS(SELECT brand_id FROM brands WHERE @brand_id = brand_id)
	BEGIN
		IF EXISTS(SELECT category_id FROM categories WHERE @category_id = category_id)
		BEGIN
			IF EXISTS(SELECT stock_id FROM stocks WHERE stock_id = @stock_id)
			BEGIN
				IF NOT EXISTS(SELECT product_id FROM products WHERE product_id = @product_id)
				BEGIN
					INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory) 
					VALUES (@product_id, @product_name, @brand_id, @category_id, @stock_id, @model_year, @price, @inventory);
					PRINT N'Thêm thành công';
				END
				ELSE
					PRINT N'Thêm thất bại do sản phẩm '+ LTRIM(STR(@product_id)) + N' đã tồn tại';
			END
			ELSE
				PRINT N'Thêm thất bại do kho '+ LTRIM(STR(@stock_id)) + N' chưa tồn tại';
		END
		ELSE
			PRINT N'Thêm thất bại do loại xe '+ LTRIM(STR(@category_id)) + N' chưa tồn tại';
	END
	ELSE
		PRINT N'Thêm thất bại do hãng xe '+ LTRIM(STR(@brand_id)) + N' chưa tồn tại';
END;

-- Sử dụng thủ tục InsertProduct
EXEC InsertProduct '19', 'Wave RSX ', '1', '1', '1', '2022', '30000000', '13'

-- Xóa dữ liệu ra khỏi bảng products
DELETE FROM products
WHERE product_id = '19'

-- Phân quyền cho cấp nhân viên truy cập vào cơ sở dữ liệu
CREATE LOGIN Staffs WITH PASSWORD = '31211027658'
CREATE USER NgocHang FOR LOGIN Staffs
GRANT SELECT ON categories TO NgocHang
GRANT SELECT ON brands TO NgocHang
GRANT SELECT ON stocks TO NgocHang
GRANT SELECT ON products TO NgocHang
GRANT SELECT ON stores TO NgocHang
GRANT SELECT(order_id, order_date), UPDATE ON orders TO NgocHang
GRANT UPDATE ON order_items TO NgocHang
