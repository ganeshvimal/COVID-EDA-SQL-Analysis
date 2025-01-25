-- Covid - 19 Exploratory Project

USE [Covid Portfolio Project];

SELECT * 
FROM CovidDeaths;

select * 
from CovidDeaths
where continent is not null;

-- SELECT * FROM CovidVaccinations;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths; 

-- Total deaths vs total cases
-- Death percentage 
SELECT location, date, total_cases,total_deaths , (total_deaths/total_cases) * 100 AS Death_Percentage
FROM CovidDeaths; 

-- by location death percentage
SELECT location, date, total_cases,total_deaths , (total_deaths/total_cases) * 100 AS Death_Percentage
FROM CovidDeaths
where location = 'United States'; 

-- Total cases vs Population
-- Percentage of population got covid (Affected People)
SELECT location, date, total_cases,population , (total_cases/population) * 100 AS Affected_People
FROM CovidDeaths
where location = 'United States'; 

-- Which country has highest infection rate 

SELECT location, max(total_cases) AS Highest_Infection_Count,population , max((total_cases/population)) * 100 AS Highest_Infection_Rate
FROM CovidDeaths
group by location,population
order by Highest_Infection_Rate desc;
-- Andora has highest infection rate with 17.1%


-- Which country has highest death count per population

SELECT location, max(total_deaths) AS Totaldeathcount
FROM CovidDeaths
group by location
order by Totaldeathcount desc;
-- issue with total death count because of wrong data type hence we need to cast it

SELECT location, max(cast(total_deaths as int)) AS Totaldeathcount
FROM CovidDeaths
where continent is not null
group by location
order by Totaldeathcount desc;

-- By continent highest total death counts 

SELECT continent, max(cast(total_deaths as int)) AS Totaldeathcount
FROM CovidDeaths
where continent is not null
group by continent
order by Totaldeathcount desc;

SELECT location, max(cast(total_deaths as int)) AS Totaldeathcount
FROM CovidDeaths
where continent is null
group by location
order by Totaldeathcount desc;

-- Around the world numbers (world death percentage) according to the date

SELECT date, SUM(new_cases) as Newcases,sum(cast(new_deaths as int)) as Totalnewdeaths,sum(cast(new_deaths as int))/sum(new_cases)* 100 AS World_Death_Percentage
FROM CovidDeaths
where continent is not null
group by date
order by World_Death_Percentage desc;

-- Across the world nos excluding date
SELECT SUM(new_cases) as Newcases,sum(cast(new_deaths as int)) as Totalnewdeaths,sum(cast(new_deaths as int))/sum(new_cases)* 100 AS World_Death_Percentage
FROM CovidDeaths
where continent is not null;

-- Joining both tables on location and date 
Select * from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date


-- Total population & no of vaccinated people
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 1,2,3

-- ROLLING UP TOTAL of new vaccinations (IMPORTANT)
-- need to do partition over location and not continent because at every location when it comes count should start over
-- we use cast to convert from wrong data type
-- Also should order by in partition otherwise it wont work 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Total_Vaccination
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
	order by 2,3

	-- By albania say for example
	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Total_Vaccination
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.location = 'Albania'
	order by 2,3

-- CTE (Using CTE to perform Calculation on Partition By)
-- How many percentage of people were vaccinated in one location ( total rolling vaccination / population)
-- need to put everything in with in cte to what ever u have put in select statement below
WITH PopulationvsVaccination (continent, location, date, population,new_vaccinations, Rolling_Total_Vaccination) as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Total_Vaccination
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.location = 'Albania'
	-- where dea.continent is not null
)
select *, (Rolling_Total_Vaccination/population) * 100 as Percentage_Vaccinated_People from PopulationvsVaccination


-- Temp Tables - we can also do by temp tables instead of CTE

DROP Table if exists #PercentageVaccinatedPeople
Create Table #PercentageVaccinatedPeople
( continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_Total_Vaccination numeric
)

INSERT INTO #PercentageVaccinatedPeople
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Total_Vaccination
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.location = 'Albania'

select *, (Rolling_Total_Vaccination/population) * 100 as Percentage_Vaccinated_People from #PercentageVaccinatedPeople

-- Creating Views

Create View Percentage_Vaccinated_People as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Total_Vaccination
from CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
	where dea.location = 'Albania'
	-- where dea.continent is not null 

select * from Percentage_Vaccinated_People


