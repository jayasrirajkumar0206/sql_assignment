---create database:
CREATE DATABASE ecommerce;
USE ecommerce;

--create 4 tables:

CREATE TABLE gold_member_users (
    userid VARCHAR(20),
    signup_date DATE
);

CREATE TABLE users (
    userid VARCHAR(20),
    signup_date DATE
);

CREATE TABLE sales (
    userid VARCHAR(20),
    created_date DATE,
    product_id INT
);

CREATE TABLE product (
    product_id INT,
    product_name VARCHAR(20),
    price INT
);

--Insert Values

INSERT INTO gold_member_users VALUES
('John','2017-09-22'),
('Mary','2017-04-21');

INSERT INTO users VALUES
('John','2014-09-02'),
('Michel','2015-01-15'),
('Mary','2014-04-11');

INSERT INTO sales VALUES
('John','2017-04-19',2),('Mary','2019-12-18',1),('Michel','2020-07-20',3),
('John','2019-10-23',2),('John','2018-03-19',3),('Mary','2016-12-20',2),
('John','2016-11-09',1),('John','2016-05-20',3),('Michel','2017-09-24',1),
('John','2017-03-11',2),('John','2016-03-11',1),('Mary','2016-11-10',1),
('Mary','2017-12-07',2);

INSERT INTO product VALUES
(1,'Mobile',980),
(2,'Ipad',870),
(3,'Laptop',330);

--Show All Tables

SELECT * FROM gold_member_users;
SELECT * FROM users;
SELECT * FROM sales;
SELECT * FROM product;

-- Count Records of All Tables

SELECT 'gold_member_users' AS table_name, COUNT(*) AS total FROM gold_member_users
UNION ALL
SELECT 'users', COUNT(*) FROM users
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'product', COUNT(*) FROM product;

-- Total Amount Spent by Each Customer
SELECT s.userid, SUM(p.price) AS total_spent
FROM sales s
JOIN product p ON s.product_id = p.product_id
GROUP BY s.userid;

-- Distinct Visit Dates of Each Customer
SELECT DISTINCT created_date AS visit_date, userid
FROM sales;

--First Product Purchased by Each Customer
SELECT s.userid, p.product_name
FROM sales s
JOIN product p ON s.product_id = p.product_id
WHERE s.created_date = (
    SELECT MIN(created_date)
    FROM sales s2
    WHERE s2.userid = s.userid
);

--Most Purchased Item of Each Customer

SELECT userid, COUNT(*) AS item_count
FROM sales
GROUP BY userid;

--10. Customer Who Is NOT a Gold Member
SELECT u.userid
FROM users u
LEFT JOIN gold_member_users g
ON u.userid = g.userid
WHERE g.userid IS NULL;

--11. Amount Spent When Customer Was Gold Member
SELECT s.userid, SUM(p.price) AS amount_spent
FROM sales s
JOIN gold_member_users g ON s.userid = g.userid
JOIN product p ON s.product_id = p.product_id
WHERE s.created_date >= g.signup_date
GROUP BY s.userid
ORDER BY s.userid;

--12. Customers Whose Name Starts With M
SELECT * FROM users
WHERE userid LIKE 'M%';

--13. Distinct Customer IDs
SELECT DISTINCT userid FROM users;

--14. Rename Column price → price_value
EXEC sp_rename 'product.price', 'price_value', 'COLUMN';

--15. Update Product Name Ipad → Iphone
UPDATE product
SET product_name = 'Iphone'
WHERE product_name = 'Ipad';

--16. Rename Table gold_member_users
EXEC sp_rename 'gold_member_users', 'gold_membership_users';

--17. Add Status Column (Yes / No)
ALTER TABLE gold_membership_users
ADD status VARCHAR(5);

UPDATE gold_membership_users
SET status = 'Yes';

--18. Delete User IDs 1,2 and Rollback
BEGIN TRANSACTION;

DELETE FROM users WHERE userid = 'John';
DELETE FROM users WHERE userid = 'Mary';

ROLLBACK;


--19. Insert Duplicate Product Record
INSERT INTO product VALUES (3,'Laptop',330);


--20. Find Duplicate Records in Product Table
SELECT product_id, product_name, price_value, COUNT(*) AS duplicate_count
FROM product
GROUP BY product_id, product_name, price_value
HAVING COUNT(*) > 1;
