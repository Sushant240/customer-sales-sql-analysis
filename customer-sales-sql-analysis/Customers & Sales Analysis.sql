CREATE DATABASE Customer_Sales_Analysis;
use Customer_Sales_Analysis;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES
(1,'Amit Sharma','Delhi','2022-01-15'),
(2,'Neha Verma','Mumbai','2022-02-10'),
(3,'Rahul Singh','Bangalore','2022-03-05'),
(4,'Priya Gupta','Delhi','2022-04-12'),
(5,'Arjun Mehta','Pune','2022-05-20'),
(6,'Sneha Patel','Ahmedabad','2022-06-18'),
(7,'Karan Kapoor','Mumbai','2022-07-22'),
(8,'Anjali Das','Kolkata','2022-08-14'),
(9,'Vikram Rao','Hyderabad','2022-09-09'),
(10,'Pooja Nair','Chennai','2022-10-30');


INSERT INTO Products VALUES
(101,'Laptop','Electronics',60000),
(102,'Smartphone','Electronics',30000),
(103,'Headphones','Electronics',2000),
(104,'Office Chair','Furniture',7000),
(105,'Desk','Furniture',12000),
(106,'Notebook','Stationery',50),
(107,'Pen Pack','Stationery',120),
(108,'Backpack','Accessories',1500),
(109,'Water Bottle','Accessories',500),
(110,'Tablet','Electronics',25000);


INSERT INTO Orders VALUES
(1001,1,101,'2023-01-05',1,60000),
(1002,2,102,'2023-01-07',1,30000),
(1003,3,103,'2023-01-10',2,4000),
(1004,1,106,'2023-02-02',5,250),
(1005,4,104,'2023-02-15',1,7000),
(1006,5,105,'2023-03-01',1,12000),
(1007,2,110,'2023-03-12',1,25000),
(1008,6,108,'2023-04-05',2,3000),
(1009,7,101,'2023-04-18',1,60000),
(1010,8,102,'2023-05-09',1,30000),
(1011,9,109,'2023-05-21',3,1500),
(1012,10,103,'2023-06-02',2,4000),
(1013,3,101,'2023-06-19',1,60000),
(1014,4,107,'2023-07-04',4,480),
(1015,5,108,'2023-07-25',1,1500),
(1016,6,102,'2023-08-11',1,30000),
(1017,7,105,'2023-08-28',1,12000),
(1018,8,104,'2023-09-06',1,7000),
(1019,9,110,'2023-09-17',1,25000),
(1020,10,101,'2023-10-03',1,60000);


-- Total Sales & Orders
SELECT 
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_sales
FROM Orders;

-- Monthly Sales Trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS monthly_sales
FROM Orders
GROUP BY month
ORDER BY month;

-- Top 5 Customers by Revenue
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS revenue
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 5;

-- Sales by Product Category
SELECT 
    p.category,
    SUM(o.total_amount) AS category_sales
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY category_sales DESC;

-- Repeat vs New Customers
SELECT 
    CASE 
        WHEN COUNT(order_id) = 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM Orders
GROUP BY customer_id;

-- Customers With Above-Average Spending (Subquery)
SELECT customer_id, SUM(total_amount) AS spending
FROM Orders
GROUP BY customer_id
HAVING spending > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM Orders
        GROUP BY customer_id
    ) avg_table
);

-- Rank Customers by Revenue (Window Function)
SELECT 
    c.customer_name,
    SUM(o.total_amount) AS revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS rank_position
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name;


