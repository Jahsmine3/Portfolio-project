-- Displaying covid desths & vaccines
select * from portfolioproject.coviddeaths
order by 3,4;
select * from portfolioproject.covidvaccines
order by 3,4;

-- Sorting covid deaths
select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject.coviddeaths
order by 1,2

-- Finding death percentage in africa
select location, date, total_cases, population, (total_deaths/population)*100 as Death_percentage
from portfolioproject.coviddeaths
where location like '%africa%'
order by 1,2

-- Finding highest case percentage
select location, population, max(total_cases) as max_cases,  max((population/total_cases))*100 
as Case_percentage
from portfolioproject.coviddeaths
group by location, population
order by Case_percentage desc

-- Finding highest number of total deaths, grouping by location(descending order)
select location, max(total_deaths) as max_death
from portfolioproject.coviddeaths
where continent is not null
group by location
order by max_death desc

-- Finding highest number of total deaths, grouping by location
select location, max(total_deaths) as Max_death
from portfolioproject.coviddeaths
where continent is not null
group by location
order by Max_death

-- Finding highest number of total deaths, grouping by continent
select continent, max(total_deaths) as Max_death
from portfolioproject.coviddeaths
where continent is not null
group by continent
order by Max_death

-- Joining coviddeaths and projectvaccines
select * 
from portfolioproject.coviddeaths dea
join portfolioproject.covidvaccines vac
on dea.location = vac.location
and dea.date = vac.date