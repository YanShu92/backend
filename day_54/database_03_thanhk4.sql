-- Tạo database:
-- CREATE DATABASE database_03_thanh;

-- Phân tích dữ liệu:
-- 1. Tạo các bảng: rooms, customers, orders, service_details, accompanied_services
CREATE TABLE IF NOT EXISTS customers(
	customer_code varchar(50) NOT NULL PRIMARY KEY,
	customer_name varchar(50) NOT NULL,
	address varchar(50) NOT NULL,
	phone varchar(12) NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS rooms(
	room_code varchar(50) NOT NULL PRIMARY KEY,
	room_type varchar(50) NOT NULL,
	room_price float NOT NULL,
	number_guests int NOT NULL,
	room_desc varchar(30) NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS orders(
	order_code varchar(50) NOT NULL PRIMARY KEY,
	customer_code varchar(50) NOT NULL,
	room_code varchar(50) NOT NULL,
	order_date date NOT NULL,
	start_time timetz NOT NULL,
	end_time timetz NOT NULL,
	deposit float NOT NULL,
	note varchar(30),
	status varchar(50) NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

CREATE TABLE IF NOT EXISTS service_details(
	order_code varchar(50) NOT NULL,
	service_code varchar(50) NOT NULL,
	service_quantity int  NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
	PRIMARY KEY (order_code, service_code)
);

CREATE TABLE IF NOT EXISTS accompanied_services(
	service_code varchar(50) NOT NULL PRIMARY KEY,
	service_name varchar(50) NOT NULL,
	service_unit varchar(10) NOT NULL,
	service_price float NOT NULL,
	created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
-- 2. Các ràng buộc
-- 2.1
ALTER TABLE orders 
ADD CONSTRAINT orders_customer_code_fk
FOREIGN KEY (customer_code) 
REFERENCES customers(customer_code);

-- 2.2 
ALTER TABLE orders 
ADD CONSTRAINT orders_room_code_fk
FOREIGN KEY (room_code) 
REFERENCES rooms(room_code);

-- 2.3
ALTER TABLE service_details 
ADD CONSTRAINT detail_order_code_fk
FOREIGN KEY (order_code) 
REFERENCES orders(order_code);

-- 2.4
ALTER TABLE service_details 
ADD CONSTRAINT detail_service_code_fk
FOREIGN KEY (service_code) 
REFERENCES accompanied_services(service_code);

-- 3. Thêm dữ liệu test:
INSERT INTO customers(customer_code, customer_name, address, phone)
VALUES ('KH0001','Nguyễn Văn A', 'Hoa Xuan', '091234567'),
		('KH0002','Nguyễn Văn B', 'Hoa Hai', '091123167'),
		('KH0003','Phạm Văn C', 'Cam Le', '011233667'),
		('KH0004','Hà Văn D', 'Hoa Xuan', '091111567');

INSERT INTO rooms(room_code, room_type, number_guests, room_price, room_desc)
VALUES ('P0001','Loại 1', 20, 60000, 'Room rất xịn'),
		('P0002','Loại 2', 25, 80000, 'Room xịn'),
		('P0003','Loại 3', 15, 50000, 'Room bình dân'),
		('P0004','Loại 4', 20, 50000, 'Room guest');

INSERT INTO orders(order_code, room_code, customer_code, order_date, start_time, end_time, deposit, status)
VALUES ('DP0001','P0001', 'KH0002', TO_DATE('01/01/2024','DD/MM/YYYY'), '19:00', '21:30', 100000, 'Da dat'),
		('DP0002','P0001', 'KH0003', TO_DATE('02/01/2024','DD/MM/YYYY'), '18:00', '23:30', 150000, 'Da huy'),
		('DP0003','P0002', 'KH0002', TO_DATE('04/01/2024','DD/MM/YYYY'), '19:00', '22:30', 100000, 'Da dat'),
		('DP0004','P0003', 'KH0001', TO_DATE('05/01/2024','DD/MM/YYYY'), '20:00', '22:30', 200000, 'Da dat');

INSERT INTO accompanied_services(service_code, service_name, service_unit, service_price)
VALUES ('DV001','Beer', 'lon', 10000),('DV002','Nước ngọt', 'lon', 8000),('DV003','Trái cây', 'đĩa', 40000),
		('DV004','Khăn ướt', 'cái', 2000);

INSERT INTO service_details(order_code, service_code, service_quantity)
VALUES ('DP0001','DV001', 20),('DP0001','DV003', 3),('DP0001','DV002', 10),('DP0002','DV002', 10),
		('DP0002','DV003', 1),('DP0003','DV003', 2),('DP0003','DV004', 10);
-- 4:  
-- 4.1
SELECT orders.order_code, rooms.room_code, rooms.room_type, rooms.room_price, 
		customers.customer_code, orders.order_date, money_sing, 
		CASE 
			WHEN money_service IS NULL THEN 0
			ELSE money_service
		END,
		(money_sing + 
		 CASE 
			WHEN money_service IS NULL THEN 0
			ELSE money_service
		 END
		) as total
FROM orders
INNER JOIN customers
ON customers.customer_code = orders.customer_code
INNER JOIN rooms
ON rooms.room_code = orders.room_code
INNER JOIN
(	
	-- Bảng tạm tính tiền hát
	SELECT orders.order_code, rooms.room_code, rooms.room_price,
		rooms.room_price * 
		 (
			 EXTRACT(HOUR FROM orders.end_time) + EXTRACT(MINUTE FROM orders.end_time) / 60 
			 - EXTRACT(HOUR FROM orders.start_time) - EXTRACT(MINUTE FROM orders.start_time) / 60
		 ) AS money_sing		
	FROM rooms
	INNER JOIN orders
	ON rooms.room_code = orders.room_code	
) AS sing_money
ON sing_money.order_code = orders.order_code
LEFT JOIN 
(
	-- Bảng tạm tính tiền dịch vụ
	SELECT service_details.order_code, 
		SUM(service_details.service_quantity * accompanied_services.service_price) 
		AS money_service
	FROM service_details
	LEFT JOIN accompanied_services
	ON accompanied_services.service_code = service_details.service_code
	GROUP BY service_details.order_code
) AS service_money
ON service_money.order_code = orders.order_code;

-- 4.2
SELECT customers.customer_code, customers.customer_name, customers.address, customers.phone
FROM customers
INNER JOIN orders
ON orders.customer_code = customers.customer_code
GROUP BY customers.customer_code
HAVING LOWER(customers.address) LIKE LOWER('%Hoa xuan%');

--4.3
SELECT rooms.room_code, rooms.room_type, rooms.number_guests, rooms.room_price, 
		COUNT(orders.room_code) as number_orders
FROM rooms
INNER JOIN orders
ON rooms.room_code = orders.room_code
GROUP BY orders.room_code, rooms.room_code, rooms.room_type, rooms.number_guests, rooms.room_price, orders.status
HAVING orders.status = 'Da dat' AND COUNT(orders.room_code) > 2;





