/*2.Make a table with count of bookings with booking_type = p2p catgorized by 
booking mode as 'phone', 'online','app',etc*/

SELECT `Booking_type`,`Booking_mode`,COUNT(*) as Cnt
FROM `data`
WHERE `Booking_type` = 'p2p'
GROUP BY `Booking_mode`
ORDER BY Cnt desc;

--4.Find top 5 drop zones in terms of  average revenue

SELECT l.zone_id , ROUND(avg(d.`Fare`),2) as Avg_Rev
FROM `data` AS D 
INNER JOIN localities AS L on d.DropArea = l.Area
GROUP BY l.zone_id
ORDER BY Avg_Rev desc;

--5.Find all unique driver numbers grouped by top 5 pickzones

CREATE VIEW top5pickzones as (SELECT DISTINCT zone_id, COUNT(*) AS CNT
FROM `data` as d  
INNER JOIN localities AS l on d.`PickupArea` = l.`Area`
WHERE `Driver_number` is not NULL
GROUP BY zone_id
ORDER BY cnt desc
LIMIT 5);

SELECT DISTINCT zone_id , `Driver_number`
FROM `data` as d 
JOIN localities AS L  ON d.`PickupArea` = l.`Area`
WHERE zone_id IN (SELECT zone_id FROM top5pickzones)
ORDER BY zone_id , `Driver_number`;


/*7.Make a hourwise table of bookings for week between Nov01-Nov-07 and 
highlight the hours with more than average no.of bookings day wise*/

update `data`
set pickup_date = STR_TO_DATE(pickup_date,'%d-%m-%Y');

ALTER TABLE `data`
MODIFY pickup_date DATE;

UPDATE `data`
SET pickup_time = STR_TO_DATE(pickup_time,'%H:%i:%s');

ALTER TABLE `data`
MODIFY pickup_time TIME;

UPDATE `data`
SET pickup_datetime = STR_TO_DATE(pickup_datetime,'%d-%m-%Y %H:%i');

ALTER TABLE `data`
MODIFY pickup_datetime DATETIME;

SELECT HOUR(pickup_time),COUNT(*) as 
FROM `data`;

with cte as (
    SELECT HOUR(pickup_time) AS day_time, COUNT(*) as Cnt 
    FROM `data`
    WHERE pickup_date BETWEEN '2013-11-01' and '2013-11-07'
    GROUP BY HOUR(pickup_time)
    ORDER BY day_time), 
cte2 as (
    SELECT AVG(Dailybookings) as Avg_booking
    FROM (SELECT DAY(pickup_date),COUNT(*) as Dailybookings
    FROM `data` GROUP BY DAY(pickup_date)) AS tt)
SELECT * FROM CTE,CTE2
HAVING Cnt > Avg_booking;

