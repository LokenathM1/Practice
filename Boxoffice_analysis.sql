/*converting date format 01-Jan-20(dd-mon-yy) to yyyy-mm-dd*/
UPDATE movie
SET release_date = DATE_FORMAT(STR_TO_DATE(release_date, '%d-%M-%y'), '%Y-%m-%d');
/*1. Show the list of movies released in 2020.*/

SELECT *
from movie
WHERE YEAR(release_date) = 2020;

/*2. List the top 5 movies which grossed the highest collections across all years.*/

SELECT m.movie_name, m.movie_genre ,m.movie_director ,m.movie_genre ,m.producer ,m.banner 
, round((c.movie_total + c.movie_total_worldwide),2) as Gross_Collection
from movie as m
JOIN commercials as c on c.movie_name = m.movie_name
GROUP BY c.movie_name
ORDER BY (c.movie_total + c.movie_total_worldwide) DESC
limit 5;

/*3. List the name of the producers who has produced comedy movies in 2019.*/
SELECT producer 
FROM movie
WHERE movie_genre = "Comedy" and year(release_date) = 2019;

/*4. Which movie in 2020 had the shortest duration?*/
SELECT *
from movie
ORDER BY runtime ASC
LIMIT 1;

/*5. List the movie with the highest opening weekend. Is this the same movie which had the highest overall collection? - "NO"*/
SELECT  m.movie_name, c.movie_weekend
from movie as m 
JOIN commercials as c USING(movie_name)
ORDER BY c.movie_weekend DESC
LIMIT 1;

/*6. List the movies which had the weekend collection same as the first week collection*/

SELECT m.movie_name , c.movie_firstweek as Same_Weekend_vs_1stWeek
FROM movie as m
join commercials as c USING(movie_name)
WHERE c.movie_weekend = c.movie_firstweek;


/*7. List the top 3 movies with the highest foreign collection.*/

SELECT m.movie_name as Movie ,m.movie_director as Director ,YEAR(release_date) as Year , c.movie_total_worldwide as Worldwide_Collection
FROM movie as m
JOIN commercials as c USING(movie_name)
ORDER BY c.movie_total_worldwide DESC
LIMIT 3;

/*8. List the movies that were released on a non-weekend day.(considering Monday as first day of the week)*/ 
select movie_name , DAYNAME(release_date)
FROM movie
WHERE WEEKDAY(release_date) NOT IN (5, 6);

/*9. List the movies by Reliance Entertainment which were non comedy.*/

SELECT * FROM movie
WHERE producer = "Reliance Entertainment" and movie_genre <> "Comedy";

/*10. List the movies produced in the month of October, November, and December that were released on the weekends.
(considering Monday as first day of the week)*/
SELECT movie_name, MONTHNAME(release_date), DAYNAME(release_date)
FROM movie
WHERE MONTH(release_date) IN (10,11,12) and WEEKDAY(release_date) IN (5, 6);
