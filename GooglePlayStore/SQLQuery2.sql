SELECT * FROM GooglePlayStore..googleplaystore


--1. 5 most installed Apps
SELECT TOP 5 App, 
       CAST(REPLACE(REPLACE(installs, ',', ''), '+', '') AS INT) AS Installs
FROM GooglePlayStore..googleplaystore
ORDER BY Installs DESC

--2. Most Installed Genres
SELECT TOP 5 Genres,
       SUM(CAST(REPLACE(REPLACE(installs, ',', ''), '+', '') AS BIGINT)) AS TotalInstalls
FROM GooglePlayStore..googleplaystore
GROUP BY Genres
ORDER BY TotalInstalls DESC;
--3. The percentage of each cetegory by the apps available

WITH TrimmedGenres AS (
    SELECT 
        CASE 
            WHEN CHARINDEX(';', Genres) > 0 THEN LEFT(Genres, CHARINDEX(';', Genres) - 1)
            ELSE Genres
        END AS CleanedGenres,
        *
    FROM GooglePlayStore..googleplaystore
),
TotalGenreCount AS (
    SELECT COUNT(*) AS TotalCounts
    FROM TrimmedGenres
)

SELECT TOP 20
    CleanedGenres AS Genres,
    (COUNT(*) * 100.0) / TotalGenreCount.TotalCounts AS GenrePercentage
FROM TrimmedGenres
CROSS JOIN TotalGenreCount
GROUP BY CleanedGenres, TotalGenreCount.TotalCounts
ORDER BY GenrePercentage DESC;

----4. Number of installations per category:
--SELECT Category, SUM(CAST(REPLACE(REPLACE(installs, ',', ''), '+', '') AS bigint)) AS TotalInstalls
--FROM GooglePlayStore..googleplaystore
--GROUP BY Category;

--4 Top 10 most reviewed apps:
SELECT TOP 10 App, Reviews
FROM (
    SELECT DISTINCT App, Reviews
    FROM GooglePlayStore..googleplaystore
) AS subquery
ORDER BY Reviews DESC;








