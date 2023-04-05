-- Intro to SQL labs

-- 1. Use sakila database.
USE sakila;

-- 2. Get all the data from tables actor, film and customer.
select * from actor;
select * from film;
select * from customer;

-- 3. Get film titles.
select title from film;

-- 4. Get unique list of film languages under 
-- the alias language. Note that we are not 
-- asking you to obtain the language per each film,
-- but this is a good time to think about how you 
-- might get that information in the future.
select distinct(language_id) as language from film;

-- 5.1 Find out how many stores does the company have?
select count(store_id) from store;

-- 5.2 Find out how many employees staff does the company have
select count(*) as num_employees from staff;

-- 5.3 Return a list of employee first names only
select distinct(first_name) from staff;


-- Lesson 2.5 lab

-- 1. Select all the actors with the first name ‘Scarlett’.
select * from actor
where first_name = "Scarlett";

-- 2. How many physical copies of movies are available 
-- for rent in the store's inventory? How many 
-- unique movie titles are available?
select count(film_id) from inventory;
select count(distinct(film_id)) as available from inventory;

-- 3. What are the shortest and longest movie
-- duration? Name the values max_duration and 
-- min_duration.
select
min(length) as min_duration,
max(length) as max_duration 
from film;

-- 4. What's the average movie duration expressed in 
-- format (hours, minutes)?
select time_format(sec_to_time(avg(length * 60)), '%H:%i') as avg_duration FROM film;

select CONCAT(
  FLOOR(avg(length) / 60), 
  ':', 
  LPAD(avg(length) % 60, 2, '0')
) as avg_duration
from film;

-- 5. How many distinct (different) actors' 
-- last names are there?
select count(distinct(last_name)) from actor;

-- 6 How many days was the company operating? 
-- Assume the last rental date was their closing 
-- date. (check DATEDIFF() function)
select 
datediff
(max((rental_date)), 
min((rental_date)))
as op_days from rental;

-- I used the weird approach below when I was
-- having issues with the datediff
select max((rental_date)) from rental;
select min((rental_date)) from rental;
select distinct(DATEDIFF('2006-02-14 15:16:03', '2005-05-24 22:53:30')) AS total_days
from rental;

-- 7.Show rental info with additional columns
-- month and weekday. Get 20 results.
select *, month(rental_date) AS "month", dayname(rental_date) as weekday
from rental
limit 20;

-- 8. Add an additional column day_type 
-- with values 'weekend' and 'workday' depending 
-- on the rental day of the week.
select *,
case dayofweek(rental_date)
when 6 then 'weekend'
when 7 then 'weekend'
else 'workday'
end as day_type
from rental;

-- 9 Get release years.
select distinct(release_year) from film;

-- 10. Get all films with ARMAGEDDON in the title.
select title from film
where title like "ARMAGEDDON%";

-- 11 Get all films which title ends with APOLLO.
select title from film
where title like "%APOLLO";

-- 12 Get of 10 the longest films.
select title, length from film
order by length desc
limit 10;

-- 13 How many films include Behind the Scenes content?
select distinct special_features from film;
select count(distinct title) from film
where special_features = "Behind the Scenes";