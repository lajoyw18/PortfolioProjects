Select *
from CovidDeaths
order by 3,4

--Select *
--from CovidVaccinations
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths
-- shows likelihood of dying if you contract covid in U.S

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%States%'
order by 1,2

--Looking at Total Cases vs Population
-- shows what percentageof population got covid

Select location, date, population, total_cases,(total_cases/population)*100 as CasesPerPopulationPercentage
From CovidDeaths
Where location like '%States%'
order by 1,2

--countries with highest infection rates compared to population

Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as CasesPerPopulationPercentage
From CovidDeaths
group by location,population
order by CasesPerPopulationPercentage DESC

--Countries with highest death count per population

Select location, max(cast(total_deaths as int)) as HighestDeathsCount
From CovidDeaths
where continent is not null
group by location
order by HighestDeathsCount DESC

-- breaking it down by continents

Select continent, max(cast(total_deaths as int)) as TotalDeathsCount
From CovidDeaths
where continent is not null
group by continent
order by TotalDeathsCount DESC


-- giving more accurate results for total death count for continent based on null values in table
Select location, max(cast(total_deaths as int)) as TotalDeathsCount
From CovidDeaths
where continent is null and location not like '%income%'
group by location
order by TotalDeathsCount DESC

--Global (total cases, deaths, and percentages of deaths per cases a day

Select date, sum(new_cases) as NewDailyCases, 
sum(cast(new_deaths as int))as NewDailyDeaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as DailyDeathPercentage
From CovidDeaths
where continent is not null
group by date
order by 1,2

--current death percentage total
Select sum(new_cases) as TotalCases, 
sum(cast(new_deaths as int))as TotalDeaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalDeathPercentage
From CovidDeaths
where continent is not null


-- total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location
and  dea.date = vac.date
where dea.continent is not null
order by 2,3

-- using cte

With PopvsVac as (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location
and  dea.date = vac.date
where dea.continent is not null)
select*, (rollingpeoplevaccinated/population)*100 as RollingVaccinationPercent
from PopvsVac

--temp table
drop table if exists #Percentpopulationvaccinated

create table #Percentpopulationvaccinated
(Continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric,
rollingpeoplevaccinated numeric)
insert into #Percentpopulationvaccinated 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location
and  dea.date = vac.date
where dea.continent is not null

select*, (rollingpeoplevaccinated/population)*100 as populationvacinatedpercent
from #Percentpopulationvaccinated

-- creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations vac on dea.location = vac.location
and  dea.date = vac.date
where dea.continent is not null)

Select *
from PercentPopulationVaccinated 
