Select *
From PortofolioProject..CovidDeaths
Where continent is not null
order by 3,4

Select *
From PortofolioProject..CovidVaccinations
Where continent is not null
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortofolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid

Select Location, date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at Countries with Highest Infectiom Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Break things down by continent

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
Where continent is null
Group by location
order by TotalDeathCount desc


--Showing continent with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

Select *
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location)
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--Population vs Vaccinations or PopvsVac

--Use CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortofolioProject..CovidDeaths dea
Join PortofolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulationVaccinated













