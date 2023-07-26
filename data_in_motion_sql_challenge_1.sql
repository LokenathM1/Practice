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

SELECT product_id , product_name , SUM(p.price * oi.quantity) as Total_Amt
FROM products as p 
JOIN order_items as oi USING(product_id)
GROUP BY p.product_id
ORDER BY Total_Amt desc;

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

with cte as(SELECT p.product_id , p.product_name , sum(oi.quantity) as TotalQty,
        rank() OVER (ORDER BY sum(oi.quantity) asc) as Qtyrnk
FROM products as p 
join order_items as oi USING(product_id)
GROUP BY oi.product_id
ORDER BY TotalQty asc)
SELECT product_id , product_name ,TotalQty FROM cte
WHERE Qtyrnk = 1;


--8) What is the median order total?

set @ROWNUM := 0;

WITH Odered_Total_Amt AS (
    SELECT i.order_id, SUM(i.quantity * p.price) AS Total_Amt
    FROM order_items AS i
    JOIN products AS p USING(product_id)
    GROUP BY i.order_id
)
SELECT ROUND(AVG(A.Total_Amt),2) AS median_of_order_total 
FROM (
    SELECT d.Total_Amt , @ROWNUM := @ROWNUM + 1 AS row_num
    FROM Odered_Total_Amt AS d
    WHERE Total_Amt IS NOT NULL
    ORDER BY Total_Amt
) AS A
WHERE A.row_num IN (FLOOR((@ROWNUM + 1) / 2), FLOOR((@ROWNUM + 2) / 2));

SELECT @ROWNUM;

--9) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

with cte as (SELECT oi.order_id, SUM(oi.quantity * p.price) AS Total_Amt
    FROM order_items AS oi
    JOIN products AS p USING(product_id)
    GROUP BY oi.order_id
    ORDER BY total_Amt)
SELECT order_id , Total_Amt,
       CASE 
        WHEN Total_Amt >= 300 THEN 'Expensive'
        WHEN Total_Amt BETWEEN 100 and 300 THEN 'Affordable'
        ELSE 'Cheap'
       END as Price_Category
FROM cte;


--10) Find customers who have ordered the product with the highest price.

SELECT customer_id,CONCAT(first_name,' ',last_name), product_id, price
FROM products as p
JOIN order_items AS oi USING(product_id)
JOIN orders as o USING(order_id)
JOIN customers as c USING(customer_id)
WHERE price = (SELECT MAX(price) FROM products);

