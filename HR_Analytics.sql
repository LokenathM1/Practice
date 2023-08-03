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
SELECT
    location,
    Round((SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS Male,
    Round((SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END)/count(*)) * 100,1) As Female,
    Round((SUM(CASE WHEN gender = 'Non-Conforming' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS Rest,
COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    location;

-----------DEPARTMENT WITH REMOTE AND HEADQUARTER----------

SELECT
    department,
    Round((SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Headquarters',
    Round((SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Remote',
COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    department;

-----------EMPLOYEE WITH TERM ARE MOTSLY REMOTE OR HEADQUATER-----

SELECT location , COUNT(*)
FROM human_resources
WHERE termdate is not NULL
GROUP BY location;

SELECT department , COUNT(*) as Employee_Count
FROM human_resources
WHERE termdate is not NULL
GROUP BY department
ORDER BY Employee_Count desc;

SELECT
    department,
    Round((SUM(CASE WHEN termdate is NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Permanent',
     Round((SUM(CASE WHEN termdate is NOT NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Term',
COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    department;

-----------TERM WITH GENDER--------

SELECT
    gender,
    Round((SUM(CASE WHEN termdate is NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Permanent',
    Round((SUM(CASE WHEN termdate is NOT NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Term',
COUNT(*) AS Employee_Count
FROM human_resources
GROUP BY gender;

------location state with gender

SELECT
    location_state,
    Round((SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS Male,
    Round((SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END)/count(*)) * 100,1) As Female,
    Round((SUM(CASE WHEN gender = 'Non-Conforming' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS Rest,
COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    location_state;

-------------hiring yoy

SELECT
    department,
    EXTRACT(YEAR FROM hire_date) AS year,
    COUNT(*) AS hiring_count
FROM
    human_resources
GROUP BY
    department,
    EXTRACT(YEAR FROM hire_date)
ORDER BY
    department,
    EXTRACT(YEAR FROM hire_date);

SELECT department , COUNT(*)
FROM human_resources
WHERE ye





