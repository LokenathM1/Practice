/*1. What is the total amount each customer spent at the restaurant?*/

SELECT s.customer_ID , SUM(mu.price * s.product_id) as Amt_Spent
from sales as s 
JOIN menu as mu USING(product_id)
GROUP BY s.customer_id ;

/*2. How many days has each customer visited the restaurant?*/

select customer_id , COUNT(order_date) as Visit_Count
from sales
GROUP BY customer_id
order by Visit_Count desc;

/*3. What was the first item from the menu purchased by each customer?*/

with cte as 
(SELECT * , rank() over (PARTITION BY customer_id ORDER BY order_date) as purchase_rank  
FROM sales)
SELECT DISTINCT customer_id,product_id FROM cte 
WHERE purchase_rank = 1;


/*4. What is the most purchased item on the menu and how many times was it purchased by all customers?*/

select product_id , count(*) as Qty_Sold
FROM sales
GROUP BY product_id
ORDER BY Qty_Sold DESC
limit 1;

/*5. Which item was the most popular for each customer?*/

SELECT customer_id, product_id, COUNT(product_id) AS order_count
FROM sales
GROUP BY customer_id, product_id
HAVING COUNT(product_id) = (
    SELECT MAX(product_id)
    FROM (
        SELECT customer_id, product_id, COUNT(product_id) AS order_count
        FROM sales
        GROUP BY customer_id, product_id
    ) AS order_counts
    WHERE order_counts.customer_id = sales.customer_id
);


/*6. Which item was purchased first by the customer after they became a member?*/
with cte as 
(SELECT * , rank() over (PARTITION BY m.customer_id ORDER BY s.order_date) as purchase_rank
FROM members as m  
INNER JOIN sales as s USING(customer_id)
WHERE m.join_date < s.order_date)
SELECT customer_id,product_id FROM cte 
WHERE purchase_rank = 1 ;

/*7. Which item was purchased just before the customer became a member?*/

with cte as (
    select * , RANK() OVER (PARTITION BY m.customer_id ORDER BY s.order_date desc) as purchase_rank
FROM members as m 
INNER JOIN sales as s USING(customer_id)
WHERE m.join_date > s.order_date)
SELECT customer_id, product_id FROM cte
where purchase_rank = 1;


/*8. What is the total items and amount spent for each member before they became a member?*/

select s.customer_id, SUM(m.price) as Amt_Spent
FROM sales as S
INNER JOIN members as mb USING(customer_id)
INNER join menu as m USING(product_id)
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;


/*9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer   have?*/


WITH CTE AS (
    SELECT *,
        CASE
            WHEN m.product_name = 'sushi' THEN (m.price * 20)
            ELSE (m.price * 10)
        END AS Points
    FROM menu AS m
)
SELECT DISTINCT s.Customer_id, SUM(C.Points) OVER (PARTITION BY s.customer_id) AS Total_points
FROM sales AS s
INNER JOIN members AS mb USING(customer_id)
INNER JOIN CTE AS C USING(product_id)
WHERE order_date >= join_date;

--solution 2
WITH CTE AS (
    SELECT *,
        CASE
            WHEN m.product_name = 'sushi' THEN (m.price * 20)
            ELSE (m.price * 10)
        END AS Points
    FROM menu AS m
)
SELECT DISTINCT s.Customer_id, SUM(C.Points)  AS Total_points
FROM sales AS s
INNER JOIN members AS mb USING(customer_id)
INNER JOIN CTE AS C USING(product_id)
WHERE order_date >= join_date
GROUP BY S.customer_id;


--solution 3
SELECT s.Customer_id,
        sum(CASE
           WHEN product_name = 'sushi' THEN (price * 20)
           else price * 10
        End ) as Total_points
FROM sales AS s
INNER JOIN members AS mb USING(customer_id)
INNER JOIN menu as m USING(product_id)
WHERE order_date >= join_date
GROUP BY S.customer_id;


/*10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
 not just sushi - how many points do customer A and B have at the end of January?*/

WITH CTE AS (
    SELECT s.Customer_id,s.product_id,order_date,join_date,
        CASE
           WHEN order_date BETWEEN join_date and DATE_ADD(join_date, INTERVAL 6 DAY) THEN (price * 20)
           WHEN product_name = 'sushi' THEN (price * 20)
           else (price * 10)
        End As Points
    FROM menu as m JOIN sales AS S USING(product_id) JOIN members as mem USING(customer_id)
)
SELECT DISTINCT Customer_id, SUM(C.Points) OVER (PARTITION BY s.customer_id) AS Total_points
FROM CTE AS C
WHERE order_date >= join_date and MONTH(order_date) = 1;

--solution 2
SELECT s.Customer_id,
        sum(CASE
           WHEN order_date BETWEEN join_date and DATE_ADD(join_date, INTERVAL 6 DAY) THEN (price * 20)
           WHEN product_name = 'sushi' THEN (price * 20)
           else price * 10
        End ) as Total_points
FROM sales AS s
INNER JOIN members AS mb USING(customer_id)
INNER JOIN menu as m USING(product_id)
WHERE order_date >= join_date and MONTH(order_date) = 1
GROUP BY S.customer_id;
