CREATE DATABASE E_Scooter;

USE E_Scooter;

CREATE TABLE Cities (
    city_ID INT, 
    city_name VARCHAR(100), 
    country VARCHAR(250),
    PRIMARY KEY (city_ID)
);

CREATE TABLE Airports (
	city_ID INT,
    city_name VARCHAR(50),
    ICAO CHAR(4),
	country VARCHAR(250),
    PRIMARY KEY (ICAO),
    FOREIGN KEY (city_ID) REFERENCES Cities(city_ID)
);

CREATE TABLE Weather (
	city_id INT,
    country VARCHAR(50),
    time_Stamp DATETIME,
    temperature FLOAT(4),
    feels_Temperature FLOAT(4),
    weather VARCHAR(100),
    weather_desc VARCHAR(150),
    wind_Speed FLOAT(4),
    risk_Rain FLOAT(4),
    retrieve_Date DATETIME,
    FOREIGN KEY (city_id) REFERENCES Cities(city_ID)
);

CREATE TABLE Flights (
	arrival_icao CHAR(4),
    arrival_time_local DATETIME,
    arrival_terminal VARCHAR(50),
    departure_city VARCHAR(50),
    departure_icao CHAR(4),
    departure_time_local DATETIME,
    airline VARCHAR(50),
    flight_number VARCHAR(50),
    data_retrieved_on DATETIME,
    FOREIGN KEY (arrival_icao) REFERENCES Airports(ICAO)
);

CREATE TABLE Cities_Infos (
	city_ID INT,
    city_name VARCHAR(50),
	country	VARCHAR(50),
    population VARCHAR(50),
	latitude VARCHAR(50),
	longitude VARCHAR(50),
    FOREIGN KEY (city_id) REFERENCES Cities(city_ID)
    
);

SELECT * FROM Airports;
SELECT * FROM Cities;
SELECT * FROM Cities_Infos;
SELECT * FROM Flights;
SELECT * FROM Weather;


