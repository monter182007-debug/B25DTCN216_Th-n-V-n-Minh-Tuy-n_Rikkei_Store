-- Tao database
CREATE DATABASE RikkeiStore;
USE RikkeiStore;
-- Tao bang
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2),
    stock_quantity INT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_money DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_at_purchase DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) on update cascade,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) on update cascade
);

-- Chen du lieu
-- Chèn Category
INSERT INTO Categories (category_name) VALUES ('Electronics'), ('Home'), ('Fashion');

-- Chèn 5 Users
INSERT INTO Users (full_name, email) 
VALUES 
('Nguyen Van A', 'a@gmail.com'), 
('Tran Thi B', 'b@gmail.com'), 
('Le Van C', 'c@gmail.com'), 
('Pham Minh D', 'd@gmail.com'), 
('Hoang Lan E', 'e@gmail.com');

-- Chèn 5 Products
INSERT INTO Products (product_name, price, stock_quantity, category_id) 
VALUES 
('iPhone 15', 1000, 50, 1), 
('Laptop Dell', 1200, 20, 1), 
('Vacuum', 300, 15, 2), 
('T-Shirt', 20, 100, 3), 
('Sneaker', 80, 40, 3);

-- Chèn 5 Orders và Details (Dữ liệu liên kết)
INSERT INTO Orders (user_id, total_money) 
VALUES (1, 1000), (2, 1220), (3, 300), (1, 20), (4, 1080);
INSERT INTO Order_Details (order_id, product_id, quantity, price_at_purchase)
 VALUES 
(1, 1, 1, 1000), 
(2, 1, 1, 1000), 
(2, 4, 1, 20), 
(2, 5, 2, 80), 
(3, 3, 1, 300);

-- Truy van
-- 1
SELECT o.order_id, o.order_date, u.full_name, o.total_money 
FROM Orders o 
JOIN Users u ON o.user_id = u.user_id;

-- 2
SELECT * FROM Products 
WHERE category_id = (SELECT category_id FROM Categories WHERE category_name = 'Electronics');

-- 3
SELECT user_id, full_name, email FROM Users;

-- 4
SELECT SUM(total_money) AS total_system_revenue FROM Orders;

-- 5
SELECT p.product_id, p.product_name, SUM(od.quantity) AS total_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name;

-- 6
SELECT product_id, SUM(quantity) AS max_quantity
FROM Order_Details
GROUP BY product_id
ORDER BY max_quantity DESC
LIMIT 1;

-- 7
SELECT o.order_id, u.full_name, o.total_money, SUM(od.quantity) AS total_items
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY o.order_id, u.full_name, o.total_money;

-- 8
SELECT * FROM Products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Order_Details);

-- 9
SELECT u.user_id, u.full_name, COUNT(o.order_id) AS order_count
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name;

-- 10 
SELECT * FROM Products 
WHERE price > (SELECT AVG(price) FROM Products);

-- 11
SELECT u.full_name, SUM(o.total_money) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
HAVING SUM(o.total_money) > (
    SELECT AVG(user_total) FROM (SELECT SUM(total_money) AS user_total FROM Orders GROUP BY user_id) AS subquery
);

-- 12
 SELECT * FROM Orders ORDER BY total_money DESC LIMIT 1;
-- 13
SELECT c.category_name, SUM(od.quantity * od.price_at_purchase) AS revenue
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY c.category_id, c.category_name
ORDER BY revenue DESC
LIMIT 1;
-- 14 
SELECT product_id, SUM(quantity) AS total_sold
FROM Order_Details
GROUP BY product_id
ORDER BY total_sold DESC, product_id ASC
LIMIT 3;

-- 15
SELECT * FROM Users 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM Orders);
