CREATE DATABASE dannys_dinner;

USE dannys_dinner;

CREATE TABLE sales ( 
  customer_id VARCHAR(1),
  order_date  DATE,
  product_id INTEGER);
  
  INSERT INTO sales ( customer_id, order_date, product_id)
  VALUES 
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

CREATE TABLE members(
  customer_id VARCHAR(1),
  join_date TIMESTAMP);

INSERT INTO members ( customer_id, join_date)
VALUES
('A', '2021-01-07'),
('B', '2021-01-09');


CREATE TABLE menu(
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER);
  
INSERT INTO menu(product_id, product_name, price)
VALUES
('1', 'sushi', '10'),
('2', 'curry', '15'),
('3', 'ramen', '12');

SELECT *
FROM members;

SELECT *
FROM menu;

SELECT *
FROM sales;

-- What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(price) as Amount_spent
FROM menu m
JOIN sales s
ON m.product_id = s.product_id
group by s.customer_id;

-- How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM sales
GROUP BY customer_id;

-- What was the first item from the menu purchased by each customer?
WITH Rankedsales AS (
    SELECT 
    s.customer_id, 
    s.order_date, m.product_name,
    row_number() OVER(partition by customer_id order by order_date) AS Ranking
    FROM sales s
    JOIN menu m
	ON s.product_id = m.product_id
    )
    
    SELECT 
	  Rankedsales.customer_id,
	  Rankedsales.product_name As first_item
	FROM 
      Rankedsales
	WHERE
      Rankedsales.Ranking = 1;
      
-- What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(s.product_id) AS purchased_item
FROM sales s 
JOIN menu m
ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchased_item DESC;

-- Which item was the most popular for each customer?

WITH RankedSales AS (
SELECT 
   s.customer_id,
   s.product_id,
   COUNT(*) AS purchase_count,
   ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS ranking
FROM
  sales s
GROUP BY
        s.customer_id,
        s.product_id
)
SELECT
    RankedSales.customer_id,
    menu.product_name AS most_popular_item
FROM
    RankedSales
INNER JOIN menu ON RankedSales.product_id = menu.product_id
WHERE
    RankedSales.ranking = 1;