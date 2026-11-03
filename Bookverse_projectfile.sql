
CREATE DATABASE BookVerse_DB;
USE BookVerse_DB;
show tables;
USE BookVerse_DB;

-- 1. Create Books table
CREATE TABLE Books (
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(250) NOT NULL,
    Author VARCHAR(150) NOT NULL,
    Genre VARCHAR(80),
    Published_Year YEAR,
    Price DECIMAL(10,2),
    Stock INT
);

-- 2. Create Customers table
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(120),
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    City VARCHAR(100),
    Country VARCHAR(100)
);

-- 3. Create Orders table
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID)
        REFERENCES Customers(Customer_ID),

    FOREIGN KEY (Book_ID)
        REFERENCES Books(Book_ID)
);
SHOW TABLES;

USE BookVerse_DB;

SELECT COUNT(*) AS Books_Count FROM Books;
SELECT * FROM Books LIMIT 5;

SELECT COUNT(*) AS Total_Books FROM Books;
SELECT 
    MIN(Book_ID) AS First_ID,
    MAX(Book_ID) AS Last_ID,
    COUNT(DISTINCT Book_ID) AS Unique_IDs
FROM Books;


WITH RECURSIVE BookIDs AS (
    SELECT 1 AS Book_ID
    UNION ALL
    SELECT Book_ID + 1
    FROM BookIDs
    WHERE Book_ID < 500
)
SELECT b.Book_ID AS Missing_Book_ID
FROM BookIDs b
LEFT JOIN Books bk
    ON b.Book_ID = bk.Book_ID
WHERE bk.Book_ID IS NULL
ORDER BY b.Book_ID;

--- insserting missing

ALTER TABLE Books
MODIFY Published_Year SMALLINT;


INSERT INTO Books
(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
VALUES
(227, 'Centralized context-sensitive functionalities',
 'Virginia Levine', 'Non-Fiction', 1900, 38.17, 78),

(286, 'Sharable client-driven contingency',
 'Joseph Crawford', 'Non-Fiction', 1900, 8.29, 84),

(460, 'Optimized human-resource forecast',
 'Rachel Travis', 'Romance', 1900, 35.88, 39),

(485, 'Decentralized content-based access',
 'Nancy Taylor', 'Mystery', 1900, 23.16, 57);

SELECT COUNT(*) AS Books_Count
FROM Books;
SELECT COUNT(*) AS Customerss_Count
FROM Customers;
SELECT COUNT(*) AS Orders_Count
FROM Orders;

-- -- 1. Check for orders with invalid customer IDs
SELECT COUNT(*) AS Invalid_Customer_References
FROM Orders o
LEFT JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

-- 2. Check for orders with invalid book IDs
SELECT COUNT(*) AS Invalid_Book_References
FROM Orders o
LEFT JOIN Books b
    ON o.Book_ID = b.Book_ID
WHERE b.Book_ID IS NULL;

-- Check orders with invalid Book_ID
SELECT COUNT(*) AS Invalid_Book_References
FROM Orders o
LEFT JOIN Books b
    ON o.Book_ID = b.Book_ID
WHERE b.Book_ID IS NULL;

--  Check for duplicate order IDs
SELECT Order_ID, COUNT(*) AS ID_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;
-- missing values in  books table
SELECT
    'Books' AS Table_Name,
    SUM(Book_ID IS NULL) AS Missing_ID,
    SUM(Title IS NULL) AS Missing_Title,
    SUM(Author IS NULL) AS Missing_Author,
    SUM(Genre IS NULL) AS Missing_Genre,
    SUM(Published_Year IS NULL) AS Missing_Year,
    SUM(Price IS NULL) AS Missing_Price,
    SUM(Stock IS NULL) AS Missing_Stock
FROM Books;
-- missing values in  customers table
SELECT
    'Customers' AS Table_Name,
    SUM(Customer_ID IS NULL) AS Missing_ID,
    SUM(Name IS NULL) AS Missing_Name,
    SUM(Email IS NULL) AS Missing_Email,
    SUM(Phone IS NULL) AS Missing_Phone,
    SUM(City IS NULL) AS Missing_City,
    SUM(Country IS NULL) AS Missing_Country
FROM Customers;

SELECT
    'Orders' AS Table_Name,
    SUM(Order_ID IS NULL) AS Missing_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Book_ID IS NULL) AS Missing_Book_ID,
    SUM(Order_Date IS NULL) AS Missing_Date,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Total_Amount IS NULL) AS Missing_Amount
FROM Orders;
-- duplicate id's in books table
SELECT 'Books' AS Table_Name, COUNT(*) - COUNT(DISTINCT Book_ID) AS Duplicate_IDs
FROM Books;
-- duplicate id's in customer table
SELECT 'Customers' AS Table_Name, COUNT(*) - COUNT(DISTINCT Customer_ID) AS Duplicate_IDs
FROM Customers;
-- duplicate id's in orders table
SELECT 'Orders' AS Table_Name, COUNT(*) - COUNT(DISTINCT Order_ID) AS Duplicate_IDs
FROM Orders;

-- unique key
SELECT
    'Books' AS Table_Name,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Book_ID) AS Unique_IDs
FROM Books;

SELECT
    'Customers' AS Table_Name,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Customer_ID) AS Unique_IDs
FROM Customers;

SELECT
    'Orders' AS Table_Name,
    COUNT(*) AS Total_Records,
    COUNT(DISTINCT Order_ID) AS Unique_IDs
FROM Orders;


SELECT 'Books' AS Table_Name, COUNT(*) AS Total_Records
FROM Books

UNION ALL

SELECT 'Customers', COUNT(*)
FROM Customers

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders;

SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Published_Year,
    Price,
    Stock,
    COUNT(*) AS Occurrences
FROM Books
GROUP BY
    Book_ID,
    Title,
    Author,
    Genre,
    Published_Year,
    Price,
    Stock
HAVING COUNT(*) > 1;

SELECT
    Customer_ID,
    Name,
    Email,
    Phone,
    City,
    Country,
    COUNT(*) AS Occurrences
FROM Customers
GROUP BY
    Customer_ID,
    Name,
    Email,
    Phone,
    City,
    Country
HAVING COUNT(*) > 1;

SELECT
    Order_ID,
    Customer_ID,
    Book_ID,
    Order_Date,
    Quantity,
    Total_Amount,
    COUNT(*) AS Occurrences
FROM Orders
GROUP BY
    Order_ID,
    Customer_ID,
    Book_ID,
    Order_Date,
    Quantity,
    Total_Amount
HAVING COUNT(*) > 1;

-- stagging

CREATE TABLE Books_Staging LIKE Books;
SELECT COUNT(*) AS Staging_Books_Count
FROM Books_Staging;

SELECT COUNT(*) AS Mismatched_Books
FROM Books b
JOIN Books_Staging s
    ON b.Book_ID = s.Book_ID
WHERE
    NOT (b.Title <=> s.Title)
    OR NOT (b.Author <=> s.Author)
    OR NOT (b.Genre <=> s.Genre)
    OR NOT (b.Published_Year <=> s.Published_Year)
    OR NOT (b.Price <=> s.Price)
    OR NOT (b.Stock <=> s.Stock);
    
    USE BookVerse_DB;

CREATE TABLE Customers_Staging LIKE Customers;
SELECT COUNT(*) AS Staging_Customers_Count
FROM Customers_Staging;

SELECT COUNT(*) AS Mismatched_Customers
FROM Customers c
JOIN Customers_Staging s
    ON c.Customer_ID = s.Customer_ID
WHERE
    NOT (c.Name <=> s.Name)
    OR NOT (c.Email <=> s.Email)
    OR NOT (c.Phone <=> s.Phone)
    OR NOT (c.City <=> s.City)
    OR NOT (c.Country <=> s.Country);
    
    CREATE TABLE Orders_Staging LIKE Orders;
    SELECT COUNT(*) AS Staging_Orders_Count
FROM Orders_Staging;

SELECT COUNT(*) AS Mismatched_Orders
FROM Orders o
JOIN Orders_Staging s
    ON o.Order_ID = s.Order_ID
WHERE
    NOT (o.Customer_ID <=> s.Customer_ID)
    OR NOT (o.Book_ID <=> s.Book_ID)
    OR NOT (o.Order_Date <=> s.Order_Date)
    OR NOT (o.Quantity <=> s.Quantity)
    OR NOT (o.Total_Amount <=> s.Total_Amount);
    
    -- SPRINT 3
    SELECT COUNT(*) AS Total_Books
FROM Books;
-- What is the total number of customers?
SELECT COUNT(*) AS Total_Customers
FROM Customers;
-- What is the total number of orders?
SELECT COUNT(*) AS Total_Orders
FROM Orders;
-- Question 4: What are the different genres available?
SELECT DISTINCT Genre FROM Books
ORDER BY Genre;
-- What are the different countries represented in the customer data?
SELECT DISTINCT Country FROM Customers
ORDER BY Country;
-- COUNT 

SELECT COUNT(DISTINCT Country) AS Total_Countries
FROM Customers;

-- What is the total quantity of books sold?
SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM Orders;
-- What is the total revenue generated?

SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- What is the average order value?
SELECT AVG(Total_Amount) AS Average_Order_Value
FROM Orders;

-- SPRINT 4
-- How many orders have been placed?
SELECT COUNT(*) AS Total_Orders FROM Orders;
-- How many book copies have been sold in total?
SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM Orders;
-- What is the total revenue generated from all orders?
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;
-- Which books generate the highest revenue?
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Revenue DESC
LIMIT 10;
-- Which authors generate the highest revenue?
SELECT
    b.Author,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Which genres generate the highest revenue?
SELECT
    b.Genre,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Revenue DESC;

-- What is the monthly sales trend?
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity_Sold,
    SUM(Total_Amount) AS Total_Revenue
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Sales_Month;
-- What is the yearly sales trend?
SELECT
    YEAR(Order_Date) AS Sales_Year,
    COUNT(Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity_Sold,
    SUM(Total_Amount) AS Total_Revenue
FROM Orders
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Year;

-- Which books generate the highest revenue per unit?
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(o.Total_Amount) AS Total_Revenue,
    ROUND(
        SUM(o.Total_Amount) / SUM(o.Quantity), 2
    ) AS Revenue_Per_Unit
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Revenue_Per_Unit DESC
LIMIT 10;
-- Which books have sold the highest number of copies?
SELECT b.Title, SUM(o.Quantity) AS Copies_Sold
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Copies_Sold DESC
LIMIT 10;

-- 4.2 Understand Customer Purchasing Behaviour
-- How many orders has each customer placed?
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
LEFT JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Orders DESC;
-- What is the total purchase amount for each customer?
SELECT
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Spending DESC;
-- What is the average spending per customer?
SELECT
    ROUND(AVG(Customer_Spending), 2) AS Average_Customer_Spending
FROM (
    SELECT
        Customer_ID,
        SUM(Total_Amount) AS Customer_Spending
    FROM Orders
    GROUP BY Customer_ID
) AS CustomerTotals;

-- Who are the repeat customers?
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(o.Order_ID) > 1
ORDER BY Total_Orders DESC;
-- Which countries have the highest number of orders?
SELECT
    c.Country,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Total_Orders DESC;

-- Which countries generate the highest revenue?
SELECT
    c.Country,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Total_Revenue DESC
LIMIT 10;
-- Which customers purchase books across multiple genres?
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(DISTINCT b.Genre) AS Genres_Purchased
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(DISTINCT b.Genre) > 1
ORDER BY Genres_Purchased DESC;

SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
    COUNT(Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Active_Customers,
    SUM(Total_Amount) AS Total_Revenue
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Order_Month;
-- How does customer purchasing behaviour change over time?
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month,
    COUNT(Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Active_Customers,
    SUM(Total_Amount) AS Total_Revenue
FROM Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Order_Month;

-- 4.3 Understand Product and Genre Performance
SELECT
    b.Title,
    SUM(o.Quantity) AS Copies_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Copies_Sold DESC
LIMIT 10;
-- Which books generate the highest revenue?
SELECT
    b.Title,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Total_Revenue DESC
LIMIT 10;
-- Which genres have the highest quantity of books sold?
SELECT
    b.Genre,
    SUM(o.Quantity) AS Total_Copies_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Copies_Sold DESC;

-- Which genres generate the highest revenue?
SELECT
    b.Genre,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Total_Revenue DESC;

-- Which authors perform best in terms of sales and revenue?
SELECT
    b.Author,
    SUM(o.Quantity) AS Copies_Sold,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Which books have the highest prices?
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Price
FROM Books
ORDER BY Price DESC
LIMIT 10;
-- Which books have low sales?
SELECT
    b.Book_ID,
    b.Title,
    COALESCE(SUM(o.Quantity), 0) AS Copies_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Copies_Sold ASC
LIMIT 10;
-- Which books have never been ordered?
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL;
-- What is the relationship between book price and quantity sold?
SELECT
    b.Title,
    b.Price,
    COALESCE(SUM(o.Quantity), 0) AS Copies_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Price
ORDER BY b.Price DESC;

-- 4.4 Understand Inventory Position
-- What are the current stock levels of all books?
SELECT
    Book_ID,
    Title,
    Genre,
    Stock
FROM Books
ORDER BY Stock ASC;
-- Which books have low stock levels?
SELECT
    Book_ID,
    Title,
    Author,
    Stock
FROM Books
WHERE Stock < 10
ORDER BY Stock ASC;

-- How much stock is available in each genre?
SELECT
    Genre,
    SUM(Stock) AS Total_Stock
FROM Books
GROUP BY Genre
ORDER BY Total_Stock DESC;

-- What is the total inventory value by genre?
SELECT
    Genre,
    SUM(Price * Stock) AS Inventory_Value
FROM Books
GROUP BY Genre
ORDER BY Inventory_Value DESC;

-- Which authors have the highest inventory value?
SELECT
    b.Author,
    SUM(b.Price * b.Stock) AS Inventory_Value
FROM Books b
GROUP BY b.Author
ORDER BY Inventory_Value DESC
LIMIT 10;
-- Which authors have the highest inventory value?
SELECT
    b.Author,
    SUM(b.Price * b.Stock) AS Inventory_Value
FROM Books b
GROUP BY b.Author
ORDER BY Inventory_Value DESC
LIMIT 10;
-- Which books have the highest inventory value?
SELECT
    Book_ID,
    Title,
    Price,
    Stock,
    (Price * Stock) AS Inventory_Value
FROM Books
ORDER BY Inventory_Value DESC
LIMIT 10;
-- Which books have high stock but low sales?
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Copies_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING b.Stock > 50
   AND COALESCE(SUM(o.Quantity), 0) < 5
ORDER BY b.Stock DESC;
-- Which books have low stock and high sales?
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    SUM(o.Quantity) AS Copies_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING b.Stock < 10
   AND SUM(o.Quantity) > 5
ORDER BY Copies_Sold DESC;
-- Which books have never been ordered?
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    b.Price
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL
ORDER BY b.Stock DESC;

-- 4.5 Identify Sales and Inventory Opportunities
-- Which high-selling books have low stock?
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    SUM(o.Quantity) AS Copies_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING b.Stock < 10
   AND SUM(o.Quantity) > 5
ORDER BY Copies_Sold DESC;
-- Which books have high stock but low sales?
SELECT
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Copies_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Stock
HAVING b.Stock > 50
   AND COALESCE(SUM(o.Quantity), 0) < 5
ORDER BY b.Stock DESC;
-- Which popular genres have limited inventory?
SELECT
    b.Genre,
    SUM(o.Quantity) AS Copies_Sold,
    SUM(b.Stock) AS Current_Stock
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
HAVING SUM(o.Quantity) > 200
   AND SUM(b.Stock) < 200
ORDER BY Copies_Sold DESC;
--
SELECT
    b.Genre,
    SUM(o.Quantity) AS Copies_Sold,
    SUM(b.Stock) AS Current_Stock
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Copies_Sold DESC;
-- Who are the highest-value customers?
SELECT
    c.Customer_ID,
    c.Name,
    c.Country,
    SUM(o.Total_Amount) AS Total_Spending
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name,
    c.Country
ORDER BY Total_Spending DESC
LIMIT 10;
-- Which books demonstrate strong demand?
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    SUM(o.Quantity) AS Copies_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre
ORDER BY Copies_Sold DESC
LIMIT 10;
-- Which books have never been ordered?
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL
ORDER BY b.Title;
-- Which customers purchase across multiple genres?
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(DISTINCT b.Genre) AS Genres_Purchased
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(DISTINCT b.Genre) > 1
ORDER BY Genres_Purchased DESC;
-- Which products may require promotional attention?
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Copies_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock
HAVING COALESCE(SUM(o.Quantity), 0) < 3
ORDER BY b.Stock DESC;
-- Which products should be prioritized for replenishment?
SELECT
    b.Book_ID,
    b.Title,
    b.Genre,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Copies_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Genre,
    b.Stock
HAVING b.Stock < 10
   AND COALESCE(SUM(o.Quantity), 0) > 5
ORDER BY Copies_Sold DESC;