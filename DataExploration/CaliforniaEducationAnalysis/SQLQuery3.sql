-- What is the percentage of educational attainment for each category across different age group? 
SELECT 
	E.age, 
	E.edu_attainment, 
    SUM(E.Population_Count) / T.total_population *100 AS coefficient
FROM PotentialProject..Educational AS E
JOIN 
	(SELECT Age, SUM(Population_Count) as total_population
	FROM PotentialProject..Educational
	GROUP BY Age) AS T
ON E.age = T.age
GROUP BY E.age, E.edu_attainment, T.total_population;

--create new demographics table from the result 
SELECT 
    E.age, 
    E.edu_attainment, 
    SUM(E.Population_Count) / T.total_population * 100 AS coefficient
INTO demographics -- Use INTO to create a new table
FROM PotentialProject..Educational AS E
JOIN (
    SELECT Age, SUM(Population_Count) AS total_population
    FROM PotentialProject..Educational
    GROUP BY Age
) AS T ON E.age = T.age
GROUP BY E.age, E.edu_attainment, T.total_population;

--Using Population Projection data,
--What is the projection of education demand for each age group?
SELECT 
    temp_pop.Year,
    demographics.Edu_Attainment AS Education,
    ROUND(SUM(temp_pop.Population_Count * demographics.coefficient), 2) AS Demand
FROM
    (SELECT Year, Age, SUM(Population_Count) AS Population_Count
    FROM PotentialProject..Educational
    GROUP BY Age, Year) AS temp_pop
JOIN demographics
    ON (temp_pop.Age < '18' AND demographics.Age = '00 to 17')
    OR (temp_pop.Age >= '18' AND temp_pop.Age < '65' AND demographics.Age = '18 to 64')
    OR (temp_pop.Age >= '65' AND demographics.Age = '65 to 80+')
GROUP BY temp_pop.Year, demographics.Edu_Attainment;






SELECT *
FROM PotentialProject..Educational