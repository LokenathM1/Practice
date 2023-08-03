

-------Cleaning-----
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

SELECT hire_date = case 
WHEN hire_date REGEXP '/' THEN STR_TO_DATE(hire_date,'%m/%d/%Y')
WHEN hire_date REGEXP '-' THEN STR_TO_DATE(hire_date,'%d-%m-%Y') END
FROM human_resources;

UPDATE hr_test
SET hire_date = 
  CASE
    WHEN hire_date REGEXP '/' THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
    WHEN hire_date  REGEXP '-' THEN STR_TO_DATE(hire_date, '%d-%m-%Y')
  END;

UPDATE human_resources
SET hire_date = 
  CASE
    WHEN hire_date LIKE "%/%" THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
    WHEN hire_date LIKE "%-%" THEN STR_TO_DATE(hire_date, '%d-%m-%Y')
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

---What is the average age of employees?
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

---What is the gender distribution of employees?

SELECT gender,CONCAT(
              ROUND(COUNT(*)/(SELECT count(*)FROM human_resources) * 100),'%') AS Gender_Distribution 
FROM human_resources
GROUP BY gender;

---Employee distribution across departments
SELECT department,CONCAT(
              ROUND((COUNT(*)/(SELECT count(*)FROM human_resources) * 100),1),'%') AS Employeee_Distribution 
FROM human_resources
GROUP BY department;

---Gender Distribution Across 

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


--What is the race distribution of employees?

SELECT race,CONCAT(
              ROUND(COUNT(*)/(SELECT count(*)FROM human_resources) * 100),'%') AS Race_Distribution 
FROM human_resources
GROUP BY race;

--What is the department with the most employees?

SELECT department, COUNT(*) as Employee_Count FROM human_resources
GROUP BY department
ORDER BY Employee_Count desc;

----What is the job title with the most employees?

SELECT jobtitle, COUNT(*) as Employee_Count FROM human_resources
GROUP BY jobtitle
ORDER BY Employee_Count desc;

----What is the location state with the most employees?

SELECT location_state, COUNT(*) as Employee_Count FROM human_resources
GROUP BY location_state
ORDER BY Employee_Count desc;

----Employee count from cities
SELECT location_city, COUNT(*) as Employee_Count FROM human_resources
WHERE location <> 'Headquarters'
GROUP BY location_city
ORDER BY Employee_Count desc;

---Remote employee count from each state
SELECT location_state, COUNT(*) as Employee_Count FROM human_resources
WHERE location <> 'Headquarters'
GROUP BY location_state
ORDER BY Employee_Count desc;


---Total Employee distribution remote vs onsite
SELECT location,(COUNT(*)/(SELECT COUNT(*) FROM human_resources)) * 100 FROM human_resources
GROUP BY location;

--Gender distribution of remote and on-site
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

--Department wise remote and on-site employee distribution

SELECT
    department,
    Round((SUM(CASE WHEN location = 'Headquarters' THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Headquarters',
    Round((SUM(CASE WHEN location = 'Remote' THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Remote',
COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    department;

--contractual employee distibution remote vs on-site

SELECT location , COUNT(*)
FROM human_resources
WHERE termdate is not NULL
GROUP BY location;

--Contractual employee across department

SELECT department , COUNT(*) as Employee_Count
FROM human_resources
WHERE termdate is not NULL
GROUP BY department
ORDER BY Employee_Count desc;

---contractual vs permanent employee distribution

SELECT
    Round((SUM(CASE WHEN termdate is NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Permanent',
     Round((SUM(CASE WHEN termdate is NOT NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Contractual',
COUNT(*) AS Employee_Count
FROM
    human_resources;

----contarctual vs permanet across departmetn ratio
SELECT
    department,
    Round((SUM(CASE WHEN termdate is NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Permanent',
     Round((SUM(CASE WHEN termdate is NOT NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Contractual',
COUNT(*) AS Employee_Count
FROM
    human_resources
GROUP BY
    department;

---Contractual vs Permanent Employee
SELECT
    gender,
    Round((SUM(CASE WHEN termdate is NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) As 'Permanent',
    Round((SUM(CASE WHEN termdate is NOT NULL THEN 1 ELSE 0 END)/count(*)) * 100,1) AS 'Contractual',
COUNT(*) AS Employee_Count
FROM human_resources
GROUP BY gender;

---Gender Distribution state wise

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

---Yearly Hiring Department wise

WITH cte AS (
    SELECT 
        department, 
        COUNT(*) AS `2020`
    FROM 
        human_resources
    WHERE 
        YEAR(hire_date) = (SELECT MAX(YEAR(hire_date)) FROM human_resources)
    GROUP BY 
        department
),
cte2 AS (
    SELECT 
        department, 
        COUNT(*) AS `2019`
    FROM 
        human_resources
    WHERE 
        YEAR(hire_date) = (SELECT MAX(YEAR(hire_date)) FROM human_resources) - 1 
    GROUP BY 
        department
),
cte3 AS (
    SELECT 
        department, 
        COUNT(*) AS `2018`
    FROM 
        human_resources
    WHERE 
        YEAR(hire_date) = (SELECT MAX(YEAR(hire_date)) FROM human_resources) - 2 
    GROUP BY 
        department
),
cte4 AS (
    SELECT 
        department, 
        COUNT(*) AS `2017`
    FROM 
        human_resources
    WHERE 
        YEAR(hire_date) = (SELECT MAX(YEAR(hire_date)) FROM human_resources) - 3 
    GROUP BY 
        department
)
SELECT cte.department,`2020`,`2019`,`2018`,`2017`
FROM 
    cte
    JOIN cte2 ON cte.department = cte2.department
    JOIN cte3 ON cte.department = cte3.department
    JOIN cte4 ON cte.department = cte4.department;




