-- Active: 1686062442025@@127.0.0.1@3306@practice
ALTER TABLE `human_resources` 
RENAME COLUMN `ï»¿id` to `Id`;

DELETE FROM human_resources WHERE `Id` = '';

UPDATE human_resources
 SET termdate = STR_TO_DATE(LEFT(termdate,10),'%Y-%m-%d')
 WHERE termdate <> '';

UPDATE human_resources
 SET termdate = NULL
 WHERE termdate = '';

ALTER TABLE human_resources
MODIFY COLUMN termdate date;

SELECT case 
 when hire_date REGEXP '/' THEN hire_date =  STR_TO_DATE(hire_date,'%m/%d/%Y') END AS hire_date,
CASE 
 WHEN hire_date REGEXP '-' THEN hire_date =  STR_TO_DATE(hire_date,'%d-%m-%Y') END AS hire_date
FROM human_resources;

UPDATE human_resources
SET hire_date = 
  CASE
    WHEN hire_date REGEXP '/' THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
    WHEN hire_date REGEXP '-' THEN STR_TO_DATE(hire_date, '%d-%m-%Y')
    ELSE hire_date
  END;


UPDATE human_resources
Set hire_date =  STR_TO_DATE(hire_date,'%m/%d/%Y');

ALTER TABLE human_resources
MODIFY COLUMN hire_date date;

UPDATE human_resources
Set birthdate =  STR_TO_DATE(birthdate,'%m/%d/%Y');

ALTER TABLE human_resources
MODIFY COLUMN birthdate date;

--1. What is the average age of employees?
SELECT
    department,
    FLOOR(AVG(CASE WHEN gender = 'Male' THEN TIMESTAMPDIFF(YEAR, birthdate, CURRENT_DATE) END)) AS Avg_Male_Age,
    FLOOR(AVG(CASE WHEN gender = 'Female' THEN TIMESTAMPDIFF(YEAR, birthdate, CURRENT_DATE) END)) AS Avg_Female_Age,
    MAX(TIMESTAMPDIFF(YEAR, birthdate, CURRENT_DATE)) AS Max_Age,
    MIN(TIMESTAMPDIFF(YEAR, birthdate, CURRENT_DATE)) AS Min_Age
FROM
    human_resources
GROUP BY
    department;

--2. What is the gender distribution of employees?

SELECT gender,CONCAT(
              ROUND(COUNT(*)/(SELECT count(*)FROM human_resources) * 100),'%') AS Gender_Distribution 
FROM human_resources
GROUP BY gender;

--Department distribution
SELECT department,CONCAT(
              ROUND((COUNT(*)/(SELECT count(*)FROM human_resources) * 100),1),'%') AS Gender_Distribution 
FROM human_resources
GROUP BY department;

---------------Gender--------distribution across department----------------

SELECT
    department,
    Round((SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS Male,
    Round((SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END)/count(*)) * 100,1) As Female,
    Round((SUM(CASE WHEN gender = 'Non-Conforming' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS Rest,
    COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    department;


--3. What is the race distribution of employees?

SELECT race,CONCAT(
              ROUND(COUNT(*)/(SELECT count(*)FROM human_resources) * 100),'%') AS Race_Distribution 
FROM human_resources
GROUP BY race;

--4. What is the department with the most employees?

SELECT department, COUNT(*) as Employee_Count FROM human_resources
GROUP BY department
ORDER BY Employee_Count desc;

--5. What is the job title with the most employees?

SELECT jobtitle, COUNT(*) as Employee_Count FROM human_resources
GROUP BY jobtitle
ORDER BY Employee_Count desc;

--6. What is the location with the most employees?

SELECT location_state, COUNT(*) as Employee_Count FROM human_resources
GROUP BY location_state
ORDER BY Employee_Count desc;

SELECT location_city, COUNT(*) as Employee_Count FROM human_resources
WHERE location <> 'Headquarters'
GROUP BY location_city
ORDER BY Employee_Count desc;

SELECT location_state, COUNT(*) as Employee_Count FROM human_resources
WHERE location <> 'Headquarters'
GROUP BY location_state
ORDER BY Employee_Count desc;

SELECT location,(COUNT(*)/(SELECT COUNT(*) FROM human_resources)) * 100 FROM human_resources
GROUP BY location;

-----------GENDER WITH REMOTE / Headquarters---------------
-----------DEPARTMENT WITH REMOTE AND HEADQUARTER----------
-----------EMPLOYEE WITH TERM ARE MOTSLY REMOTE OR HEADQUATER-----
-----------TERM WITH GENDER--------
------------department with term worker------
---------------race with department
------location state with department
------location state with gender
-------------hiring yoy
--------------avg age hired  in years
-------department and yearly hires  


--7. What is the hire date with the most employees?
--8. What is the term date with the most employees?
--9. What is the location city with the most employees?
--10. What is the location state with the most employees?


