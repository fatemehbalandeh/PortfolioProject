SELECT * FROM suicide

--1.Total Suicide Rate By Country
SELECT Country, SUM("SuicideRate") AS TotalSuicideRate
FROM suicide
GROUP BY Country;

--2.Country with the highest suicide rate in a specific year
--SELECT S.Country, T.MaxSuicideRate, T.Year
--FROM SuicideProject..suicide AS S
--JOIN
--(SELECT Year, MAX(SuicideRate) AS MaxSuicideRate
--FROM suicide
--GROUP BY Year) AS T
--ON S.Year = T.Year AND S.SuicideRate = T.MaxSuicideRate
--ORDER BY Year;
WITH RankedSuicideRates AS (
    SELECT 
        Year,
        Country,
        SuicideRate,
        ROW_NUMBER() OVER (PARTITION BY Year ORDER BY SuicideRate DESC) AS Rank
    FROM suicide
)
SELECT 
    Year,
    Country,
    SuicideRate AS HighestSuicideRate
FROM RankedSuicideRates
WHERE Rank = 1;


--3.Calculate the average suicide rate by sex across all countries
SELECT Sex, AVG(SuicideRate) AS AvgSuicideRate
FROM suicide
GROUP BY Sex;

--4.Identify the country with the highest male suicide rate
SELECT Country, MAX(SuicideRate) AS HighestMaleSuicideRate
FROM suicide
WHERE Sex = 'Male'
GROUP BY Country;




