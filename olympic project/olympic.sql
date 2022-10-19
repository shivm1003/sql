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


