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

select concat(
  floor(avg(length) / 60), 
  ':', 
  lpad(avg(length) % 60, 2, '0')
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
select distinct(datediff('2006-02-14 15:16:03', '2005-05-24 22:53:30')) as total_days
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

-- Lesson 2.6 lab

-- 1. Only last names that appear once
select last_name, count(last_name) as count from actor
group by last_name;

select last_name, count(last_name) as count
from actor
group by last_name
having count = 1;

-- 2. Only last names that appear more than once
select last_name, count(last_name) as count
from actor
group by last_name
having count <> 1;

-- 3. Using the rental table, find out how many 
-- rentals were processed by each employee.
select count(rental_id) as "processed rentals",
staff_id as staff from rental
group by staff;

-- 4. Using the film table, find out how many 
-- films were released each year.
select count(title), release_year from film
group by release_year;

-- 5. Using the film table, find out for each 
-- rating how many films were there.
select count(title), rating from film
group by rating;

-- 6. What is the mean length of the film for
-- each rating type. Round off the average 
-- lengths to two decimal places
select round(avg(length), 2) as average_duration,
rating from film
group by rating;

-- 7. Which kind of movies (rating) have a mean
-- duration of more than two hours?
select round(avg(length), 2) as average_duration,
rating from film
group by rating
having average_duration > 120;

-- 6 Rank films by length (filter out the rows 
-- that have nulls or 0s in length column). 
-- In your output, only select the columns title, 
-- length, and the rank.
SELECT title, length, rank() OVER (PARTITION BY length ORDER BY length) AS 'rank'
FROM film
WHERE length IS NOT NULL
AND length <> 0
ORDER BY length desc;


-- Lab | SQL Join (Part I)

-- 1 How many films are there for each of the
-- categories in the category table. Use appropriate
-- join to write this query.
select c.category_id as cat, count(*) from film as f
join film_category as c
on f.film_id = c.film_id
group by cat
order by cat;

-- 2.Display the total amount rung up by each 
-- staff member in August of 2005.
select distinct(staff_id), sum(amount) as total_amount
from payment
where month(payment_date) = 8
group by staff_id;

-- 3.Which actor has appeared in the most films
SELECT a.actor_id, a.first_name, a.last_name, COUNT(film_id) AS num_films
FROM film_actor fa
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id, a.first_name, a.last_name
ORDER BY COUNT(film_id) DESC
LIMIT 1;

-- 4. Most active customer (the customer that has 
-- rented the most number of films)
select count(*) as number_of_rentals, customer_id from rental
group by customer_id
order by number_of_rentals desc
limit 1;

-- 5. Display the first and last names, as well 
-- as the address, of each staff member.
select distinct staff_id, first_name, last_name, address_id from staff
where staff_id is not null;

-- 6. List each film and the number of actors 
-- who are listed for that film.
select count(actor_id) as num_actors,
film_id from film_actor
group by film_id
order by COUNT(actor_id) DESC;
-- second and prefered option since I can see the
-- movie titles
SELECT f.title, COUNT(actor_id) AS num_actors
FROM film_actor fa
JOIN film f ON fa.film_id = f.film_id
GROUP BY f.title
ORDER BY COUNT(actor_id) DESC;

-- 7. Using the tables payment and customer and the 
-- JOIN command, list the total paid by each 
-- customer. List the customers alphabetically 
-- by last name.

select c.first_name, c.last_name, sum(amount) as amt
from payment p
join customer c
on c.customer_id = p.customer_id
group by c.last_name, c.first_name
order by c.last_name;

-- 8. List number of films per category.
select c.name, count(film_id) as "count" 
from film_category f
left join category c
on f.category_id = c.category_id
group by c.name
order by count(film_id) desc;


