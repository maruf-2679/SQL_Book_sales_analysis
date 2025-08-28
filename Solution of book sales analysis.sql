Create database online_bookstore;

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
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--1) Retrieve all books in the "Fiction" genre
select * 
from books
where genre ='Fiction';

-- 2) Find books published after the year 1950
select * 
from books
where published_year > 1950;

--3) List all customers from the Canada
select *
from customers
where country = 'Canada';

-- 4) Show orders placed in November 2023
select  *
from orders
where extract(year from order_date)= 2023 and extract(month from order_date)= 11 ;

--5) Retrieve the total stock of books available
select sum(stock) as Total_stock
from books;

-- 6) Find the details of the most expensive book
select * 
from books
order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
select * from customers
where customer_id in 
(select customer_id
from orders
group by customer_id
having sum(quantity)>1)

-- 8) Retrieve all orders where the total amount exceeds $20
select *
from orders
where total_amount >20;

-- 9) List all genres available in the Books table
select distinct genre
from books;

-- 10) Find the book with the lowest stock
select * 
from books
order by stock asc
limit 1;

-- 11) Calculate the total revenue generated from all orders
select sum(total_amount) as total_revenue_generated
from orders;


--Advance Queries

-- 1) Retrieve the total number of books sold for each genre
select b.genre , sum(o.quantity) as Number_of_books_sold
from books as b
inner join orders as o
on b.book_id=o.book_id
group by b.genre;

--2) Find the average price of books in the "Fantasy" genre
select trunc(avg(price),2) as average_prince
from books
where genre='Fantasy'

-- 3) List customers who have placed at least 2 orders
select * from customers
where customer_id in 
(select customer_id
from orders
group by customer_id
having count(order_id)>1)

-- 4) Find the most frequently ordered book
select * from orders;
select book_id,count(book_id) as most_frequent
from orders
group by book_id
order by most_frequent desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre 
select *
from books
where genre='Fantasy'
order by price desc
limit 3;

--6) Retrieve the total quantity of books sold by each author
select b.author , sum(o.quantity) as books_sold
from books as b
join orders as o
on b.book_id=o.book_id
group by b.author;

-- 7) List the cities where customers who spent over $30 are located
select city 
from customers as c
join orders as o
on c.customer_id=o.customer_id
where o.total_amount > 30;

 --8) Find the customer who spent the most on orders
 select c.customer_id, c.name , sum(o.total_amount) as total_amount
 from customers as c
 join orders as o
 on c.customer_id=o.customer_id
 group by c.customer_id
 order by total_amount desc
 limit 1;

 -- 9) Calculate the stock remaining after fulfilling all orders
 
select b.book_id,b.title , b.stock , coalesce(sum(o.quantity),0) as order_quantity ,
(b.stock-coalesce(sum(o.quantity),0)) as remaining_quantity
from books as b
left join orders as o
on b.book_id=o.book_id
group by b.book_id
