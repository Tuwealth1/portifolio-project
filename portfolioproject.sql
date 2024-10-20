
select * 
from portfolioproject.dbo.covid1
order by 1,2

select * 
from portfolioproject.dbo.covid2
order by 3,4


select location, date, total_cases, total_deaths, population
from portfolioproject.dbo.covid1
order by 1,2



select people_fully_vaccinated , new_tests_smoothed
from portfolioproject.dbo.covid2
order by 1,2

---looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 deathpercentage
from portfolioproject.dbo.covid1
where total_cases <> 0 and total_deaths <> 0
order by 1,2

select location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 as totalcasespercentage 
from portfolioproject.dbo.covid1
where total_cases <> 0 and total_deaths <> 0
order by 3,2

--looking at the total cases vs populaton
select location, date,population, total_cases,  (total_cases/population)*100 as populationpercentage
from portfolioproject.dbo.covid1
where total_cases <> 0 and population<> 0
order by 3,2

--looking at the highest number of infection rate to popolation

select location, date, max(total_cases)as highestinfectioncount, population,  max(total_cases/population)*100 as populationpercentage
from portfolioproject.dbo.covid1
where total_cases <> 0 and population<> 0
group by location, date, total_cases, population
order by 1,2

select location, max(cast(total_deaths as int)) as totaldeathcounts
from portfolioproject.dbo.covid1
where total_deaths > 20
group by location, total_deaths
order by total_deaths desc


select continent, max(cast(total_deaths as int)) as totaldeathcounts
from portfolioproject.dbo.covid1
where continent is not null
group by continent, total_deaths
order by total_deaths desc
 
 
select location, max(cast(total_deaths as int)) as totaldeathcounts
from portfolioproject.dbo.covid1
where continent is not null
group by location, total_deaths
order by total_deaths desc



--showing the continent the highest death couts
select location, max(cast(total_deaths as int)) as totaldeathcounts
from portfolioproject.dbo.covid1
where continent is not null
group by location, total_deaths
order by total_deaths desc


---global numbers 

select continent, date, sum(total_cases) as totalcases, sum(total_deaths) as totaldeaths, 
sum(cast(new_deaths as int))/sum(cast(new_cases as int))*100 as per
from portfolioproject.dbo.covid1
where total_cases is not null and total_deaths is not null 
and continent is not null and  new_cases <> 0 and new_deaths <> 0
group by continent, date, total_cases
order by 1,2

select date, sum(total_cases) as totalcases, sum(total_deaths) as totaldeaths, 
sum(new_deaths/new_cases)*100 as newcasespercentage
from portfolioproject.dbo.covid1
where total_cases is not null and total_deaths is not null 
and continent is not null and  new_cases <> 0 and new_deaths <> 0
group by date, total_cases
order by 1,2

select sum(total_cases) as totalcases, sum(total_deaths) as totaldeaths, 
sum(new_deaths/new_cases)*100 as newcasespercentage
from portfolioproject.dbo.covid1
where total_cases is not null and total_deaths is not null 
and continent is not null and  new_cases <> 0 and new_deaths <> 0
group by total_cases 
order by total_cases, 1,2

--total sum 
select SUM(total_cases) as totalcases, SUM(total_deaths) as totaldeaths, SUM(population) as population
from covid1

--join
select *
from portfolioproject.dbo.covid1 c1
left outer join portfolioproject.dbo.covid2 c2
on c1.iso_code= c2.new_tests
	order by 1,2


	select c1.continent,c1.location,c1.DATE, c1.population,c2.new_vaccinations
from portfolioproject.dbo.covid1 c1
left outer join portfolioproject.dbo.covid2 c2
on c1.iso_code= c2.new_tests
where continent is not null
	order by 3,2,1

	select c1.continent,c1.location,c1.DATE, c1.population,c2.new_vaccinations,
	sum(CONVERT(INT,c2.new_vaccinations)) over (partition by c1.location ORDER BY C1.LOCATION,  C1.DATE) AS ROLLINGVACINATION
from portfolioproject.dbo.covid1 c1
LEFT OUTER  join portfolioproject.dbo.covid2 c2
on c1.iso_code= c2.new_tests
where  continenT IS NOT NULL 
	order by 1,2


	--USE CTE
	
	WITH POPSVAC(CONTINENT, LOCATION, DATE, POPULATION, NEW_VACCINATIONS, ROLLINGVACINATION)
	AS
	(
	select c1.continent,c1.location,c1.DATE, c1.population,c2.new_vaccinations,
	sum(CONVERT(INT,c2.new_vaccinations)) over 
	(partition by c1.location ORDER BY C1.LOCATION,  C1.DATE) AS ROLLINGVACINATION
	--,(ROLLINGVACINATION/POPULATION)*100
	from portfolioproject.dbo.covid1 c1
	LEFT OUTER  join portfolioproject.dbo.covid2 c2
on c1.iso_code= c2.new_tests
where  continenT IS NOT NULL 
	--order by 1,2
	)
	SELECT *,(ROLLINGVACINATION/POPULATION)*100
	FROM POPSVAC


	--TEMP TABLE 
	
	DROP TABLE IF EXISTS #PERCENTAGEPOPULATIONVACCINATED
	CREATE TABLE #PERCENTAGEPOPULATIONVACCINATED
	(CONTINENT NVARCHAR(255),
	LOCATION NVARCHAR(255),
	DATE DATETIME,
	POPULATION NUMERIC,
	NEW_VACCINATIONS NUMERIC,
	ROLLINGVACINATION NUMERIC,
	)


	INSERT INTO #PERCENTAGEPOPULATIONVACCINATED
	select c1.continent,c1.location,c1.DATE, c1.population,c2.new_vaccinations,
	sum(CONVERT(INT,c2.new_vaccinations)) over 
	(partition by c1.location ORDER BY C1.LOCATION,  C1.DATE) AS ROLLINGVACINATION
	--,(ROLLINGVACINATION/POPULATION)*100
	from portfolioproject.dbo.covid1 c1
	LEFT OUTER  join portfolioproject.dbo.covid2 c2
on c1.iso_code= c2.new_tests
where  continenT IS NOT NULL 
	--order by 1,2

	SELECT *,(ROLLINGVACINATION/POPULATION)*100
	FROM #PERCENTAGEPOPULATIONVACCINATED



	CREATE VIEW PERCENTAGEPOPULATIONVACCINATED AS
	select c1.continent,c1.location,c1.DATE, c1.population,c2.new_vaccinations,
	sum(CONVERT(INT,c2.new_vaccinations)) over (partition by c1.location ORDER BY C1.LOCATION,  C1.DATE) AS ROLLINGVACINATION
from portfolioproject.dbo.covid1 c1
LEFT OUTER  join portfolioproject.dbo.covid2 c2
on c1.iso_code= c2.new_tests
where  continenT IS NOT NULL 
	--order by 1,2



create view total_deaths as
select sum(total_cases) as totalcases, sum(total_deaths) as totaldeaths, 
sum(new_deaths/new_cases)*100 as newcasespercentage
from portfolioproject.dbo.covid1
where total_cases is not null and total_deaths is not null 
and continent is not null and  new_cases <> 0 and new_deaths <> 0
group by total_cases 
--order by total_cases, 1,2
