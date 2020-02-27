/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 04
Assigned 2020/01/23
Due 2020/01/30
*/


/*
Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).
This homework uses the DVD rental database.

Our inventory often contains multiple copies of the same film.  We want to compute the total value (ie. replacement_cost) of our inventory using different groupings.
*/


/*
1. First, we need to join the information on the film table to the inventory table.  Write a query that creates a table called "t1" with a row for each item in the INVENTORY with all corresponding FILM information (title, rating, etc).
columns of film.
*/

drop table t1;
create table t1 as(
	select
		B.*
		, A.store_id
		
	from
		inventory A
	left join
		film B
	on
		A.film_id = B.film_id
);


/*
2. Write a query that computes the total_value of our inventory using table t1.  This is very short, so write as one-line.
*/

select sum(replacement_cost) as total_value from t1;


/*
3. Write a query that returns one row for every distinct RATING (G, PG, PG-13, R, NC-17) with with the following columns:
- rating
- number in inventory - alias as "N"
- replacement_cost of entire inventory - alias as "inventory_value"
- inventory_value / total_value * 100 - alias as "inventory_pct"
order by inventory_pct (biggest on top)
*/

select 
	rating
	, count(1) as N
	, sum(replacement_cost) as inventory_value
	, sum(replacement_cost)/ (select sum(replacement_cost) from t1) * 100 as inventory_pct
from
	t1
group by
	rating
order by
	inventory_pct desc
;


/*
4. Write a query that returns one row for every distinct FILM with with the following columns
- title
- rating
- replacement_cost of ONE item
- number in inventory - alias as "N"
- replacement_cost of entire inventory - alias as "inventory_value"
- inventory_value / total_value * 100 - alias as "inventory_pct"
order by inventory_pct (biggest on top), then by title (A on top).

Hint: You may get errors such as:

column "t1.title" must appear in the GROUP BY clause or be used in an aggregate function

when you group by film_id.  This is annoying because every title in the same group must be the same.  So, this **should** work because there is no ambiguity.  But it does not.

There are several work-arounds
a) select max(title) rather than title - I think this is ugly and can cause issues if you want to order by title also
b) group by film_id, title (even though it does not really need title)
b') There is a shortcut for b using numbers in the group by.  Example:

select
	film_id
	, title
	, count(1)
from
	t1
group by 
	film_id, title


can be shortened to


select
	film_id
	, title
	, count(1)
from
	t1
group by 
	1, 2
*/

select 
	title
	, rating
	, replacement_cost
	, count(1) as N
	, sum(replacement_cost) as inventory_value
	, sum(replacement_cost)/ (select sum(replacement_cost) from t1) * 100 as inventory_pct
from
	t1
group by
	1, 2, 3
order by
	inventory_value desc
	, title
;