USE mvc_collisions;

SELECT l.borough, AVG(persons_injured) as people_injured
FROM collisions c
JOIN collision_location l
	on c.location_id = l.location_id
WHERE l.borough IS NOT NULL
GROUP BY l.borough
ORDER BY people_injured DESC;


SELECT l.borough, COUNT(*) as total_collisions
FROM collisions c
JOIN collision_location l
	on c.location_id = l.location_id
WHERE crash_date > '2021-01-01'
	AND l.borough IS NOT NULL
GROUP BY l.borough;

SELECT l.borough, SUM(c.persons_injured) AS people_injured
FROM collisions c
JOIN collision_location l
	on c.location_id = l.location_id
WHERE l.borough IS NOT NULL
GROUP BY l.borough
HAVING people_injured > 1000
ORDER BY l.borough DESC;

SELECT l.borough, COUNT(*) as total_crashes
FROM collisions c
JOIN collision_location l
	on c.location_id = l.location_id
WHERE l.borough IS NOT NULL
GROUP BY l.borough
ORDER BY total_crashes DESC
LIMIT 5;

SELECT l.borough, COUNT(*) AS fatal_accidents
FROM collisions c
JOIN collision_location l
	on c.location_id = l.location_id
WHERE c.persons_killed > 0
	AND crash_date > '2020-01-01'
    AND l.borough IS NOT NULL
GROUP BY l.borough
ORDER BY fatal_accidents DESC
LIMIT 3;


SELECT l.borough, COUNT(*) AS total_crashes
FROM collisions c
JOIN collision_location l
  ON c.location_id = l.location_id
GROUP BY l.borough
HAVING COUNT(*) > (
  SELECT AVG(borough_count)
  FROM (
    SELECT COUNT(*) AS borough_count
    FROM collisions c
    JOIN collision_location l
      ON c.location_id = l.location_id
    GROUP BY l.borough
  ) t
);


SELECT l.borough, c.persons_injured
FROM collisions c
JOIN collision_location l
	ON c.location_id= l.location_id
WHERE crash_date > '2020-01-01'
	and persons_injured > (
	SELECT AVG(c2.persons_injured)
	FROM collisions c2
	JOIN collision_location l2
		ON c2.location_id= l2.location_id
	WHERE l2.borough= l.borough
	)
    LIMIT 1000; 
-- right answer but too slow

SELECT l.borough, c.persons_injured
FROM collisions c
JOIN collision_location l
  ON c.location_id = l.location_id
JOIN (
  SELECT l2.borough, AVG(c2.persons_injured) AS avg_injured
  FROM collisions c2
  JOIN collision_location l2
    ON c2.location_id = l2.location_id
  GROUP BY l2.borough
) a
  ON a.borough = l.borough
WHERE c.crash_date >= '2021-01-01'
  AND c.persons_injured > a.avg_injured;



SELECT c.collision_id,l.borough, c.persons_killed
FROM collisions c
JOIN collision_location l
  ON c.location_id = l.location_id
WHERE l.borough IS NOT NULL
	and c.persons_killed> 
		(SELECT AVG(persons_killed) FROM collisions);
        
SELECT l.borough, 
	SUM(c.persons_killed), 
    (
	SELECT AVG(c.person_killed)
)


WITH borough_fatal_collisions AS  (
	SELECT l.borough, COUNT(*) as fatal_crashes
	FROM collisions c
	JOIN collision_location l
		on c.location_id = l.location_id
	WHERE l.borough IS NOT NULL
		and persons_killed > 0
	GROUP BY l.borough
)
SELECT borough, fatal_crashes
FROM borough_fatal_collisions
ORDER BY fatal_crashes DESC
LIMIT 3;

;





