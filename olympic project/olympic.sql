-- create table --
-- table athlete_event
DROP TABLE IF EXISTS athlete_event;
CREATE TABLE IF NOT EXISTS athlete_event 
(   ID INT,
	Name VARCHAR,
	Sex VARCHAR,
	Age VARCHAR,
	Height VARCHAR,
	Weight VARCHAR,
	Team VARCHAR,
	NOC VARCHAR,
	Games VARCHAR,
	Year VARCHAR,
	Season VARCHAR,
	City VARCHAR,
	Sport VARCHAR,
	Event VARCHAR,
	Medal VARCHAR
);
-- table noc_region
DROP TABLE IF EXISTS noc_region;
CREATE TABLE IF NOT EXISTS noc_region (
	NOC VARCHAR,
	region VARCHAR,
	notes VARCHAR
);

-- 1. How many olympics games have been held?
SELECT count(DISTINCT(games)) as "total counts"
FROM athlete_event;


-- 2. List down all Olympics games held so far.
SELECT year, season, city
FROM athlete_event
GROUP BY year, season, city
order by year;


-- 3. SQL query to fetch total no of countries participated in each olympic games.
WITH all_countries AS (
	SELECT ae.games, nr.region
	FROM noc_region as nr
	INNER JOIN
	athlete_event as ae ON
	ae.noc = nr.noc
	GROUP BY ae.games, nr.region)
SELECT games, count(*)
FROM all_countries
GROUP BY games
ORDER BY games;


-- 4. Which year saw the highest and lowest no of countries participating in olympics
-- Problem Statement: Write a SQL query to return the Olympic Games which had the highest participating countries and the lowest 	participating 	countries.
SELECT
DISTINCT
concat(first_value(games) OVER(ORDER BY counts), '-' , first_value(counts) OVER(ORDER BY counts)) as "lowest_country",
concat(first_value(games) OVER(ORDER BY counts DESC), '-', first_value(counts) over(ORDER BY counts DESC)) as "highest_country"
FROM (
	SELECT games, count(*) as "counts"
	FROM (
		SELECT ae.games, nr.region
		FROM noc_region as nr
		INNER JOIN
		athlete_event as ae ON
		ae.noc = nr.noc
		GROUP BY ae.games, nr.region) as tmp
	GROUP BY games
	ORDER BY count(*)) as tmp1


-- 5. Which nation has participated in all of the olympic games
--Problem Statement: SQL query to return the list of countries who have been part of every Olympics games.

SELECT * FROM (
	SELECT region, count(*) FROM (
		SELECT ae.games, nr.region
		FROM athlete_event as ae
		INNER JOIN noc_region as nr
		ON ae.noc = nr.noc
		GROUP BY ae.games, nr.region) as tmp
	GROUP BY region) as tmp1
WHERE count IN (SELECT count(distinct(games)) 
FROM athlete_event)


-- 6. Identify the sport which was played in all summer olympics.
--Problem Statement: SQL query to fetch the list of all sports which have been part of every olympics.
SELECT *
 FROM (
	-- it gives rank to all sports according to games, if same game occur in multiple games its 
	-- rank would be increase by one
	SELECT sport, 
	rank() OVER(PARTITION BY sport ORDER BY games) as "no_of_games"
	FROM (
		SELECT sport, games
		FROM athlete_event
		GROUP BY games, sport
		ORDER BY sport
	) as tmp) as tmp5
INNER JOIN (
-- here it give maximum values of 29
SELECT max(counts) as "total_games" FROM (
	SELECT sport, count(*) as "counts" FROM (
		SELECT sport, games
		FROM athlete_event
		GROUP BY games, sport) as tmp
	GROUP BY sport
	ORDER BY count(*) DESC) as tmp1) a1
ON tmp5.no_of_games = a1.total_games


-- 7. Which Sports were just played only once in the olympics.
-- Problem Statement: Using SQL query, Identify the sport which were just played once in all of olympics.

SELECT sport, count(*)
FROM (
	SELECT DISTINCT games, sport
	FROM athlete_event) as tmp
GROUP BY sport
HAVING count(*) = 1
ORDER BY sport