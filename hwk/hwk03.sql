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