create database llin_analysis;
use llin_analysis;

create table llin_distribution (
    ID INT PRIMARY KEY,
    Number_distributed INT,
    Location VARCHAR(255),
    Country VARCHAR(50),
    Year year,
    By_whom VARCHAR(100),
    Country_code CHAR(5)
);

select * from llin_distribution;
# total number of LLINs distributed in each country
select 
Country,
sum(Number_distributed) as number_distributed from
llin_distribution group by Country;

#average number of LLINs distributed per distribution event

select
avg(Number_distributed) as Average_number
from llin_distribution;

#Determine the earliest and latest distribution dates in the dataset.
select
	min(Year) as earliest_year,
    max(Year) as latest_year
from
	llin_distribution;

#Identify the total number of LLINs distributed by each organization. 
select 
	By_whom,
	sum(Number_distributed) as total_number_of_LLINs_distributed
from
	llin_distribution
    group by By_whom ;

#Calculate the total number of LLINs distributed in each year.

select
	Year,
	sum(Number_distributed) as total_number_of_LLINs_distributed
from
	llin_distribution
    group by Year;
#locations with the highest and lowest number of LLINs distributed.
Select
	Location,
    max(Number_distributed) as highest,
    min(Number_distributed) as lowest
From
	llin_distribution
group by Location;

#location with the highest number of LLINS distributed
select 
	Location,
    sum(Number_distributed) as highest
from 
	llin_distribution
group by Location
order by highest DESC
Limit 1;
#location with the lowest number of LLINS distributed
select 
	Location,
    sum(Number_distributed) as lowest
from 
	llin_distribution
group by Location
order by lowest
Limit 1;

#Determine if there's a significant difference in the number of LLINs distributed by different organizations.
select
	By_whom,
    sum(Number_distributed) as N_D
From
	llin_distribution
group by By_whom
order by N_D desc;

#Identify any outliers or significant spikes in the number of LLINs distributed in specific locations or periods.
-- Identifying records with a high number of LLINs distributed (outliers)
SELECT *
FROM llin_distribution
WHERE number_distributed > (
    SELECT AVG(number_distributed) + 3 * STDDEV(number_distributed)
    FROM llin_distribution
);

-- Identifying records with a low number of LLINs distributed (outliers)
SELECT *
FROM llin_distribution
WHERE number_distributed < (
    SELECT AVG(number_distributed) - 3 * STDDEV(number_distributed)
    FROM llin_distribution
);

-- Identify significant spikes by location
SELECT location, Year, number_distributed
FROM llin_distribution
WHERE number_distributed > (
    SELECT AVG(number_distributed) + 2 * STDDEV(number_distributed)
    FROM llin_distribution
    WHERE location = llin_distribution.location
);


