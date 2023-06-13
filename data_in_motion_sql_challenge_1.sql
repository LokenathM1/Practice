--1) Which product has the highest price? Only return a single row.

SELECT *
FROM products
ORDER BY price DESC
LIMIT 1;

--2) Which customer has made the most orders?

SELECT c.customer_id, CONCAT(c.first_name," ",c.last_name) as Customer_name , COUNT(o.order_id) as Order_Count
FROM customers as c
JOIN orders as o USING(customer_id)
ORDER BY COUNT(o.order_id) DESC
LIMIT 1;

--3) What’s the total revenue per product?

SELECT product_id , product_name , SUM(p.price * oi.quantity) as Revenue
FROM products as p 
JOIN order_items as oi USING(product_id)
GROUP BY p.product_id
ORDER BY Revenue desc;

--4) Find the day with the highest revenue.
SELECT o.order_date , SUM(p.price * oi.quantity) as Revenue
FROM products as p 
JOIN order_items as oi USING(product_id)
JOIN orders as o USING(order_id)
GROUP BY o.order_date
ORDER BY Revenue desc
LIMIT 1;


--5) Find the first order (by date) for each customer.

SELECT c.customer_id ,CONCAT(c.first_name," ",c.last_name) as Name , MIN(o.order_date) AS first_order_date
FROM customers as c 
join orders as o USING(customer_id)
GROUP BY customer_id;


--6) Find the top 3 customers who have ordered the most distinct products
SELECT c.customer_id ,CONCAT(c.first_name," ",c.last_name) as Name, COUNT(DISTINCT oi.product_id) as Unique_ordered_product
FROM customers as c
JOIN orders as o USING(customer_id)
JOIN order_items as oi USING(order_id)
GROUP BY C.customer_id
ORDER BY Unique_ordered_product DESC
limit 3;

--7) Which product has been bought the least in terms of quantity?

SELECT p.product_id , p.product_name , sum(oi.quantity) as TotalQty
FROM products as p 
join order_items as oi USING(product_id)
GROUP BY oi.product_id
ORDER BY TotalQty asc
limit 7;


--8) What is the median order total?

--9) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

--10) Find customers who have ordered the product with the highest price.
