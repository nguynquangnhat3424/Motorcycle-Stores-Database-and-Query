CREATE DATABASE qlyxemay;
USE qlyxemay;

CREATE TABLE brands
(
	brand_id int PRIMARY KEY,
	brand_name varchar(100)
)

CREATE TABLE categories
(
	category_id int PRIMARY KEY,
	category_name varchar(100)
)	

CREATE TABLE stocks
(
	stock_id int PRIMARY KEY,
	vacant char(2) CHECK(vacant IN ('Y','N'))
)

CREATE TABLE products
(
	product_id int PRIMARY KEY,
	product_name varchar(100),
	brand_id int FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
	category_id int FOREIGN KEY (category_id) REFERENCES categories(category_id),
	stock_id int FOREIGN KEY (stock_id) REFERENCES stocks(stock_id),
	model_year int,
	price decimal,
	inventory int
)

CREATE TABLE customers
(
	customer_id int PRIMARY KEY,
	customer_name nvarchar(100),
	phone char(10),
	email varchar(100)	
)

CREATE TABLE stores
(
	store_id int PRIMARY KEY,
	store_name nvarchar(100),
	phone char(10),
	email varchar(100),
	store_address nvarchar(100),
	manager_id int
)

CREATE TABLE staffs
(
	staff_id int PRIMARY KEY,
	staff_name nvarchar(100),
	store_id int FOREIGN KEY (store_id) REFERENCES stores(store_id),
	birthday datetime DEFAULT(GETDATE()),
	gender nchar(3) CHECK(gender IN (N'Nam',N'Nữ')),
	phone char(10),
	email varchar(100),
	salary int,
	manager_id int 
)

CREATE TABLE orders
(
	order_id int PRIMARY KEY,
	order_date datetime DEFAULT(GETDATE()),
	customer_id int FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	staff_id int FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
)

CREATE TABLE order_items
(
	order_id int FOREIGN KEY (order_id) REFERENCES orders(order_id),
	item_id int,
	product_id int FOREIGN KEY (product_id) REFERENCES products(product_id),
	quantity int
	PRIMARY KEY (order_id, product_id)
)

CREATE TABLE relatives
(
	staff_id int FOREIGN KEY (staff_id) REFERENCES staffs(staff_id),
	relative_name nvarchar(100),
	relationship nvarchar(100)
	PRIMARY KEY (staff_id, relative_name)
)

ALTER TABLE stores
ADD CONSTRAINT fk_stores_staff FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
ALTER TABLE staffs
ADD CONSTRAINT fk_staffs_staffs FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)

INSERT INTO categories(category_id, category_name)
VALUES ('1','Adventure')
INSERT INTO categories(category_id, category_name)
VALUES ('2','Cruiser')
INSERT INTO categories(category_id, category_name)
VALUES ('3','Naked Bike')
INSERT INTO categories(category_id, category_name)
VALUES ('4','Scooter')
INSERT INTO categories(category_id, category_name)
VALUES ('5','Sport Bike')
INSERT INTO categories(category_id, category_name)
VALUES ('6','Sport Touring')
INSERT INTO categories(category_id, category_name)
VALUES ('7','Touring')
INSERT INTO categories(category_id, category_name)
VALUES ('8','Underbone')


INSERT INTO brands(brand_id, brand_name)
VALUES ('1','BMW')
INSERT INTO brands(brand_id, brand_name)
VALUES ('2','Ducati')
INSERT INTO brands(brand_id, brand_name)
VALUES ('3','Harley - Davidson')
INSERT INTO brands(brand_id, brand_name)
VALUES ('4','Honda')
INSERT INTO brands(brand_id, brand_name)
VALUES ('5','Kawasaki')
INSERT INTO brands(brand_id, brand_name)
VALUES ('6','Piaggio')
INSERT INTO brands(brand_id, brand_name)
VALUES ('7','Suzuki')
INSERT INTO brands(brand_id, brand_name)
VALUES ('8','Yamaha')


INSERT INTO stocks(stock_id, vacant)
VALUES ('1','Y')
INSERT INTO stocks(stock_id, vacant)
VALUES ('2','Y')
INSERT INTO stocks(stock_id, vacant)
VALUES ('3','N')


INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('1', 'Ducati Multistrada 950 S', '2','1','1','2021','558000000','6')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('2', 'BMW R1200 GS Adventure', '1','1','1','2017','719000000','4')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('3', 'Harley-Davidson Sportster SuperLow', '3','2','2','2020','356000000','8')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('4', 'Kawasaki Vulcan S', '5','2','2','2021','241000000','11')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('5', 'Suzuki GSX-S1000', '7','3','2','2022','399000000','7')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('6', 'Vespa GTS 150', '6','4','2','2022','115000000','15')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('7', 'Yamaha NVX', '8','4','3','2020','52000000','19')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('8', 'Air Blade 125/160', '4','4','3','2022','42000000','24')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('9', 'Suzuki Hayabusa GSX 1300R', '7','5','1','2021','750000000','5')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('10', 'BMW S1000RR', '1','5','1','2020','949000000','2')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('11', 'Kawasaki ZX-10R', '5','5','1','2022','729000000','3')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('12', 'Harley-Davidson Road King', '3','7','1','2021','965000000','2')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('13', 'Honda GoldWing', '4','7','1','2021','1230000000','1')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('14', 'BMW K-1600 GTL', '1','6','1','2022','634000000','7')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('15', 'Kawasaki Concours', '5','6','2','2020','384000000','10')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('16', 'Yamaha Z125', '8','8','2','2017','270000000','9')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('17', 'Honda Winner X', '4','8','3','2022','50060000','20')
INSERT INTO products(product_id, product_name, brand_id, category_id, stock_id, model_year, price, inventory)
VALUES ('18', 'Suzuki Raider 150 FI', '7','8','3','2017','49190000','14')


INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('1', N'Nguyễn Thanh Vân', '0912151114','vannguyen@gmail.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('2', N'Lê Văn Tạo', '0954544154','taole@gmail.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('3', N'Đỗ Duy Trung', '0931184518','trungdo@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('4', N'Lê Minh Nguyệt', '0715166518','nguyetle@gmail.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('5', N'Nguyễn Kim Liên', '0961484123','liennguyen@gmail.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('6', N'Ngô Văn Sở', '0716151656','songo@gmail.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('7', N'Đinh Công Minh', '0921612161','minhdinh@gmail.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('8', N'Đặng Văn Tài', '0914653165','taidang@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('9', N'Trân Hạo Sơn', '0765164516','sonhao@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('10', N'Nguyễn Công Nghĩa', '0961646126','nghianguyen@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('11', N'Đỗ Tấn Tài', '0764151545','taido@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('12', N'Phạm Hoàng Long', '0961646546','longpham@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('13', N'Đặng Việt Trung', '0713216489','trungdang@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('14', N'Lê Công Minh', '0961618456','minhle@gmai.com')
INSERT INTO customers(customer_id, customer_name, phone, email)
VALUES ('15', N'Trần Hoài Sơn', '0754646465','sontran@gmai.com')


INSERT INTO stores(store_id, store_name, phone, email, store_address)
VALUES ('1', N'Dũng Sơn', '18006420','info@dungson.com', N'213 Tôn Đản, Phường 14, Quận 4, TP.HCM')
INSERT INTO stores(store_id, store_name, phone, email, store_address)
VALUES ('2', N'Phát Tài', '18004325','info@phattai.com', N'123 Nguyễn Văn Cừ, Phường 4, Quận 5, TP.HCM')
INSERT INTO stores(store_id, store_name, phone, email, store_address)
VALUES ('3', N'An Khang', '18007846','info@ankhang.com', N'442 Phạm Ngũ Lão, Phường Bến Nghé, Quận 1, TP.HCM')



INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('1', N'Đặng Công Thành', '1','1/1/1998', N'Nam', '0324546464', 'thanhdang@gmail.com', '8000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('2', N'Đỗ Phương Nghi', '2','12/21/1992', N'Nữ', '0334446485', 'nghido@gmail.com', '15000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('3', N'Đỗ Thị Thúy Vy', '3','4/3/1994', N'Nữ', '0346484838', 'vydo@gmail.com', '15000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('4', N'Nguyễn Hoàn Mỹ', '1','7/3/1991', N'Nữ', '0355484354', 'mynguyen@gmail.com', '15000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('5', N'Nguyễn Ngọc Hằng', '2','5/7/1999', N'Nữ', '0364464688', 'hangnguyen@gmail.com', '8000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('6', N'Bùi Minh Đạt ', '3','8/19/2000', N'Nam', '0375164845', 'datbui@gmail.com', '8000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('7', N'Võ Lê Khang', '1','3/24/2001', N'Nam', '0381654861', 'khangvo@gmail.com', '8000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('8', N'Đỗ Tuấn Cường', '2','11/30/1990', N'Nam', '0395465462', 'cuongdo@gmail.com', '8000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('9', N'Trần Hạo Long', '3','6/4/1997', N'Nam', '0354546548', 'longtran@gmail.com', '8000000')
INSERT INTO staffs(staff_id, staff_name, store_id, birthday, gender, phone, email, salary)
VALUES ('10', N'Phan Trung Tín', '2','7/2/1998', N'Nam', '0345134846', 'tinphan@gmail.com', '8000000')


INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('1', N'Đặng Việt Anh', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('2', N'Đỗ Phương Hoài', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('2', N'Lê Nhật Anh', N'Mẹ')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('3', N'Đỗ Trạng Nguyên', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('3', N'Phạm Thu Sương', N'Mẹ')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('4', N'Nguyễn Trung Hậu', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('4', N'Trần Huyền Trang', N'Mẹ')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('5', N'Lê Thị Mỹ Kim', N'Mẹ')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('6', N'Bùi Minh Trung', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('7', N'Võ Anh Tài', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('8', N'Nguyễn Thị Hồng', N'Mẹ')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('9', N'Trần Thanh Thiên', N'Cha')
INSERT INTO relatives(staff_id, relative_name, relationship)
VALUES ('10', N'Lê Mỹ Trúc', N'Mẹ')


INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('1', '4/5/2022', '1', '1')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('2', '5/12/2022', '2', '4')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('3', '6/15/2022', '4', '7')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('4', '4/18/2022', '3', '1')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('5', '5/14/2022', '6', '4')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('6', '6/23/2022', '7', '4')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('7', '4/30/2022', '5', '4')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('8', '5/1/2022', '4', '7')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('9', '6/14/2022', '6', '2')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('10', '4/15/2022', '7', '5')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('11', '5/19/2022', '8', '8')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('12', '6/7/2022', '9', '10')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('13', '4/4/2022', '10', '2')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('14', '5/4/2022', '12', '2')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('15', '6/9/2022', '15', '5')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('16', '4/30/2022', '13', '3')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('17', '5/31/2022', '14', '3')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('18', '6/22/2022', '8', '6')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('19', '4/3/2022', '14', '9')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('20', '5/7/2022', '11', '3')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('21', '6/1/2022', '8', '9')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('22', '4/9/2022', '13', '3')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('23', '5/18/2022', '9', '3')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('24', '6/27/2022', '11', '6')
INSERT INTO orders(order_id, order_date, customer_id, staff_id)
VALUES ('25', '4/29/2022', '4', '9')


INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('1', '1', '5', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('1', '2', '8', '3')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('2', '1', '1', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('3', '1', '7', '2')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('4', '1', '9', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('4', '2', '18', '3')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('5', '1', '2', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('5', '2', '14', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('6', '1', '17', '2')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('7', '1', '13', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('8', '1', '11', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('9', '1', '12', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('9', '2', '6', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('10', '1', '3', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('11', '1', '4', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('12', '1', '10', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('12', '2', '15', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('12', '3', '16', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('13', '1', '7', '2')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('13', '2', '18', '2')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('14', '1', '9', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('15', '1', '4', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('16', '1', '2', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('17', '1', '4', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('17', '2', '3', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('18', '1', '6', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('19', '1', '11', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('20', '1', '9', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('20', '2', '5', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('20', '3', '8', '2')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('21', '1', '1', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('22', '1', '16', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('23', '1', '17', '2')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('24', '1', '6', '1')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('25', '1', '8', '4')
INSERT INTO order_items(order_id, item_id, product_id, quantity)
VALUES ('25', '2', '18', '3')


UPDATE stores
SET manager_id = '4'
WHERE store_id = '1'

UPDATE stores
SET manager_id = '3'
WHERE store_id = '3'

UPDATE stores
SET manager_id = '2'
WHERE store_id = '2'

UPDATE staffs
SET manager_id = '2'
WHERE staff_id IN ('5','8','10')

UPDATE staffs
SET manager_id = '3'
WHERE staff_id IN ('6','9')

UPDATE staffs
SET manager_id = '4'
WHERE staff_id IN ('1', '7')


