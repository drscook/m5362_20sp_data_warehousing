/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 03
Assigned 2020/01/21
Due 2020/01/28
*/


/*
Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).

This homework uses the DVD rental database.
*/



/*
1. Write a query that returns one row for every rental that occurred during July 2005 with the following columns:
- rental_date
- return date
- customer full_name ("Cook, Scott")
- customer email address
Order by full_name (A on top), then by rental_date (earliest on top), then by return_date (earliest on top).
*/


select
	A.rental_date
	, A.return_date
	, B.last_name || ', ' || B.first_name as full_name
	, B.email
from
	rental A
left join
	customer B
on
	A.customer_id = B.customer_id
where
	cast (A.rental_date as date) between '2005-07-01' and '2005-07-31'
order by
	full_name
	, rental_date
	, return_date
;


/*
2. Expand the query from #1 so that it also returns:
- customer postal_code
- customer phone number
You will need nested joins, which have the basic structure shown below.  Note that each join can also have clauses like where, order by, etc.

select
	C.cols
	D.cols
from (
	select
		A.cols
		B.cols
	from
		table as A
	??? join
		table as B
	on
		(join conditions for A & B)
) as C
??? join
	table as D
on
	(join conditions for C & D)
*/


select
	C.*
	, D.postal_code
	, D.phone
from (
	select
		A.rental_date
		, A.return_date
		, B.last_name || ', ' || B.first_name as full_name
		, B.email
		, B.address_id
	from
		rental as A
	left join
		customer as B
	on
		A.customer_id = B.customer_id
	where
		cast (A.rental_date as date) between '2005-07-01' and '2005-07-31'
	) as C
left join
	address as D
on
	C.address_id = D.address_id
order by
	full_name
	, rental_date
	, return_date
;


/*
3. Write a query that returns one row for every film that was NOT rented during July 2005 with the following columns:
- film title
- film rating
- film length
- film rental_rate
- film replacement_cost
Order by replacement_cost (highest on top), then by film title (A on top).

This will also require nested joins AND require you to think carefully about what type of join to use for each (left, right, inner, outer, etc).  Advice: use the "Venn diagrams" at the bottom of https://www.postgresqltutorial.com/postgresql-joins.
*/


select
	D.title
	, D.rating
	, D.length
	, D.rental_rate
	, D.replacement_cost
from (
	select
		B.film_id
	from
		rental as A
	left join
		inventory as B
	on
		A.inventory_id = B.inventory_id
	where
		cast (A.rental_date as date) between '2005-07-01' and '2005-07-31'
	) as C
right join
	film as D
on
	C.film_id = D.film_id
where
	C.film_id is null
order by
	D.replacement_cost desc
	, D.title asc
;