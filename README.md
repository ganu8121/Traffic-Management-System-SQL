

# Traffic Management System  
**Analysis and Implementation Using SQL**  
**By Ganesh Cherukuri**  
**December 25, 2024**

## Abstract  
Traffic congestion in urban areas is a significant challenge, leading to increased travel times, fuel consumption, carbon emissions, and poor air quality. This project introduces a smart Traffic Management System utilizing SQL to analyze real-time vehicle counts at intersections and dynamically adjust traffic light durations.

While current traffic signal systems often rely on sonar sensors to detect vehicle presence, this project explores the potential of integrating data from platforms like Google and other apps where device location is shared. By incorporating such data, the system can estimate the actual number of vehicles in real-time more accurately. Although full integration of external data sources is not yet implemented, the system currently uses partial data inputs to optimize traffic light timings, reducing congestion and improving urban mobility.

This project demonstrates the transformative potential of combining traditional sensor-based systems with advanced data analytics and external data sources, paving the way for smarter, more efficient cities.

---

## Table of Contents  
1. [Introduction](#introduction)  
2. [Problem Statement](#problem-statement)  
3. [Solution Overview](#solution-overview)  
4. [System Architecture](#system-architecture)  
   - 4.1 [Database Structure](#41-database-structure)  
   - 4.2 [Feature Engineering](#42-feature-engineering)  
5. [SQL Queries and Analysis](#sql-queries-and-analysis)  
6. [Data Visualizations](#data-visualizations)  
7. [Real-World Impact](#real-world-impact)  
8. [Conclusion](#conclusion)

---

## 1. Introduction  
This project leverages SQL to implement a Traffic Management System that dynamically adjusts traffic light durations based on real-time vehicle counts. By utilizing data analytics and SQL queries, the system aims to mitigate congestion, enhance road safety, and minimize environmental impact in urban areas. Specifically, the system will focus on:

Optimizing traffic flow: By analyzing real-time vehicle data, the system will dynamically adjust traffic light timings to prioritize traffic flow at congested intersections.
Improving safety: By identifying and addressing potential bottlenecks, the system will contribute to a safer and more predictable traffic environment for all road users.
Reducing environmental impact: By minimizing idling time and optimizing traffic flow, the system will contribute to a reduction in fuel consumption and vehicle emissions, leading to a more sustainable urban environment.

---

## 2. Problem Statement  
Urban traffic congestion leads to:  
- Increased travel time  
- Higher fuel consumption  
- Greater carbon emissions  
- Poor air quality  

Traditional traffic systems operate on fixed schedules, failing to adapt to real-time traffic patterns. This project introduces a dynamic system to address these inefficiencies.

---

## 3. Solution Overview  
The system uses a two-table database structure and SQL queries to analyze traffic patterns and adjust traffic light timings. Key objectives include:  
- Monitoring vehicle counts at intersections  
- Dynamically adjusting traffic light durations based on vehicle density  
- Enhancing urban mobility and reducing congestion  

---

## 4. System Architecture  

### 4.1 Database Structure  
The database comprises two main tables:  

#### **Traffic_Lights Table**  
This table stores information about traffic lights, including their location, status, and durations.  

| **Column Name**     | **Data Type**     | **Description**                                |  
|----------------------|-------------------|------------------------------------------------|  
| `Light_ID`          | INTEGER          | Unique identifier for each traffic light.     |  
| `Location`          | VARCHAR(100)     | The location of the traffic light.            |  
| `Current_Status`    | VARCHAR(10)      | The current status (e.g., RED, GREEN).        |  
| `Green_Light_Duration` | INTEGER          | Duration of the green light in seconds.       |  
| `Red_Light_Duration`   | INTEGER          | Duration of the red light in seconds.         |  

#### **Traffic_Log Table**  
This table logs real-time vehicle counts at traffic intersections.  

| **Column Name**     | **Data Type**     | **Description**                                |  
|----------------------|-------------------|------------------------------------------------|  
| `Log_ID`            | INTEGER          | Unique identifier for each log entry.         |  
| `Light_ID`          | INTEGER          | Foreign key referencing `Traffic_Lights.Light_ID`. |  
| `Log_Time`          | TIMESTAMP        | Timestamp of the log entry.                   |  
| `Vehicle_Count`     | INTEGER          | Number of vehicles logged at this time.       |  

The tables are linked through the `Light_ID` column to enable efficient analysis of traffic data.  

---

### 4.2 Feature Engineering  
Key features created include:  
- Indicators for peak traffic hours  
- Aggregated insights such as average vehicle count per hour  
- Temporal variables like day of the week and hour of the day
import pandas as pd
import numpy as np

# Sample data
data = {
    'Location': ['Location A', 'Location B', 'Location C'],
    'Vehicle_Count': [85, 40, 100],
    'Time': pd.date_range('2024-12-25 08:00', periods=3, freq='H')
}
df = pd.DataFrame(data)

# Add a new feature for peak traffic time
df['Peak_Time'] = np.where(df['Vehicle_Count'] == df['Vehicle_Count'].max(), True, False)
print(df)


---

## 5. SQL Queries and Analysis  

### 5.1 Query to Calculate Total Vehicle Count by Location  
This query calculates the total number of vehicles passing through each location within a given time range (e.g., 08:00-09:00 on December 25, 2024):  

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

**Explanation:**  
- **SUM(TL.Vehicle_Count):** Calculates the total vehicle count for each location.  
- **GROUP BY T.Location:** Aggregates the vehicle count by location.  

---

### 5.2 Query to Adjust Traffic Light Durations  
This query determines whether the green light duration needs to be increased, maintained, or decreased based on the total vehicle count.  

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

**Explanation:**  
- **CASE Statement:** Adjusts light duration based on vehicle count thresholds:  
  - Vehicle count > 50: Increase green light duration.  
  - Vehicle count between 30 and 50: Maintain normal duration.  
  - Vehicle count < 30: Decrease green light duration.  

---

### 5.3 Query to Calculate Average Vehicle Count by Hour  
This query calculates the average number of vehicles passing through each location for each hour within a given time range.  

```sql
SELECT   
    T.Location,   
    HOUR(TL.Log_Time) AS Hour,   
    AVG(TL.Vehicle_Count) AS Avg_Vehicles 
FROM   
    Traffic_Log TL 
JOIN   
    Traffic_Lights T ON TL.Light_ID = T.Light_ID 
WHERE   
    TL.Log_Time BETWEEN '2024-12-25 00:00:00' AND '2024-12-25 23:59:59' 
GROUP BY   
    T.Location,   
    HOUR(TL.Log_Time);
```

**Explanation:**  
- **HOUR(TL.Log_Time):** Extracts the hour from the log timestamp.  
- **AVG(TL.Vehicle_Count):** Calculates the average vehicle count for each hour.  
- **GROUP BY T.Location, HOUR(TL.Log_Time):** Aggregates the data by location and hour.  

---

## 6. Data Visualizations  
### 6.1 Bar Chart - Vehicle Count by Location  
Displays the total number of vehicles at each location within a specific time range.  
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

### 6.2 Pie Chart - Vehicle Distribution  
Shows the proportion of vehicles passing through each location. 
### Pie Chart: Vehicle Distribution

Shows the percentage of vehicles at each location:
```python
plt.figure(figsize=(6, 6))
plt.pie(vehicle_counts, labels=locations, autopct='%1.1f%%', colors=['blue', 'orange', 'green'])
plt.title('Vehicle Distribution by Location (Dec 25, 2024, 08:00-09:00)')
plt.savefig('pie_chart.jpg')
plt.show()
```

### 6.3 Heatmap - Traffic Density by Location and Time  
Visualizes traffic density across locations and times to identify congestion patterns.  
#heat map 
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Sample data for heatmap
data = {
    'Location': ['Location A', 'Location B', 'Location C', 'Location A', 'Location B', 'Location C'],
    'Hour': [8, 8, 8, 9, 9, 9],
    'Vehicle_Count': [85, 40, 100, 90, 45, 105]
}
df = pd.DataFrame(data)

# Pivot data for heatmap
heatmap_data = df.pivot(index='Location', columns='Hour', values='Vehicle_Count')

# Create heatmap
plt.figure(figsize=(10, 6))
sns.heatmap(heatmap_data, annot=True, cmap="YlGnBu")
plt.title('Traffic Density Heatmap')
plt.show()

---

## 7. Real-World Impact  
- **Traffic Flow Optimization:** Reduces congestion and waiting times.  
- **Environmental Benefits:** Reduces emissions by minimizing idling times.  
- **Improved Urban Mobility:** Ensures smoother and predictable traffic flows.  
- **Safety Enhancements:** Reduces accident risks at intersections.  

---

## 8. Conclusion  
This project represents an initial exploration of a smart Traffic Management System. By utilizing SQL to analyze preliminary traffic data and exploring the potential of vehicle detection through sonar sensors, this project demonstrates the feasibility of using data-driven approaches to improve traffic flow. While the current system is limited in scope and lacks the integration of external data sources like Google Maps and location-based services, this initial work highlights the significant potential for such integration in future iterations.

By incorporating real-time data from various sources, the system can be further enhanced to provide more accurate traffic predictions, optimize traffic signal timings more effectively, and ultimately achieve a more seamless and efficient urban transportation network. This project serves as a foundation for continued research and development, paving the way for the creation of smarter, more sustainable cities. 

---

You can now upload this README to GitHub!
