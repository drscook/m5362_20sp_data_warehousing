/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 02 Quiz Solutions
Due 2020/01/23
*/

/*
1. Write a query that returns all distinct dates on which at least one rental occurred, ordered with most recent on top.
*/



















/*
4. (Fill in the blanks) Write a query to that returns the title, rating, and length of all films that were rented between July 1 and July 7, 2005 AND whose title contains the string "doc" (case insensitive).  Order by rating (ascending), then by length (longest on top), then by title (A on top)
*/


select
	title
	, rating
	, length
from
	film
where
	________________ in (
	select distinct
		__________________________________
	from
		______________________________
	where
		____________________ in (
			select distinct
				_______________________________
			from
				rental
			where
				__________________________________________________
		)
	)
	________________________________________________
order by
	rating asc
	, length desc
	, title desc
;