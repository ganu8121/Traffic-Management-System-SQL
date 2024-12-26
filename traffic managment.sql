-- Create Database
CREATE DATABASE Traffic_Management;

-- Use the created database
USE Traffic_Management;

-- Vehicles Table: Stores vehicle data
CREATE TABLE Vehicles (
    Vehicle_ID INT PRIMARY KEY,
    Vehicle_Type VARCHAR(50),
    License_Plate VARCHAR(20),
    Entry_Time DATETIME,
    Exit_Time DATETIME,
    Route VARCHAR(100)
);

-- Traffic_Lights Table: Stores data about traffic signals
CREATE TABLE Traffic_Lights (
    Light_ID INT PRIMARY KEY,
    Location VARCHAR(100),
    Status VARCHAR(50),
    Green_Light_Duration INT, -- duration in seconds
    Red_Light_Duration INT -- duration in seconds
);

-- Traffic_Log Table: Logs vehicle counts and traffic light status at specific times
CREATE TABLE Traffic_Log (
    Log_ID INT PRIMARY KEY AUTO_INCREMENT,
    Log_Time DATETIME,
    Light_ID INT,
    Vehicle_Count INT,
    Status VARCHAR(50),
    FOREIGN KEY (Light_ID) REFERENCES Traffic_Lights(Light_ID)
);

-- Congestion_Report Table: Stores data on traffic congestion
CREATE TABLE Congestion_Report (
    Report_ID INT PRIMARY KEY AUTO_INCREMENT,
    Location VARCHAR(100),
    Congestion_Level VARCHAR(50),
    Report_Time DATETIME
);
-- Insert data into Vehicles table
INSERT INTO Vehicles (Vehicle_ID, Vehicle_Type, License_Plate, Entry_Time, Exit_Time, Route) 
VALUES 
(1, 'Car', 'KA01AB1234', '2024-12-25 08:00:00', '2024-12-25 08:30:00', 'Route A'),
(2, 'Bike', 'KA01CD5678', '2024-12-25 08:10:00', '2024-12-25 08:25:00', 'Route B'),
(3, 'Bus', 'KA01EF9876', '2024-12-25 08:20:00', '2024-12-25 08:40:00', 'Route C');

-- Insert data into Traffic_Lights table
INSERT INTO Traffic_Lights (Light_ID, Location, Status, Green_Light_Duration, Red_Light_Duration)
VALUES 
(1, 'Location A', 'Green', 30, 60),
(2, 'Location B', 'Red', 0, 60),
(3, 'Location C', 'Green', 40, 50);

-- Insert data into Traffic_Log table
INSERT INTO Traffic_Log (Log_Time, Light_ID, Vehicle_Count, Status) 
VALUES 
('2024-12-25 08:00:00', 1, 10, 'Green'),
('2024-12-25 08:05:00', 2, 5, 'Red'),
('2024-12-25 08:10:00', 3, 8, 'Green');

-- Insert data into Congestion_Report table
INSERT INTO Congestion_Report (Location, Congestion_Level, Report_Time)
VALUES 
('Location A', 'High', '2024-12-25 08:15:00'),
('Location B', 'Medium', '2024-12-25 08:15:00'),
('Location C', 'Low', '2024-12-25 08:15:00');
SELECT 
    T.Location, 
    SUM(TL.Vehicle_Count) AS Total_Vehicles
FROM 
    Traffic_Log TL
JOIN 
    Traffic_Lights T ON TL.Light_ID = T.Light_ID
WHERE 
    TL.Log_Time BETWEEN '2024-12-25 08:00:00' AND '2024-12-25 09:00:00'
GROUP BY 
    T.Location;

SELECT 
    Location, 
    Status 
FROM 
    Traffic_Lights;
SELECT 
    Location, 
    Congestion_Level, 
    Report_Time
FROM 
    Congestion_Report
WHERE 
    Report_Time BETWEEN '2024-12-25 08:00:00' AND '2024-12-25 09:00:00';
SELECT 
    T.Location,
    CASE 
        WHEN TL.Vehicle_Count > 10 THEN 'Increase Green Light Duration'
        WHEN TL.Vehicle_Count BETWEEN 5 AND 10 THEN 'Normal Green Light Duration'
        ELSE 'Decrease Green Light Duration'
    END AS Adjustment
FROM 
    Traffic_Log TL
JOIN 
    Traffic_Lights T ON TL.Light_ID = T.Light_ID
WHERE 
    TL.Log_Time BETWEEN '2024-12-25 08:00:00' AND '2024-12-25 09:00:00';

