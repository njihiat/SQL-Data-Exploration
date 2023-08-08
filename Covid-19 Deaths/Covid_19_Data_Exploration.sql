select *
from PortfolioProject..CovidDeaths
order by 3,4

--select *
--from PortfolioProject..CovidVacinnations
--order by 3,4

--Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at Total Cases and Total Deaths
-- Wanted to divide total_deats by total_cases but brought an error
-- the division would have showed the likelyhood of dying after contracting Covid

Select location, date, total_cases, total_deaths, 
From PortfolioProject..CovidDeaths
Where location like '%Kenya%'
Order by 1,2

--looking at Total Cases vs population
--- Shows what percentge of population got Covid

Select location, date, total_cases, population, (total_cases/population)*100 as percentange_pop_affected
From PortfolioProject..CovidDeaths
Where location like '%Kenya%'
Order by 1,2

-- Looking at Countries with Highest Infection Rate Compared to Population

Select location, population, MAX(total_cases) as highest_infection_count, Max((total_cases/population))*100 as percent_pop_infected
From PortfolioProject..CovidDeaths
--Where location like '%Kenya%'
Group by location, population
Order by percent_pop_infected desc

-- showing countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as highest_death_count
From PortfolioProject..CovidDeaths
--Where location like '%Kenya%'
where continent is not null
Group by location
Order by highest_death_count desc


--summarizing things by continent
-- Looking at continent with highest death count

Select continent, MAX(cast(total_deaths as int)) as highest_death_count
From PortfolioProject..CovidDeaths
--Where location like '%Kenya%'
where continent is not null
Group by continent
Order by highest_death_count desc

--Global Numbers
-- Failed again to divide by null

Select date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(cast(new_cases as int))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group By date
Order By 1,2

--Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population,
	vac.new_vaccinations,
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinnations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3