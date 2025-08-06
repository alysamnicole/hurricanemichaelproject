-- Structure for unified table
CREATE TABLE IF NOT EXISTS weather_data (
    station_id TEXT,
    "timestamp" TIMESTAMPTZ,
    air_temp_f FLOAT,
    wind_speed_knots FLOAT,
    wind_gust_knots FLOAT,
    wind_dir_deg INT,
    wind_cardinal TEXT,
    pressure_mb FLOAT,
    latitude FLOAT,
    longitude FLOAT,
    elevation_ft FLOAT
);


-- Query to retrieve pressure data from the unified table
SELECT station_id, timestamp, pressure_mb
FROM weather_data
WHERE pressure_mb IS NOT NULL
ORDER BY station_id, timestamp;

-- Query to find the first occurrence of high wind gusts (>= 64 knots) for each station
SELECT station_id, MIN(timestamp) AS first_high_gust
FROM weather_data
WHERE wind_gust_knots >= 64
GROUP BY station_id;

-- Query to calculate hourly average wind speed and pressure for each station
SELECT 
    station_id,
    date_trunc('hour', "timestamp") AS hour_block,
    AVG(wind_speed_knots) AS avg_wind_speed,
    AVG(pressure_mb) AS avg_pressure
FROM weather_data
GROUP BY station_id, hour_block
ORDER BY hour_block;

-- Query to find the maximum sustained wind speed, maximum wind gust, and minimum pressure for each station
SELECT 
    station_id,
    MAX(wind_speed_knots) AS max_sustained_wind,
    MAX(wind_gust_knots) AS max_wind_gust,
    MIN(pressure_mb) AS min_pressure
FROM weather_data
GROUP BY station_id;

-- Query to count the number of hours each station experienced hurricane-force winds (>= 64 knots)
SELECT 
    station_id, 
    COUNT(*) AS hurricane_force_hours
FROM weather_data
WHERE wind_speed_knots >= 64
GROUP BY station_id;
