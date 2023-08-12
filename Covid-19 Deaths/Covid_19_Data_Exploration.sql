/*
Covid 19 Data Exploration 

Skills used: 
1. Converting Data types using CAST() function
2. Performing Calculations on the data
3. Aggregate functions
4. Use of CASE control structure

In this Exploration, I used cast often to change the data type from nvarchar to those types that calculations won't run into an error
*/

--Querying all the data ordered by columns 3 and 4. The where clause excludes the data on the world.
select *
from PortfolioProject..CovidDeaths
Where continent is not NULL
Order By 3,4

--Select the Data that we are going to be using. This excludes the data on other columns that aren't in focus.
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

/*Looking at Total Cases, Total Deaths, and the date they were recorded in Kenya ordered by columns 1 and then 2
	This query utilizes the CAST function to convert columns that are nvarchar to DECIMAL for calculations 
	The query shows a DeathPercentage of 1.654 as of 26th July 2023
*/
Select location, date, total_cases, total_deaths, (CAST(total_deaths AS DECIMAL)/CAST(total_cases AS DECIMAL)) as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Kenya%'
Order by 1,2

--looking at Total Cases vs population. This shows a 0.636% of the population affected as of 26th July 2023
Select location, date, total_cases, population, (CAST(total_cases AS FLOAT)/population)*100 as percentange_pop_affected
From PortfolioProject..CovidDeaths
Where location like '%Kenya%'
Order by 1,2

/*
Looking at Countries with Highest Infection Rate Compared to Population.
	In this query, CAST() transformed the total cases from nvarchar to INT. Using MAX() returned 99999 as the 
	highest total cases, nvarchar values are sorted in lexicographic order. By casting, I effectively converted the string
	representation of the numbers to actual numerical values
*/	
Select location, population, MAX(CAST(total_cases as INT) as highest_infection_count, Max((total_cases/population))*100 as percent_pop_infected
From PortfolioProject..CovidDeaths
--Where location like '%Kenya%'
Group by location, population
Order by percent_pop_infected desc

/*
	Looking at the countries with their highest death count. This query shows that USA recorded the highest death count
	as of 26th July 2023 with 1127152 people succumbing to Covid-19.
*/
Select location, MAX(CAST(total_deaths AS int)) AS highest_death_count
From PortfolioProject..CovidDeaths
--Where location like '%Kenya%'
where continent is not null
Group by location
Order by highest_death_count desc


--summarizing things by continent
/*
Looking at the continent with the highest death count. Turns out North America leads followed closely by South America.
	The query results are as follows:
	North America	1127152
	South America	704488
	Asia		531915
	Europe		399814
	Africa		102595
	Oceania		22308
*/
Select continent, MAX(cast(total_deaths as int)) as highest_death_count
From PortfolioProject..CovidDeaths
--Where location like '%Kenya%'
where continent is not null
Group by continent
Order by highest_death_count desc

--Looking at total population vs new vaccinations. This query utilizes join on another table called Vaccinations
Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations,
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinnations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

---- Looking at countries with the Highest infection rate compared to the population.
-- The query shows that Cyprus has the highest infection count to population. 73% of Cyprus's population has been infected with Covid 19. San Marino
	--comes second with 72%
SELECT location, population, MAX(CAST(total_cases AS INT)) as HighestInfectionCount,
(MAX(CAST(total_cases AS FLOAT))/CAST(population as FLOAT))*100 as PersonInfectedPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PersonInfectedPercentage DESC

--Check all new cases by date, and percentage of new deaths based on New Cases.
	--This query shows that 30th March 2023 had the highest number of Deaths compared to New cases.
SELECT date,
       SUM(new_cases) as NewCases,
       SUM(CAST(new_deaths as Float)) as NewDeaths,
       CASE
           WHEN SUM(CAST(new_cases AS Float)) = 0 THEN NULL
           ELSE ROUND(SUM(CAST(new_deaths as Float)) / NULLIF(SUM(CAST(new_cases AS Float)), 0) * 100, 3)
       END as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
GROUP BY date
ORDER BY DeathPercentage DESC


