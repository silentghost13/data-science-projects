--COVID 19 DATA EXPLORATION
--Dataset : https://ourworldindata.org/coronavirus
--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Converting Data Types, Creating Views

SELECT *
FROM covid..covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, date;

--Shows data
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid..covid_deaths
ORDER BY location, date;

--Shows the probability of dying if you are infected by covid in Indonesia
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid..covid_deaths
WHERE location = 'Indonesia'
ORDER BY location, date;

--Shows how many percentage of population infected by covid in Indonesia
SELECT location, date, population, total_cases, (total_cases/population)*100 as covid_percentage
FROM covid..covid_deaths
WHERE location = 'Indonesia'
ORDER BY location, date;

--Shows country with highest infection rate compared to Population
SELECT location, population, MAX(total_cases) as highest_infection_count, 
	MAX((total_cases/population))*100 as infected_population_percentage
FROM covid..covid_deaths
GROUP BY location, population
ORDER BY infected_population_percentage DESC;

--Shows location with highest death count per population
SELECT location, MAX(CAST(total_deaths as int)) as total_death_count
FROM covid..covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

--Shows continents with highest death count per population
SELECT continent, MAX(CAST(total_deaths as int)) as total_death_count
FROM covid..covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;


--Global Number

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM covid..covid_deaths
WHERE continent IS NOT NULL
ORDER BY total_cases, total_deaths;

--Shows population that has received at least one covid vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(float, vac.new_vaccinations)) 
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

--Shows percentage of population that has received at least one covid vaccine
--Using CTE to perform calculation on PARTITION BY in previous query
WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as 
(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CONVERT(float, vac.new_vaccinations)) 
		OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
	FROM covid..covid_deaths dea
	JOIN covid..covid_vaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/population)*100 as vaccinated_percentage
FROM PopvsVac;

--Using temp table to perform calculation on PARTITION BY in previous query
DROP TABLE IF EXISTS #population_vaccinated_percentage
CREATE TABLE #population_vaccinated_percentage
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population float,
new_vaccinations float,
rolling_people_vaccinated float
)

INSERT INTO #population_vaccinated_percentage
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(float, vac.new_vaccinations))
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	
SELECT *, (rolling_people_vaccinated/population)* 100 as population_vaccinated_percentage
FROM #population_vaccinated_percentage;

--Creating view to store data for visualizations
CREATE VIEW population_vaccinated_percentage as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(float, vac.new_vaccinations))
	OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM covid..covid_deaths dea
JOIN covid..covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
