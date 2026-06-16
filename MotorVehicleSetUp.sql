CREATE DATABASE IF NOT EXISTS mvc_collisions;
USE mvc_collisions;
SELECT DATABASE() AS current_db;

CREATE TABLE staging_collisions (
  collision_id VARCHAR(50),
  crash_date   VARCHAR(50),
  crash_time   VARCHAR(50),
  borough      VARCHAR(80),
  zip_code     VARCHAR(20),
  latitude     VARCHAR(50),
  longitude    VARCHAR(50),
  persons_injured VARCHAR(50),
  persons_killed  VARCHAR(50),
  contributing_factor VARCHAR(255),
  vehicle_type VARCHAR(100)
);
SELECT COUNT(*) FROM staging_collisions;
SELECT * FROM staging_collisions LIMIT 10;
SELECT
  COUNT(*) AS total_rows,
  SUM(collision_id IS NULL OR collision_id = '') AS blank_ids
FROM staging_collisions;

USE mvc_collisions;

-- 1) locations
CREATE TABLE collision_location (
  location_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  zip_code VARCHAR(10),
  borough VARCHAR(50),
  UNIQUE KEY uq_loc (zip_code, borough)
);

-- 2) collisions (typed)
CREATE TABLE collisions (
  collision_id BIGINT PRIMARY KEY,
  crash_date DATE,
  crash_time TIME,
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  persons_injured INT,
  persons_killed INT,
  location_id BIGINT,
  FOREIGN KEY (location_id) REFERENCES collision_location(location_id)
);

-- 3) collision_factors (bridge)
CREATE TABLE collision_factors (
  collision_id BIGINT,
  contributing_factor VARCHAR(255),
  PRIMARY KEY (collision_id, contributing_factor),
  FOREIGN KEY (collision_id) REFERENCES collisions(collision_id)
);

-- 4) collision_vehicles (bridge)
CREATE TABLE collision_vehicles (
  collision_id BIGINT,
  vehicle_type VARCHAR(100),
  PRIMARY KEY (collision_id, vehicle_type),
  FOREIGN KEY (collision_id) REFERENCES collisions(collision_id)
);

-- locations
INSERT IGNORE INTO collision_location (zip_code, borough)
SELECT DISTINCT NULLIF(TRIM(zip_code),''), NULLIF(TRIM(borough),'')
FROM staging_collisions;

-- collisions
INSERT INTO collisions
SELECT
  CAST(collision_id AS UNSIGNED),
  STR_TO_DATE(crash_date, '%c/%e/%y'),
  STR_TO_DATE(crash_time, '%h:%i:%s %p'),
  CAST(NULLIF(latitude,'') AS DECIMAL(9,6)),
  CAST(NULLIF(longitude,'') AS DECIMAL(9,6)),
  CAST(NULLIF(persons_injured,'') AS UNSIGNED),
  CAST(NULLIF(persons_killed,'') AS UNSIGNED),
  l.location_id
FROM staging_collisions s
LEFT JOIN collision_location l
  ON l.zip_code <=> NULLIF(TRIM(s.zip_code),'')
 AND l.borough <=> NULLIF(TRIM(s.borough),'');

-- factors
INSERT IGNORE INTO collision_factors
SELECT CAST(collision_id AS UNSIGNED), NULLIF(TRIM(contributing_factor),'')
FROM staging_collisions
WHERE NULLIF(TRIM(contributing_factor),'') IS NOT NULL;

-- vehicles
INSERT IGNORE INTO collision_vehicles
SELECT CAST(collision_id AS UNSIGNED), NULLIF(TRIM(vehicle_type),'')
FROM staging_collisions
WHERE NULLIF(TRIM(vehicle_type),'') IS NOT NULL;

SELECT COUNT(*) FROM collisions;




