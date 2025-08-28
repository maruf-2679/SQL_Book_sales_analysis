# SQL_Book_sales_analysis
# 📚 Online Bookstore SQL Project

This project demonstrates how to design a relational database for an **online bookstore** and analyze sales, customers, and inventory using **PostgreSQL**.

## 🗄️ Database Schema

```sql
CREATE DATABASE online_bookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

##Basic queries
-- 1) Retrieve all books in the "Fiction" genre
SELECT * 
FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950
SELECT * 
FROM Books
WHERE Published_Year > 1950;

-- 3) List all customers from Canada
SELECT *
FROM Customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT *
FROM Orders
WHERE EXTRACT(YEAR FROM Order_Date) = 2023 
  AND EXTRACT(MONTH FROM Order_Date) = 11;

-- 5) Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6) Find the details of the most expensive book
SELECT * 
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT * 
FROM Customers
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM Orders
    GROUP BY Customer_ID
    HAVING SUM(Quantity) > 1
);

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT *
FROM Orders
WHERE Total_Amount > 20;

-- 9) List all genres available in the Books table
SELECT DISTINCT Genre
FROM Books;

-- 10) Find the book with the lowest stock
SELECT * 
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders
SELECT SUM(Total_Amount) AS Total_Revenue_Generated
FROM Orders;

## Advance queries
-- 1) Retrieve the total number of books sold for each genre
SELECT b.Genre, SUM(o.Quantity) AS Number_of_Books_Sold
FROM Books b
INNER JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre
SELECT TRUNC(AVG(Price), 2) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders
SELECT * 
FROM Customers
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM Orders
    GROUP BY Customer_ID
    HAVING COUNT(Order_ID) > 1
);

-- 4) Find the most frequently ordered book
SELECT Book_ID, COUNT(Book_ID) AS Most_Frequent
FROM Orders
GROUP BY Book_ID
ORDER BY Most_Frequent DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' genre 
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Books_Sold
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.City
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount > 30;

-- 8) Find the customer who spent the most on orders
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Amount
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Total_Amount DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID, b.Title, b.Stock, 
       COALESCE(SUM(o.Quantity), 0) AS Order_Quantity,
       (b.Stock - COALESCE(SUM(o.Quantity), 0)) AS Remaining_Quantity
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID;

Key Learnings

--Designed and implemented a relational database schema with 3 linked tables (Books, Customers, Orders).

--Practiced basic to advanced SQL queries including joins, aggregations, filtering, and subqueries.

--Extracted insights such as total revenue, best customers, most popular books, and inventory status.
