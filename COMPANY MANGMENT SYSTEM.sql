# Database Creation in MySQL
CREATE DATABASE company_db;
USE company_db;

#Table Creation

# Managers
CREATE TABLE Managers (
  Manager_ID INT PRIMARY KEY,
  Manager_Name VARCHAR(50),
  Department VARCHAR(30),
  Phone VARCHAR(15),
  Salary DECIMAL(10,2)
);

# Employees
CREATE TABLE Employees (
  Emp_ID INT PRIMARY KEY,
  Emp_Name VARCHAR(50),
  Position VARCHAR(30),
  Salary DECIMAL(10,2),
  Phone VARCHAR(15),
  Manager_ID INT,
  FOREIGN KEY (Manager_ID) REFERENCES Managers(Manager_ID)
);

# Products
CREATE TABLE Products (
  Prod_ID INT PRIMARY KEY,
  Prod_Name VARCHAR(50),
  Category VARCHAR(30),
  Price DECIMAL(10,2),
  Stock INT
);

# Customers
CREATE TABLE Customers (
  Cust_ID INT PRIMARY KEY,
  Cust_Name VARCHAR(50),
  City VARCHAR(30),
  Phone VARCHAR(15)
);

# Sales
CREATE TABLE Sales (
  Sale_ID INT PRIMARY KEY,
  Cust_ID INT,
  Emp_ID INT,
  Sale_Date DATE,
  Total_Amount DECIMAL(10,2),
  FOREIGN KEY (Cust_ID) REFERENCES Customers(Cust_ID),
  FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID)
);

# Sale_Details
CREATE TABLE Sale_Details (
  Sale_ID INT,
  Prod_ID INT,
  Quantity INT,
  Subtotal DECIMAL(10,2),
  FOREIGN KEY (Sale_ID) REFERENCES Sales(Sale_ID),
  FOREIGN KEY (Prod_ID) REFERENCES Products(Prod_ID)
);

# Insert Sample Data
-- Managers
INSERT INTO Managers VALUES
(1, 'Ali Khan', 'Sales', '9876543210', 85000.00),
(2, 'Sara Mehta', 'Production', '9876501234', 90000.00);

-- Employees
INSERT INTO Employees VALUES
(101, 'Ahmed Hassan', 'Sales Executive', 45000.00, '9000011111', 1),
(102, 'Fatima Noor', 'Sales Assistant', 35000.00, '9000022222', 1),
(103, 'Omar Rahman', 'Production Officer', 40000.00, '9000033333', 2);

-- Products
INSERT INTO Products VALUES
(201, 'Laptop', 'Electronics', 55000.00, 10),
(202, 'Mouse', 'Accessories', 500.00, 50),
(203, 'Keyboard', 'Accessories', 1000.00, 30);

-- Customers
INSERT INTO Customers VALUES
(301, 'John Smith', 'Delhi', '7000011111'),
(302, 'Priya Singh', 'Mumbai', '7000022222');

-- Sales
INSERT INTO Sales VALUES
(401, 301, 101, '2025-10-01', 56000.00),
(402, 302, 102, '2025-10-02', 1050.00);

-- Sale Details
INSERT INTO Sale_Details VALUES
(401, 201, 1, 55000.00),
(401, 202, 2, 1000.00),
(402, 203, 1, 1000.00),
(402, 202, 1, 50.00);

# Sample SQL Queries
# View employees with their managers
SELECT e.Emp_Name, e.Position, m.Manager_Name, m.Department
FROM Employees e
JOIN Managers m ON e.Manager_ID = m.Manager_ID;

# Total sales by each manager
SELECT m.Manager_Name, SUM(s.Total_Amount) AS Total_Sales
FROM Sales s
JOIN Employees e ON s.Emp_ID = e.Emp_ID
JOIN Managers m ON e.Manager_ID = m.Manager_ID
GROUP BY m.Manager_Name;

# Best-selling product
SELECT p.Prod_Name, SUM(sd.Quantity) AS Total_Sold
FROM Sale_Details sd
JOIN Products p ON sd.Prod_ID = p.Prod_ID
GROUP BY p.Prod_Name
ORDER BY Total_Sold DESC
LIMIT 1;

# Check Table Data Anytime
SELECT * FROM Managers;
SELECT * FROM Employees;
SELECT * FROM Products;
SELECT * FROM Customers;
SELECT * FROM Sales;
SELECT * FROM Sale_Details;

# PL/SQL Extensions (for PL/SQL Lab)
# Stored Procedure – Calculate Manager’s Total Sales
DELIMITER //
CREATE PROCEDURE GetManagerSales(IN managerId INT)
BEGIN
  SELECT m.Manager_Name, SUM(s.Total_Amount) AS Total_Sales
  FROM Sales s
  JOIN Employees e ON s.Emp_ID = e.Emp_ID
  JOIN Managers m ON e.Manager_ID = m.Manager_ID
  WHERE m.Manager_ID = managerId
  GROUP BY m.Manager_Name;
END //
DELIMITER ;
#Execute:
CALL GetManagerSales(1);

#Trigger – Update Stock After Sale

DELIMITER //
CREATE TRIGGER UpdateStockAfterSale
AFTER INSERT ON Sale_Details
FOR EACH ROW
BEGIN
  UPDATE Products
  SET Stock = Stock - NEW.Quantity
  WHERE Prod_ID = NEW.Prod_ID;
END //
DELIMITER ;



