/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 05 Quiz Solutions
2020/02/06
*/

/*
2. Identify & correct at least 4 errors in the code below for computing the z-transform on replacement_cost partitioned by rating.
*/

SELECT
	title,
	rating,
	x,
	N,
	mu,
	round(sqrt(E_x_sq - mu^2), 2) as sigma,
	round((x - mu) / sqrt(E_x_sq - mu^2), 2)
FROM (
	SELECT
		title, 
		replacement_cost,
		COUNT(1) as N,
		round(avg(replacement_cost) over (partition by rating), 2) as mu,
		round(avg(replacement_cost^2) over (partition by rating), 2) as E_x_sq
	FROM
		film
) as B
ORDER BY
	z desc
	, title asc
;