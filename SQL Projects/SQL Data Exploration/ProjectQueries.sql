USE [Portfolio Project]
GO
-- Checking up the newly created table
 SELECT TOP 1000 * FROM ['owid-covid-data(original)$']

-- Transferring data into CovidDeaths and CovidVaccinations
 SELECT * INTO CovidDeaths FROM dbo.['owid-covid-data(original)$']
 dbo.['owid-covid-data(original)$'] is deleted and re-imported to
 fill up CovidVaccinations
 SELECT * INTO CovidVaccinations FROM dbo.['owid-covid-data(original)$']

-- Initial lookup of data
SELECT TOP 100  * FROM CovidDeaths ORDER BY 3, 4
SELECT TOP 1000 * FROM CovidVaccinations ORDER BY 3, 4

-- Dropping unused table
-- DROP TABLE dbo.['owid-covid-data(original)$']

-- Select data we're going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- Finding the data type of columns
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'CovidDeaths'

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CovidVaccinations'

-- Changing the data types of total cases & total deaths to float
ALTER TABLE CovidDeaths
ALTER column total_deaths float NULL;

-- Replacing the data value of 'NULL' to '0' in total cases & total deaths
BEGIN TRANSACTION 
UPDATE CovidDeaths 
SET total_cases = 0 WHERE total_cases IS NULL
UPDATE CovidDeaths
SET total_deaths = 0 WHERE total_deaths IS NULL
COMMIT;

--------------------------------------------------------------------
-- Breaking it down by country

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying you if contract Covid in US
SELECT location, date, total_cases, total_deaths,
(total_deaths / total_cases) * 100 AS 'Death Percentage'
FROM CovidDeaths
WHERE total_cases <> 0 AND Location LIKE 'India' AND continent IS NOT NULL
ORDER BY 1, 2;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT location, date, population, total_cases,
(total_cases / population) * 100 AS 'Covid Infected %'
FROM CovidDeaths
-- WHERE Location LIKE 'United States'
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Looking at countries with highest infection rate vs population
SELECT location, population, MAX(total_cases) AS 'Highest Infection Count',
MAX((total_cases / population)) * 100 AS 'Covid Infected %'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, population
ORDER BY 'Covid Infected %' DESC;

-- Looking at countries highest Covid death count per population
SELECT location, MAX(total_deaths) AS 'Total Deaths'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY 'Total Deaths' DESC;

-----------------------------------------------------------------

-- Breaking down the data by continent

-- Highest total deaths by continent
SELECT continent, MAX(total_deaths) AS 'Total Deaths'
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Total Deaths' DESC;

-- Looking at Total Cases vs Total Population by continent
SELECT continent, MAX(total_cases) AS 'Total Cases',  MAX(population) AS 'Total Population',
(MAX(total_cases) / MAX(population)) * 100 AS 'Covid Infected %'
FROM CovidDeaths
-- WHERE Location LIKE 'United States'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 'Covid Infected %' DESC;

-- Looking at Total Cases vs Total Deaths by continent
SELECT continent, MAX(total_cases) AS 'Total Cases', MAX(total_deaths) AS 'Total Deaths',
(MAX(total_deaths)/ MAX(total_cases)) * 100 AS 'Covid Deaths %'
FROM CovidDeaths
WHERE total_cases <> 0 AND continent IS NOT NULL
GROUP BY continent
ORDER BY 'Covid Deaths %' DESC;

------------------------------------------------------------------

-- GLOBAL NUMBERS

SELECT /*date*/ SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 
(SUM(new_deaths) / SUM(new_cases)) * 100 AS 'Death %' 
FROM CovidDeaths
WHERE continent IS NOT NULL and new_cases <> 0
-- GROUP BY date
ORDER BY 1, 2;

-------------------------------------------------------------------

-- Looking at Total Population vs Vaccination
-- Using CTE
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float, vac.new_vaccinations))
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
	JOIN CovidVaccinations vac 
		ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS '% Vaccinated Population' FROM PopvsVac;

-- Using Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(numeric, vac.new_vaccinations))
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
	JOIN CovidVaccinations vac 
		ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2, 3
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS '% Vaccinated Population' 
FROM #PercentPopulationVaccinated

-----------------------------------------------------------------

-- Creating view to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(numeric, vac.new_vaccinations))
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
	JOIN CovidVaccinations vac 
		ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * FROM PercentPopulationVaccinated;

