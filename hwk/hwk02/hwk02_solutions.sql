/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 02
Assigned 2020/01/16
Due 2020/01/23
Submit 
*/



/*
Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).

This homework uses the DVD rental database.
*/


/*
1. Write a query that returns all distinct dates on which at least one rental occurred, ordered with most recent on top.
*/

select distinct
	cast (rental_date as date)
from
	rental
order by
	rental_date desc
;

/*
2. We wish to email a coupon to all customers who rented at least one film during July, 2005.  Write a query that finds all such customers and returns 2 columns:
- last_name, first_name aliased as full_name
- email
Order by name (A on top).  We haven't covered joins yet, so you can't use them.  Instead use a subquery that builds on problem #1.
*/


select
	last_name || ', ' || first_name as full_name
	, email
from
	customer
where
	customer_id in (
		select distinct
			customer_id
		from
			rental
		where
			cast (rental_date as date) between '2005-07-01' and '2005-07-31'
	)
order by
	full_name
;


/*
3. Write a query to that returns the title, rating, and length of all films that were rented between July 1 and July 7, 2005.  Order by rating (ascending), then by length (longest on top), then by title (A on top).  Note: the rating column seems to already know the "severity" order G-PG-PG13-R-NC17.
*/


select
	title
	, rating
	, length
from
	film
where
	film_id in (
	select distinct
		film_id
	from
		inventory
	where
		inventory_id in (
			select distinct
				inventory_id
			from
				rental
			where
				cast(rental_date as date) between '2005-07-01' and '2005-07-07'
		)
	)
order by
	rating asc
	, length desc
	, title asc
;




/*
4. Repeat #3, but only return films whose title contains the string "doc" (case insensitive).  This means titles containing "Doc" or "DOC" or any variant that only differs by capitalization SHOULD be returned.
*/


select
	title
	, rating
	, length
from
	film
where
	film_id in (
	select distinct
		film_id
	from
		inventory
	where
		inventory_id in (
			select distinct
				inventory_id
			from
				rental
			where
				cast (rental_date as date) between '2005-07-01' and '2005-07-07'
		)
	)
	and lower(title) like '%doc%'
--	and upper(title) like '%DOC%'
--	and title ilike '%doc%'
order by
	rating asc
	, length desc
	, title desc
;
