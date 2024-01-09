-- Tạo database:
-- CREATE DATABASE database_02_thanh;

-- Phân tích dữ liệu:
-- 1. Tạo các bảng: products, customers, orders, status
CREATE TABLE IF NOT EXISTS customers(
	id int NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(50) NOT NULL,
	email varchar(100) NOT NULL,
	phone varchar(12) NOT NULL,
	password varchar(100) NOT NULL,
	address TEXT,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
	CONSTRAINT customers_name_unique UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS products(
	id int NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(50) NOT NULL,
	product_code varchar(10) NOT NULL,
	detail varchar(100) NOT NULL,
	price float NOT NULL,
	total_quantity int NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
	CONSTRAINT products_name_unique UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS orders(
	id int NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_id int NOT NULL,
	product_id int NOT NULL,
	quantity int NOT NULL,
	status_id int NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS status(
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(30)  NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- 2. Các ràng buộc
-- 2.1 orders: customer_id -> id (customners)
ALTER TABLE orders 
ADD CONSTRAINT orders_customer_id_fk
FOREIGN KEY (customer_id) 
REFERENCES customers(id);

-- 2.2 orders: status_id -> id (status)
ALTER TABLE orders 
ADD CONSTRAINT orders_status_id_fk
FOREIGN KEY (status_id) 
REFERENCES status(id);

-- 2.2 orders: status_id -> id (products)
ALTER TABLE orders 
ADD CONSTRAINT orders_products_id_fk
FOREIGN KEY (product_id) 
REFERENCES products(id);

-- 3. Thêm dữ liệu test:
INSERT INTO customers(name, email, phone, password, address)
VALUES ('Nguyễn Văn A', 'nguyenvana@gmail.com','091234567','1234','Hà Nội'),
		('Nguyễn Văn B', 'nguyenvanb@gmail.com','091234568','1234','Hà Nội'),
		('Nguyễn Văn C', 'nguyenvanc@gmail.com','091234569','1234','Hà Nội');

INSERT INTO products(name, product_code, detail, price, total_quantity)
VALUES ('Nồi cơm Sunhouse','COOk01', 'Nồi cơm nội địa Sunhouse', 300, 123),
		('Bếp điện Via','BĐVI03', 'Bếp điện cao cấp Via', 500, 23),
		('Bàn là Vinahouse','BLVN02', 'Bàn là tiện lợi Vinahouse', 200, 125),
		('Tủ lạnh Samsung','TLSS01', 'Tủ lạnh hai cánh Samsung', 1500, 22);

INSERT INTO status(name)
VALUES ('Đang chờ đơn vị vận chuyển'), ('Đang vận chuyển'), ('Giao Thành công'), ('Đã hủy');

INSERT INTO orders(customer_id, product_id, quantity, status_id)
VALUES (1, 1, 2, 1), (1, 2, 1, 1), (2, 3, 1, 3), (3, 4, 1, 2), (3, 2, 2, 2);

-- 4: Xem  
-- 4.1.Xem danh sách đơn hàng:
-- Tên khách hàng
-- Email khách hàng
-- Số điện thoại khách hàng
-- Tổng số lượng sản phẩm
-- Tổng tiền đơn hàng
-- Trạng thái đơn hàng
-- Thời gian đặt hàng

SELECT customers.name, customers.email, customers.phone, SUM(orders.quantity) AS total_quantity, 
	SUM(products.price * orders.quantity) AS total_price, status.name AS status_orders, orders.created_at
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id
INNER JOIN products
ON products.id = orders.product_id
INNER JOIN status
ON orders.status_id = status.id
GROUP BY customers.name, customers.email, customers.phone, orders.quantity, 
	status_orders, orders.created_at;


-- 4.2: Xem chi tiết đơn hàng:
-- Tên khách hàng
-- Email khách hàng
-- Số điện thoại khách hàng
-- Danh sách sản phẩm trong đơn hàng: Tên, Mã sản phẩm, giá, số lượng, tổng tiền từng sản phẩm
-- Trạng thái đơn hàng
-- Thời gian tạo đơn hàng
-- Thời gian cập nhật cuối cùng

SELECT customers.name, customers.email, customers.phone, 
	products.name AS product_name, products.product_code, products.price AS product_price,
	orders.quantity as product_quantity, SUM(products.price * orders.quantity) AS total,
	status.name AS status_orders, orders.created_at, orders.updated_at
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id
INNER JOIN products
ON products.id = orders.product_id
INNER JOIN status
ON orders.status_id = status.id
GROUP BY customers.name, customers.email, customers.phone, orders.quantity, 
	product_name, products.product_code, product_price, product_quantity,
	status_orders, orders.created_at, orders.updated_at

		



