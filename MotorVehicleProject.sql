-- Which borough has the most collisions?

SELECT l.borough, COUNT(*) AS total_crashes
FROM collisions c
JOIN collision_location l
	ON c.location_id = l.location_id
WHERE borough IS NOT NULL
GROUP BY l.borough
ORDER BY total_crashes DESC;

-- Trend: collisions per year

SELECT YEAR(c.crash_date) AS crash_year, COUNT(*) AS total_crashes
FROM collisions c
GROUP by YEAR(c.crash_date)
ORDER BY crash_year;

-- Which borough has the most FATAL crashes?

SELECT l.borough, COUNT(*) AS crashes
FROM collisions c
JOIN collision_location l
	ON c.location_id = l.location_id
WHERE l.borough IS NOT NULL
	AND c.persons_killed > 0
GROUP BY l.borough
ORDER BY crashes DESC;

-- Fatal crash rate by borough (fatal crashes / total crashes)

SELECT l.borough, 
SUM(c.persons_killed > 0) / COUNT(*) AS fatal_crash_rate
FROM collisions c
JOIN collision_location l
	ON c.location_id = l.location_id
WHERE l.borough IS NOT NULL
GROUP BY l.borough
;

-- Which borough has the highest total injuries?

SELECT l.borough, SUM(persons_injured) AS total_injured
FROM collisions c
JOIN collision_location l
	ON c.location_id = l.location_id
WHERE borough IS NOT NULL
GROUP BY borough
ORDER BY total_injured DESC;

-- Top vehicle types involved (Top 10)

SELECT v.vehicle_type, COUNT(*) AS crashes
FROM collisions c
JOIN collision_vehicles v
	on v.collision_id = c.collision_id
WHERE v.vehicle_type IS NOT NULL
GROUP BY v.vehicle_type
ORDER BY crashes DESC
LIMIT 10;

-- Top contributing factors (Top 10)

SELECT f.contributing_factor, COUNT(*) AS crashes
FROM collisions c
JOIN collision_factors f
	on f.collision_id = c.collision_id
WHERE f.contributing_factor IS NOT NULL
	AND f.contributing_factor <> 'Unspecified'
GROUP BY f.contributing_factor
ORDER BY crashes DESC
LIMIT 10;

-- Boroughs with above-average crashes

SELECT l.borough, COUNT(*) AS crashes
FROM collisions c
JOIN collision_location l
	ON c.location_id = l.location_id
WHERE l.borough IS NOT NULL
GROUP BY l.borough
HAVING COUNT(*) > 
(	SELECT AVG(borough_crashes)
	FROM (
    SELECT COUNT(*) AS borough_crashes
    FROM collisions c2
    JOIN collision_location l2
      ON c2.location_id = l2.location_id
	WHERE l2.borough IS NOT NULL
    GROUP BY l2.borough
  ) t
);

-- Pre-2020 vs Post-2020 comparison by borough (CTE)
WITH borough_year AS (
  SELECT
    l.borough,
    YEAR(c.crash_date) AS yr,
    COUNT(*) AS crashes
  FROM collisions c
  JOIN collision_location l
    ON c.location_id = l.location_id
  WHERE l.borough IS NOT NULL
  GROUP BY l.borough, YEAR(c.crash_date)
)
SELECT
  borough,
  SUM(CASE WHEN yr <= 2021 THEN crashes ELSE 0 END) AS pre_2022_crashes,
  SUM(CASE WHEN yr >= 2022 THEN crashes ELSE 0 END) AS post_2022_crashes
FROM borough_year
GROUP BY borough
ORDER BY post_2022_crashes DESC;

