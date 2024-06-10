CREATE DATABASE BikeStore;

-- Production Tables

CREATE TABLE categories(
category_id INT PRIMARY KEY AUTO_INCREMENT, 
category_name VARCHAR(20)
);

CREATE TABLE products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name TEXT,
    brand_id INT,
    category_id INT, 
    model_year YEAR,
    list_price DECIMAL(7,2),
    FOREIGN KEY(brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY(category_id) REFERENCES categories(category_id)
);

CREATE TABLE stocks(
	store_id INT,
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    quantity INT,
    FOREIGN KEY(product_id) REFERENCES products(product_id),
    FOREIGN KEY(store_id) REFERENCES stores(store_id)
);

CREATE TABLE brands (
	brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(30)
);

-- Sales Tables 

CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(50) UNIQUE,
    street VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(5) 
);

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_status SMALLINT,
    order_date DATE, 
    required_date DATE,
    shipped_date DATE, 
    store_id INT,
    staff_id INT, 
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(store_id) REFERENCES stores(store_id),
    FOREIGN KEY(staff_id) REFERENCES staffs(staff_id)
);


CREATE TABLE staffs(
	staff_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    active INT, 
    store_id INT, 
    manager_id INT,
    FOREIGN KEY(store_id) REFERENCES stores(store_id)
);

CREATE TABLE order_items(
	order_id INT, 
    item_id INT, 
    product_id INT, 
    quantity INT, 
    list_price DECIMAL(7, 2),
    discount DECIMAL(2, 2),
    PRIMARY KEY(order_id, item_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

CREATE TABLE stores(
	store_id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(20) UNIQUE,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(50) UNIQUE,
    street VARCHAR(40),
    city VARCHAR(30),
    state VARCHAR(40), 
    zip_code VARCHAR(10)
);


SELECT CONCAT(first_name, " ", last_name) as Name, order_date, shipped_date
FROM customers
INNER JOIN 
orders
ON customers.customer_id = orders.customer_id
ORDER BY order_date;

SELECT * FROM order_items;

-- let's try to find the staff that have executed the most orders

SELECT CONCAT(s.first_name, " ", s.last_name) AS Name, o.staff_id, COUNT(o.staff_id) AS "Orders Executed" 
FROM staffs s
INNER JOIN
orders o
ON o.staff_id = s.staff_id
GROUP BY o.staff_id
ORDER BY COUNT(o.staff_id) DESC;

-- So we can Venita Daniel and Marcelene Boyer have executed the most orders with 553 and 540 respectively. 

-- let's try to find the store with the most orders

SELECT s.store_name AS "Store Name", o.store_id AS "Store ID", COUNT(o.store_id) AS "Total Orders"
FROM stores s
INNER JOIN 
orders o
ON s.store_id = o.store_id
GROUP BY o.store_id
ORDER BY COUNT(o.store_id) DESC;


-- We can make views out of these

CREATE VIEW staff_view AS
SELECT CONCAT(s.first_name, " ", s.last_name) AS Name, o.staff_id, COUNT(o.staff_id) AS "Orders Executed" 
FROM staffs s
INNER JOIN
orders o
ON o.staff_id = s.staff_id
GROUP BY o.staff_id
ORDER BY COUNT(o.staff_id) DESC;

CREATE VIEW store_view AS
SELECT s.store_name AS "Store Name", o.store_id AS "Store ID", COUNT(o.store_id) AS "Total Orders"
FROM stores s
INNER JOIN 
orders o
ON s.store_id = o.store_id
GROUP BY o.store_id
ORDER BY COUNT(o.store_id) DESC;

-- We can now see the view 

SELECT * FROM store_view;

SELECT * FROM staff_view;

-- Next we can try to query the busiest months

SELECT COUNT(order_id) AS "Total Completed Orders", DATE_FORMAT(order_date, "%M") AS month
FROM orders
WHERE order_status != 3 -- not including rejected orders
GROUP BY month
ORDER BY COUNT(order_id) DESC;

CREATE VIEW date_view AS
SELECT COUNT(order_id) AS "Total Completed Orders", DATE_FORMAT(order_date, "%M") AS month
FROM orders
WHERE order_status != 3 -- not including rejected orders
GROUP BY month
ORDER BY COUNT(order_id) DESC;

SELECT * FROM order_items;
SELECT * FROM products;

-- The Next task is to find the most sold products

SELECT p.product_name AS "Product Name", o.list_price AS "List Price", SUM(o.quantity) AS "Total Quantity Sold", ROUND(SUM(o.list_price*o.quantity*(1-o.discount)), 2) AS "Total Amount Sold"
FROM order_items o 
INNER JOIN
products p 
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY SUM(o.list_price*o.quantity) DESC
LIMIT 10;

-- The following query finds the most sold bike categories

SELECT c.category_name AS "Category Name", ROUND(SUM(o.list_price*(1-o.discount)),2) AS "Total Price", SUM(o.quantity) AS "Total Quantity Sold", ROUND(SUM(o.list_price*o.quantity*(1-o.discount)), 2) AS "Total Amount Sold"
FROM order_items o 
INNER JOIN
products p 
ON o.product_id = p.product_id
INNER JOIN categories c
ON p.category_id = c.category_id
GROUP BY p.category_id
ORDER BY ROUND(SUM(o.list_price*o.quantity*(1-o.discount)),2) DESC;


-- The following query finds the most sold brands

SELECT b.brand_name AS "Brand Name", ROUND(SUM(o.list_price*(1-o.discount)),2) AS "Total Price", SUM(o.quantity) AS "Total Quantity Sold", ROUND(SUM(o.list_price*o.quantity*(1-o.discount)), 2) AS "Total Amount Sold"
FROM order_items o 
INNER JOIN
products p 
ON o.product_id = p.product_id
INNER JOIN 
brands b
ON b.brand_id = p.brand_id
GROUP BY p.brand_id
ORDER BY SUM(o.list_price*o.quantity) DESC;

-- Brand View

CREATE VIEW brand_view AS 
SELECT b.brand_name AS "Brand Name", ROUND(SUM(o.list_price*(1-o.discount)),2) AS "Total Price", SUM(o.quantity) AS "Total Quantity Sold", ROUND(SUM(o.list_price*o.quantity*(1-o.discount)), 2) AS "Total Amount Sold"
FROM order_items o 
INNER JOIN
products p 
ON o.product_id = p.product_id
INNER JOIN 
brands b
ON b.brand_id = p.brand_id
GROUP BY p.brand_id
ORDER BY SUM(o.list_price*o.quantity) DESC;

-- Category View 

CREATE VIEW cat_view AS
SELECT c.category_name AS "Category Name", ROUND(SUM(o.list_price*(1-o.discount)),2) AS "Total Price", SUM(o.quantity) AS "Total Quantity Sold", ROUND(SUM(o.list_price*o.quantity*(1-o.discount)), 2) AS "Total Amount Sold"
FROM order_items o 
INNER JOIN
products p 
ON o.product_id = p.product_id
INNER JOIN categories c
ON p.category_id = c.category_id
GROUP BY p.category_id
ORDER BY ROUND(SUM(o.list_price*o.quantity*(1-o.discount)),2) DESC;

-- Product View 

CREATE VIEW product_view AS 
SELECT p.product_name AS "Product Name", o.list_price AS "List Price", SUM(o.quantity) AS "Total Quantity Sold", ROUND(SUM(o.list_price*o.quantity*(1-o.discount)), 2) AS "Total Amount Sold"
FROM order_items o 
INNER JOIN
products p 
ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY SUM(o.list_price*o.quantity) DESC
LIMIT 10;

-- To this end we will visualise this data in MS PowerBI.