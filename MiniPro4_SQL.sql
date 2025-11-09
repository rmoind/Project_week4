CREATE DATABASE traveler_trip;
use traveler_trip;

CREATE TABLE destination(
    destination_id INT PRIMARY KEY,
    city VARCHAR(100),
    country VARCHAR(100));
    
CREATE TABLE traveler(
    traveler_id INT PRIMARY KEY,
    name VARCHAR(100),
    last_name VARCHAR(100),
    age int,
    gender VARCHAR(50),
    nationality VARCHAR(50));
    
    CREATE TABLE transportation(
    transportation_type_id INT PRIMARY KEY,
    transportation_type_name VARCHAR(100));
    
	CREATE TABLE accommodation(
    accommodation_type_id INT PRIMARY KEY,
    accommodation_type_name VARCHAR(100));
    
    
    CREATE TABLE trip(
    trip_id INT PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    duration INT,
    accommodation_cost INT,
    transportation_cost INT,
    destination_id INT, 
    FOREIGN KEY (destination_id) REFERENCES destination(destination_id),
	traveler_id INT,
    FOREIGN KEY (traveler_id) REFERENCES traveler(traveler_id), 
    transportation_type_id INT,
    FOREIGN KEY (transportation_type_id) REFERENCES transportation(transportation_type_id), 
    accommodation_type_id INT,
    FOREIGN KEY (accommodation_type_id) REFERENCES accommodation(accommodation_type_id));
  
  
 #4. Traveler nationality influences destination preferences
 # Goal: Cross-tabulation of traveler nationality vs. top destinations.   
 
WITH Nationality_Destination_Counts AS (
    SELECT
        T.nationality,
        D.Country AS Destination_Country,
        COUNT(TF.`destination_id`) AS Trip_Count,
        ROW_NUMBER() OVER (PARTITION BY T.nationality ORDER BY COUNT(TF.`destination_id`) DESC) AS rn
    FROM
        destination AS TF
    JOIN
        traveler AS T ON TF.destination_id = T.traveler_id
    JOIN
        destination AS D ON TF.Destination_id = D.Destination_id
    GROUP BY
        T.nationality, D.Country
)
SELECT
    nationality,
    Destination_Country,
    Trip_Count
FROM
    Nationality_Destination_Counts
WHERE
    rn <= 3
ORDER BY
    nationality, Trip_Count DESC;