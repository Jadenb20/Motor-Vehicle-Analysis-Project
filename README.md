# Motor Vehicle Collision Analysis Project

## Overview
This project analyzes over 281,000 New York City motor vehicle collision records spanning 2021–2023. The goal was to uncover patterns in crash frequency, severity, contributing factors, and borough-level trends using SQL and Power BI.

## Tools Used
- **Power Query** – Data cleaning and reduction (original dataset was too large to load into Excel)
- **Excel** – Data formatting and preparation
- **MySQL** – Database design, schema creation, and analysis queries
- **Power BI** – Data visualization (run via Windows VM on Mac)

## Key Findings
- **281,570 total collisions** and **760 fatalities** recorded across the dataset
- **Brooklyn** had the highest number of collisions, followed by Queens and the Bronx
- **Queens** had the most fatalities by borough, despite having fewer total crashes than Brooklyn — suggesting more severe crashes
- **Collisions declined significantly** from 2021 to 2023, visible in the yearly trend analysis
- The geographic distribution of crashes is heavily concentrated across NYC's five boroughs, with the densest clusters in Brooklyn and Queens

## Project Workflow

### 1. Data Cleaning
The raw dataset was too large to load directly into Excel. Power Query was used to clean and reduce it to just over 281,000 records. Basic formatting was then applied in Excel before loading into MySQL.

### 2. Normalization
The data was normalized from 1NF through 3NF to eliminate redundancy and ensure data integrity. This produced the following schema:

- **collisions** – Core crash records (date, time, coordinates, injuries, fatalities)
- **collision_location** – Borough and zip code lookup table
- **collision_factors** – Contributing factors per collision (bridge table)
- **collision_vehicles** – Vehicle types per collision (bridge table)

### 3. Database Setup
A MySQL staging table was used to import the raw CSV data. From there, data was cast to proper types and inserted into the normalized tables using INSERT...SELECT with JOIN logic.

### 4. Analysis Queries
Nine SQL queries were written to answer key questions about the data:

| Query | Question |
|---|---|
| 1 | Which borough has the most collisions? |
| 2 | What is the yearly collision trend? |
| 3 | Which borough has the most fatal crashes? |
| 4 | What is the fatal crash rate by borough? |
| 5 | Which borough has the highest total injuries? |
| 6 | What are the top 10 vehicle types involved in crashes? |
| 7 | What are the top 10 contributing factors? |
| 8 | Which boroughs have above-average crash counts? |
| 9 | How do pre-2022 and post-2022 crash counts compare by borough? |

### 5. Visualizations
Results were visualized in Power BI dashboards covering borough comparisons, crash trends over time, contributing factors, and injury/fatality breakdowns.

## Files
| File | Description |
|---|---|
| `MotorVehicleSetUp.sql` | Database and table creation, data loading |
| `MotorVehicleProject.sql` | All 9 analysis queries |
| `Motor Normalization.docx` | Normalization documentation (1NF → 3NF) |
| `cleaned_project_data(c).csv` | Cleaned dataset (~281,000 records) |
| `it pro.pbix` | Power BI dashboard file |

## Data Source
New York City motor vehicle collision records (NYPD Motor Vehicle Collisions dataset).
