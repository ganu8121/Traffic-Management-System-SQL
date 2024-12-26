---

# Traffic Management System

## Overview

The Traffic Management System project harnesses the power of SQL to revolutionize traffic flow management in urban areas. By leveraging real-time data on vehicle counts at various traffic light locations, this system dynamically adjusts the duration of green and red lights to enhance traffic flow, reduce congestion, and improve overall urban mobility.

## Challenges Addressed

Urban areas face significant traffic-related challenges, including:
- Prolonged travel times
- Increased fuel consumption
- Elevated carbon emissions
- Poor air quality

Traditional traffic light systems operate on fixed schedules, often misaligned with real-time traffic conditions. Our Traffic Management System uses real-time data to dynamically adjust traffic signals, effectively addressing these challenges.

## Solution Highlights

Our system employs a two-table database structure and SQL queries to monitor and manage traffic. Key features include:
- **Monitoring Vehicle Counts:** Tracks vehicles at various locations using real-time data.
- **Dynamic Signal Adjustment:** Modifies traffic light durations based on vehicle density.
- **Efficiency Improvement:** Increases green light duration at congested locations and optimizes red light duration for smoother traffic flow.

## System Components

### Database Structure

1. **Traffic_Lights Table:** Stores traffic light locations, statuses, and durations.
    ```sql
    CREATE TABLE Traffic_Lights (
        Light_ID INT PRIMARY KEY,
        Location VARCHAR(255),
        Status VARCHAR(10),  -- 'Green' or 'Red'
        Green_Duration INT,  -- Duration for Green Light in seconds
        Red_Duration INT     -- Duration for Red Light in seconds
    );
    ```
2. **Traffic_Log Table:** Logs vehicle count data with timestamps for each location.
    ```sql
    CREATE TABLE Traffic_Log (
        Log_ID INT PRIMARY KEY AUTO_INCREMENT,
        Light_ID INT,
        Vehicle_Count INT,
        Log_Time DATETIME,
        FOREIGN KEY (Light_ID) REFERENCES Traffic_Lights(Light_ID)
    );
    ```

### SQL Queries and Analysis

#### Total Vehicle Count by Location

Calculates total vehicles per location within a specific timeframe:
```sql
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
```

#### Traffic Light Duration Adjustment

Adjusts green light duration based on vehicle count:
```sql
SELECT  
    T.Location,
    CASE  
        WHEN SUM(TL.Vehicle_Count) > 50 THEN 'Increase Green Light Duration'
        WHEN SUM(TL.Vehicle_Count) BETWEEN 30 AND 50 THEN 'Normal Green Light Duration'
        ELSE 'Decrease Green Light Duration'
    END AS Adjustment
FROM  
    Traffic_Log TL
JOIN  
    Traffic_Lights T ON TL.Light_ID = T.Light_ID
WHERE  
    TL.Log_Time BETWEEN '2024-12-25 08:00:00' AND '2024-12-25 09:00:00'
GROUP BY  
    T.Location;
```

## Visual Data Representation

### Bar Chart: Vehicle Count by Location

Illustrates vehicle counts per location:
```python
import matplotlib.pyplot as plt

locations = ['Location A', 'Location B', 'Location C']
vehicle_counts = [85, 40, 100]

plt.figure(figsize=(8, 6))
plt.bar(locations, vehicle_counts, color=['blue', 'orange', 'green'])
plt.xlabel('Location')
plt.ylabel('Total Vehicle Count')
plt.title('Total Vehicle Count by Location (Dec 25, 2024, 08:00-09:00)')
plt.savefig('bar_chart.jpg')
plt.show()
```

### Pie Chart: Vehicle Distribution

Shows the percentage of vehicles at each location:
```python
plt.figure(figsize=(6, 6))
plt.pie(vehicle_counts, labels=locations, autopct='%1.1f%%', colors=['blue', 'orange', 'green'])
plt.title('Vehicle Distribution by Location (Dec 25, 2024, 08:00-09:00)')
plt.savefig('pie_chart.jpg')
plt.show()
```

## Impact and Benefits

### Traffic Flow Optimization

Dynamic traffic light adjustments reduce congestion and improve traffic flow during peak hours.

### Environmental Benefits

Less idling at red lights leads to lower fuel consumption and reduced emissions.

### Enhanced Urban Mobility

The system scales to accommodate cities of various sizes, ensuring quicker and more predictable commutes.

### Safety Improvements

Minimizing congestion at intersections lowers the risk of accidents caused by sudden stops or merging traffic.

## Conclusion

The Traffic Management System leverages real-time data and SQL to optimize traffic light durations and enhance urban mobility. By addressing congestion, safety, and environmental impact, this system exemplifies how intelligent solutions can create more efficient and livable cities.

