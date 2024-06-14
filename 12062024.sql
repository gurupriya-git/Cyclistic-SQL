USE cyclistic;

SELECT * FROM divvy_trips_2019_q1;

-- find ride duration as TIME
ALTER TABLE divvy_trips_2019_q1 ADD COLUMN ride_duration TIME;
SET SQL_SAFE_UPDATES = 0;
UPDATE divvy_trips_2019_q1 
SET ride_duration = TIMEDIFF(end_time,start_time);
SET SQL_SAFE_UPDATES = 1;


-- find ride duration in SECONDS as integer
ALTER TABLE divvy_trips_2019_q1 ADD COLUMN ride_length_seconds INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE divvy_trips_2019_q1 
SET ride_length_seconds = TIME_TO_SEC(ride_duration);
SET SQL_SAFE_UPDATES = 1;


-- find the day of the trip as INT
ALTER TABLE divvy_trips_2019_q1 ADD COLUMN weekday_numerical INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE divvy_trips_2019_q1
SET weekday_numerical = CASE
    WHEN DAYOFWEEK(start_time) = 1 THEN 1
    WHEN DAYOFWEEK(start_time) = 2 THEN 2
    WHEN DAYOFWEEK(start_time) = 3 THEN 3
    WHEN DAYOFWEEK(start_time) = 4 THEN 4
    WHEN DAYOFWEEK(start_time) = 5 THEN 5
    WHEN DAYOFWEEK(start_time) = 6 THEN 6
    WHEN DAYOFWEEK(start_time) = 7 THEN 7
END;
SET SQL_SAFE_UPDATES = 1;

-- Find peak hours    
SELECT * FROM divvy_trips_2019_q1;
ALTER TABLE divvy_trips_2019_q1 ADD COLUMN trip_hour INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE divvy_trips_2019_q1
SET trip_hour= HOUR(start_time);
SET SQL_SAFE_UPDATES = 1;

-- Create Age Groups
ALTER TABLE divvy_trips_2019_q1 ADD COLUMN age_group VARCHAR(20);
SET SQL_SAFE_UPDATES = 0;
UPDATE divvy_trips_2019_q1
SET age_group =
    CASE
        WHEN 2019 - birthyear BETWEEN 0 AND 17 THEN '0-17'
        WHEN 2019 - birthyear BETWEEN 18 AND 25 THEN '18-25'
        WHEN 2019 - birthyear BETWEEN 26 AND 35 THEN '26-35'
        WHEN 2019 - birthyear BETWEEN 36 AND 45 THEN '36-45'
        WHEN 2019 - birthyear BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM divvy_trips_2019_q1;

-- find peak hours of customers
SELECT trip_hour, COUNT(*) AS total_riders, AVG(ride_length_seconds), MAX(ride_length_seconds),
SUM(CASE WHEN usertype = 'customer' THEN 1 ELSE 0 END) AS total_customers,
SUM(CASE WHEN usertype = 'subscriber' THEN 1 ELSE 0 END) AS total_subscribers,
SUM(CASE WHEN gender = 'Female' AND usertype = 'customer' THEN 1 ELSE 0 END) AS Female_customers,
SUM(CASE WHEN gender = 'Male' AND usertype = 'customer' THEN 1 ELSE 0 END) AS Male_customers,
SUM(CASE WHEN gender = 'Female' AND usertype = 'subscriber' THEN 1 ELSE 0 END) AS Female_subscribers,
SUM(CASE WHEN gender = 'Male' AND usertype = 'subscriber' THEN 1 ELSE 0 END) AS Male_subscribers,
SUM(CASE WHEN age_group = '0-17' THEN 1 ELSE 0 END) AS age_0_to_17,
SUM(CASE WHEN age_group = '18-25' THEN 1 ELSE 0 END) AS age_18_to_25,
SUM(CASE WHEN age_group = '26-35' THEN 1 ELSE 0 END) AS age_26_to_35,
SUM(CASE WHEN age_group = '36-45' THEN 1 ELSE 0 END) AS age_36_to_45,
SUM(CASE WHEN age_group = '46-55' THEN 1 ELSE 0 END) AS age_46_to_55,
SUM(CASE WHEN age_group = '56+' THEN 1 ELSE 0 END) AS age_56_plus

FROM  divvy_trips_2019_q1
GROUP BY trip_hour;

-- find maximum and average duration of trip among age groups
SELECT age_group, MAX(ride_length_seconds) AS max_ride, AVG(ride_length_seconds) AS avg_ride, COUNT(*) AS total_riders,
SUM(CASE WHEN usertype = 'customer' THEN 1 ELSE 0 END) AS total_customers,
SUM(CASE WHEN usertype = 'subscriber' THEN 1 ELSE 0 END) AS total_subscribers,
SUM(CASE WHEN gender = 'Female' AND usertype = 'customer' THEN 1 ELSE 0 END) AS Female_customers,
SUM(CASE WHEN gender = 'Male' AND usertype = 'customer' THEN 1 ELSE 0 END) AS Male_customers,
SUM(CASE WHEN gender = 'Female' AND usertype = 'subscriber' THEN 1 ELSE 0 END) AS Female_subscribers,
SUM(CASE WHEN gender = 'Male' AND usertype = 'subscriber' THEN 1 ELSE 0 END) AS Male_subscribers
FROM divvy_trips_2019_q1
GROUP BY age_group
ORDER BY total_customers DESC;

-- check the non binary group
SELECT COUNT(*), age_group
FROM divvy_trips_2019_q1
WHERE gender NOT IN ('male', 'female')
GROUP BY age_group;

-- find maximum and average duration of trip among gender
SELECT gender, MAX(ride_length_seconds), AVG(ride_length_seconds), COUNT(*) AS tot_riders
FROM divvy_trips_2019_q1
-- WHERE usertype = 'customer'
GROUP BY gender;

-- find maximum and average duration among the days of the week
SELECT weekday_numerical, MAX(ride_length_seconds) AS max_ride, AVG(ride_length_seconds) AS avg_ride,
COUNT(*) AS total_riders,
SUM(CASE WHEN usertype = 'customer' THEN 1 ELSE 0 END) AS total_customers,
SUM(CASE WHEN usertype = 'subscriber' THEN 1 ELSE 0 END) AS total_subscribers,
SUM(CASE WHEN gender = 'Female' AND usertype = 'customer' THEN 1 ELSE 0 END) AS Female_customers,
SUM(CASE WHEN gender = 'Male' AND usertype = 'customer' THEN 1 ELSE 0 END) AS Male_customers,
SUM(CASE WHEN gender = 'Female' AND usertype = 'subscriber' THEN 1 ELSE 0 END) AS Female_subscribers,
SUM(CASE WHEN gender = 'Male' AND usertype = 'subscriber' THEN 1 ELSE 0 END) AS Male_subscribers,
SUM(CASE WHEN age_group = '0-17' THEN 1 ELSE 0 END) AS age_0_to_17,
SUM(CASE WHEN age_group = '18-25' THEN 1 ELSE 0 END) AS age_18_to_25,
SUM(CASE WHEN age_group = '26-35' THEN 1 ELSE 0 END) AS age_26_to_35,
SUM(CASE WHEN age_group = '36-45' THEN 1 ELSE 0 END) AS age_36_to_45,
SUM(CASE WHEN age_group = '46-55' THEN 1 ELSE 0 END) AS age_46_to_55,
SUM(CASE WHEN age_group = '56+' THEN 1 ELSE 0 END) AS age_56_plus

FROM divvy_trips_2019_q1
GROUP BY weekday_numerical
ORDER BY total_riders DESC;

-- find customer peak hours based on gender
SELECT trip_hour, gender, COUNT(*) AS occurances
FROM divvy_trips_2019_q1
WHERE usertype = 'customer' 
GROUP BY trip_hour, gender
ORDER BY occurances DESC;

-- find average and maximum ride duration of customoers and subscribers
SELECT usertype,gender, MAX(ride_length_seconds), AVG(ride_length_seconds)
FROM divvy_trips_2019_q1
GROUP BY usertype,gender;

SELECT COUNT(*) FROM divvy_trips_2019_q1 WHERE ride_length_seconds > 600 AND usertype = 'customer';
SELECT COUNT(*) FROM divvy_trips_2019_q1 WHERE usertype = 'customer';
SELECT COUNT(DISTINCT from_station_name) FROM divvy_trips_2019_q1;


-- find station with maximum trips
SELECT from_station_id, from_station_name, COUNT(*) AS trip_count,
SUM(CASE WHEN usertype = 'customer' THEN 1 ELSE 0 END) AS total_customers,
SUM(CASE WHEN usertype = 'subscriber' THEN 1 ELSE 0 END) AS total_subscribers,
SUM(CASE WHEN age_group = '0-17' THEN 1 ELSE 0 END) AS age_0_to_17,
SUM(CASE WHEN age_group = '18-25' THEN 1 ELSE 0 END) AS age_18_to_25,
SUM(CASE WHEN age_group = '26-35' THEN 1 ELSE 0 END) AS age_26_to_35,
SUM(CASE WHEN age_group = '36-45' THEN 1 ELSE 0 END) AS age_36_to_45,
SUM(CASE WHEN age_group = '46-55' THEN 1 ELSE 0 END) AS age_46_to_55,
SUM(CASE WHEN age_group = '56+' THEN 1 ELSE 0 END) AS age_56_plus
FROM divvy_trips_2019_q1
GROUP BY from_station_id , from_station_name
ORDER BY trip_count DESC;

-- find the route with maximum trips
SELECT from_station_id, to_station_id, COUNT(*) AS trip_count,
SUM(CASE WHEN usertype = 'customer' THEN 1 ELSE 0 END) AS total_customers,
SUM(CASE WHEN usertype = 'subscriber' THEN 1 ELSE 0 END) AS total_subscribers,
SUM(CASE WHEN age_group = '0-17' THEN 1 ELSE 0 END) AS age_0_to_17,
SUM(CASE WHEN age_group = '18-25' THEN 1 ELSE 0 END) AS age_18_to_25,
SUM(CASE WHEN age_group = '26-35' THEN 1 ELSE 0 END) AS age_26_to_35,
SUM(CASE WHEN age_group = '36-45' THEN 1 ELSE 0 END) AS age_36_to_45,
SUM(CASE WHEN age_group = '46-55' THEN 1 ELSE 0 END) AS age_46_to_55,
SUM(CASE WHEN age_group = '56+' THEN 1 ELSE 0 END) AS age_56_plus
FROM divvy_trips_2019_q1
WHERE usertype = 'customer'
GROUP BY from_station_id, to_station_id
ORDER BY trip_count DESC;


-- find average and maximum ride duration of customoers and subscribers based on the days of the week
SELECT weekday_numerical, MAX(ride_length_seconds), AVG(ride_length_seconds), COUNT(*) AS total_user,
SUM(CASE WHEN usertype = 'customer' THEN 1 ELSE 0 END) AS total_customers,
SUM(CASE WHEN usertype = 'subscriber' THEN 1 ELSE 0 END) AS total_subscribers


FROM divvy_trips_2019_q1
GROUP BY weekday_numerical
ORDER BY total_customers DESC;


SELECT * FROM divvy_trips_2019_q1;