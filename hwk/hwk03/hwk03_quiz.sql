/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 03 Quiz
2020/01/28
*/

/*
3. Write a query that returns one row for every film that was NOT rented during July 2005 with the following columns:
- film title
- film rating
- film length
- film rental_rate
- film replacement_cost
Order by replacement_cost (highest on top), then by film title (A on top).

Identify & correct at least 4 errors in the code below.
*/

select
	D.inventory_id,
	D.title,
	D.rating,
	D.length,
	D.rental_rate,
	D.replacement_cost,
from (
	select
		B.film_id
	from
		rental as A
	left join
		inventory as B
	on
		inventory
	where	
		A.rental_date between '2005-07-01' and '2005-07-31'
	) as C
outer join
	film as D
on
	film_id
order by
	D.replacement_cost
	, D.title;