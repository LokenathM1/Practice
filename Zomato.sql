
/*1) Help Zomato in identifying the cities with poor Restaurant ratings*/

WITH cte AS (
  SELECT
    `City`,
    ROUND(AVG(`Rating`), 1) AS Avg_rating,
    RANK() OVER (ORDER BY ROUND(AVG(`Rating`), 1) ASC) AS Avgrank
  FROM
    zomato
  WHERE
    `Votes` > 20
  GROUP BY
    `City`
)
SELECT
  `City`,
  Avg_rating
FROM
  cte
WHERE
  Avgrank < 5;



/*2) Mr.roy is looking for a restaurant in kolkata which provides online 
delivery. Help him choose the best restaurant*/

SELECT `Res_identify`,`Cuisines`,`Price_range`,`Votes`,`Rating`
FROM zomato
WHERE `City` = 'Kolkata' and `Has_Online_delivery` = 'YES'
ORDER BY `Rating` desc, `Votes` desc;

--3) Help Peter in finding the best rated Restraunt for Pizza in New Delhi.

SELECT `Res_identify`,`Cuisines`,`Price_range`,`Votes`,`Rating`
FROM zomato 
WHERE `City` = 'New Delhi' and `Cuisines` REGEXP 'Italian'
ORDER BY `Rating` DESC,`Votes` DESC, `Price_range`asc;

--4)Enlist most affordable and highly rated restaurants city wise.

WITH CTE AS (select `City`,`Res_identify`,`Cuisines`,`Price_range`,`Votes`,`Rating`,
        rank() OVER (PARTITION BY `City` ORDER BY `Price_range` ASC,`Rating` desc) AS rnk
FROM zomato)
SELECT `City`,`Res_identify`,`Cuisines`,`Price_range`,`Votes`,`Rating` FROM CTE 
WHERE `Rating` > 3.5 AND rnk <= 2 ;

SELECT `City`, `Res_identify`, `Rating`, `Price_range`
FROM (
  SELECT
    `City`,
    `Res_identify`,
    `Rating`,
    `Price_range`,
    RANK() OVER (PARTITION BY `City` ORDER BY `Price_range`, `Rating` DESC) AS rank_val_max_rating,
    RANK() OVER (PARTITION BY `City` ORDER BY `Price_range`, `Rating` ASC) AS rank_val_min_price
  FROM
    zomato
) AS ranked_restaurants
WHERE rank_val_max_rating = 1 AND rank_val_min_price = 1
ORDER BY `City`;



--5)Help Zomato in identifying the restaurants with poor offline services

SELECT `City`,`Res_identify`,`Cuisines`,`Price_range`,`Votes`,`Rating` FROM zomato 
WHERE `Has_Online_delivery` = 'No' and `Rating` <= 3.5
ORDER BY `Rating` asc;

/*6)Help zomato in identifying those cities which have atleast 3 restaurants with ratings >= 4.9
  In case there are two cities with the same result, sort them in alphabetical order.*/


SELECT City
FROM (
  SELECT
    City,
    COUNT(*) AS num_highly_rated_restaurants
  FROM
    zomato
  WHERE
    Rating >= 4.9
  GROUP BY
    City
) AS rated_cities
WHERE num_highly_rated_restaurants >= 3
ORDER BY num_highly_rated_restaurants DESC, City;

--7) What are the top 5 countries with most restaurants linked with Zomato?

WITH CTE AS (SELECT `Country`, RANK() OVER (ORDER BY COUNT(*) DESC) as Listing_Count_RNK
FROM zomato as z INNER JOIN countrytable as c USING(`CountryCode`)
GROUP BY `Country`)
SELECT `Country` FROM CTE  
WHERE Listing_Count_RNK <= 5;

--8) What is the average cost for two across all Zomato listed restaurants? 

SELECT ROUND(AVG(`Average_Cost_for_two`), 2) AS AverageCost
FROM zomato;


/*9) Group the restaurants basis the average cost for two into: 
Luxurious Expensive, Very Expensive, Expensive, High, Medium High, Average.
Then, find the number of restaurants in each category.*/

with cte as (SELECT `RestaurantID`,`Res_identify`, `Average_Cost_for_two`
	, 
	NTILE (6) OVER (
		ORDER BY `Average_Cost_for_two` desc
	) as buckets
FROM 
	zomato
WHERE `Average_Cost_for_two` <> 0),
cte2 as (SELECT *,CASE
    WHEN (BUCKETS) = 1 THEN 'Luxurious Expensive'
    WHEN (BUCKETS) = 2 THEN 'Very Expensive'
    WHEN (BUCKETS) = 3 THEN 'Expensive'
    WHEN (BUCKETS) = 4 THEN 'High'
    WHEN (BUCKETS) = 5 THEN 'Medium High'
    ELSE 'Average'
  END AS Cost_Category
FROM cte)
SELECT Cost_Category,COUNT(*)
FROM cte2
GROUP BY Cost_Category;

WITH CTE AS (SELECT `Res_identify`,
  CASE
    WHEN (`Average_Cost_for_two`) >= 10000 THEN 'Luxurious Expensive'
    WHEN (`Average_Cost_for_two`) >= 4000 THEN 'Very Expensive'
    WHEN (`Average_Cost_for_two`) >= 2000 THEN 'Expensive'
    WHEN (`Average_Cost_for_two`) >= 1000 THEN 'High'
    WHEN (`Average_Cost_for_two`) >= 500 THEN 'Medium High'
    ELSE 'Average'
  END AS Cost_Category
FROM
  zomato)
SELECT Cost_Category ,COUNT(*) AS Category_Count
FROM cte
GROUP BY Cost_Category
ORDER BY Category_Count desc;

--10) List the two top 5 restaurants with highest rating with maximum votes.

SELECT `Res_identify`, `Rating`, `Votes`
FROM (
  SELECT
    `Res_identify`,
    `Rating`,
    `Votes`,
    RANK() OVER (ORDER BY `Rating` DESC, `Votes` DESC) AS ranking
  FROM
    zomato
) AS ranked_restaurants
WHERE ranking <= 5
ORDER BY `Rating` DESC, `Votes` DESC;