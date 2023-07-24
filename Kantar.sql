
--1) How to identify the Records (Order ID + Product ID combination) present in data1 but missing in data2 
--(Specify the number of records missing in your answer)
SELECT COUNT(*)
FROM data1 as d1 
left JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d2.`Order ID` IS NULL ; 

SELECT d1.`Order ID`,d1.`Product ID`
FROM data1 as d1 
left JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d2.`Order ID` IS NULL
ORDER BY d1.`Order ID`;

SELECT d1.`Order ID`,d1.`Product ID`
FROM data1 as d1 
left JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d2.`Order ID` IS NULL
ORDER BY d1.`Product ID`;

SELECT `Order ID`, `Product ID`, `Qty`
FROM data1
EXCEPT
SELECT `Order ID`, `Product ID`, `Qty`
FROM data2;

SELECT COUNT(*) AS missing_records
FROM (
    SELECT `Order ID`, `Product ID`, `Qty`
    FROM data1
    EXCEPT
    SELECT `Order ID`, `Product ID`, `Qty`
    FROM data2
) AS subquery;


--2) How to identify the Records (Order ID + Product ID combination) missing in data1 but present in data2 
--(Specify the number of records missing in your answer)

SELECT COUNT(*)
FROM data1 AS d1
RIGHT JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d1.`Order ID` is NULL;

SELECT d2.`Order ID`,d2.`Product ID`
FROM data1 AS d1
RIGHT JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d1.`Order ID` is NULL
ORDER BY d2.`Order ID`;

SELECT `Order ID`, `Product ID`, `Qty`
FROM data2
EXCEPT
SELECT `Order ID`, `Product ID`, `Qty`
FROM data1;

SELECT COUNT(*) Missing_records 
FROM (
    SELECT `Order ID`, `Product ID`, `Qty`
    FROM data2
    EXCEPT
    SELECT `Order ID`, `Product ID`, `Qty`
    FROM data1
    ) AS subquery;

--3) Find the Sum of the total Qty of Records missing in data1 but present in data2

SELECT sum(d2.qty)
FROM data1 AS d1
RIGHT JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d1.`Order ID` is NULL;

SELECT sum(`Qty`) 
FROM (
    SELECT `Order ID`, `Product ID`, `Qty` FROM data2
    EXCEPT 
    SELECT `Order ID`, `Product ID`, `Qty` FROM data1
) as subquery;

--4) Find the total number of unique records 
--(Order ID + Product ID combination) present in the combined dataset of data1 and data2

(SELECT d1.`Order ID`,d1.`Product ID`
FROM data1 as d1 
left JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d2.`Order ID` IS NULL
ORDER BY d1.`Order ID`)
UNION
(SELECT d2.`Order ID`,d2.`Product ID`
FROM data1 AS d1
RIGHT JOIN data2 as d2 USING(`Order ID`,`Product ID`)
WHERE d1.`Order ID` is NULL
ORDER BY d2.`Order ID`);
