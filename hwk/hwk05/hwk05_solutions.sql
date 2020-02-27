/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 05
Assigned 2020/01/28
Due 2020/02/06

Considering that this hwk may take a bit longer AND that we will not cover new material on Thursday, I'm allowing 1 extra class period before it is due.  But you should try to get it done by 2/4 to allow for questions in class on 2/4.
*/


/*
Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).
This homework uses the DVD rental database.

Goal: Perform the z-transform in sql.

Background:
Let x_i be N observations of a continuous variable; denote the mean (mu) and standard deviation (sigma).  The z-transform is z_i = (x_i - mu) / sigma.  This centers and rescales the dataset to have mean = 0 and standard deviation = 1.  Thus, z_i = 0.7 means that this observation is 0.7 sigma ABOVE the mean; z_i=-1.2 means that this observation is 1.2 sigma BELOW the mean.

The mean (or average) is defined mu = sum[x_i] / N.

The (population) variance is defined sigma^2 = sum[(x_i - mu)^2] / N.  However, a simple derivation gives the alternate formula sigma^2 = avg(x^2) - mu^2.  I find this alternate formula to be more convenient in sql.

The (population) standard deviation is the square root ot the (population) variance.

Now, suppose we have a dataset with 1 continuous variable and 1 categorical variable.  The categorical variable splits the data into groups; we often wish to perform the z-transform separately within each group.  So, we must compute mu and sigma for each group and use the appropriate values for the z-transform of each row.

Window function in sql are particularly helpful for doing this; they compute group statistics for each row.  The same result could be achieved in 2 steps by doing a groupby with aggegration and then joining the result back to the original table.  However, window functions do this more cleanly AND provide extra functionality (such as cumulative sums).

https://www.postgresql.org/docs/12/tutorial-window.html
*/


/*
1. This problem uses only the film table.  Apply the z-transform to replacement_cost split by rating.  Do not use any groupby/aggegation; use only window functions.  Use the alternate formula for standard deviation.

There should be one row for each film with the following columns:
- title
- rating
- replacement_cost (I found it convenient to alias as x)
- mean (alias as mu)
- standard deviation (alias as sigma)
- z
Order by z (largest on top) then by title (A on top)

While it is possible to do this without nesting, the code gets complex and less readable.  On the other hand, we nested too deeply in class because we were trying to use the first formula for sigma.  The alternate formula allows cleaner and less deeply nested code.

I wrote versions with 0, 1, and 2 levels of nesting.  I think that 1 level of nesting is optimal (again, taking advantage of the alternate formula for sigma).
*/


-- 1 nested
select
	title
	, rating
	, x
	, sqrt(E_x_sq - mu^2) as sigma
	, (x - mu) / sqrt(E_x_sq - mu^2) as z
from (
	select
		title
		, rating
		, replacement_cost as x
		, avg(replacement_cost) over (partition by rating) as mu
		, avg(replacement_cost^2) over (partition by rating) as E_x_sq
	from
		film
) as B
order by
	z desc
	, title asc
;


-- 2 nested
select
	*
	, (x - mu) / sigma as z
from (
	select
		*
		, sqrt(E_x_sq - mu^2) as sigma
	from (
		select
			title
			, rating
			, replacement_cost as x
			, avg(replacement_cost) over (partition by rating) as mu
			, avg(replacement_cost^2) over (partition by rating) as E_x_sq
		from
			film
	) as B
) as C
order by
	z desc
	, title asc
;



-- 0 nested
select
	title
	, rating
	, replacement_cost
	, avg(replacement_cost) over (partition by rating) as mu
	, sqrt(avg(replacement_cost^2) over (partition by rating) - avg(replacement_cost) over (partition by rating)^2) as sigma
	, (replacement_cost - avg(replacement_cost) over (partition by rating)) / sqrt(avg(replacement_cost^2) over (partition by rating) - avg(replacement_cost) over (partition by rating)^2) as z
from
	film
order by
	z desc
	, title asc
;



/*
2. Problem #1 produces columns with long decimals.  For the convenience of the user, we want to round the final output.  However, must be careful only to round at the end.  We must never use rounded values in a calculation - this introduces error.  Repeat #1, rounding numerical columns in the output to 2 decimals using round(___, 2).  Be careful to round only at final output; never use rounded values within a calculation.
*/


-- 1 nested
select
	title
	, rating
	, x
	, round(mu, 2)
	, round(sqrt(E_x_sq - mu^2), 2) as sigma
	, round((x - mu) / sqrt(E_x_sq - mu^2),2) as z
from (
	select
		title
		, rating
		, replacement_cost as x
		, avg(replacement_cost) over (partition by rating) as mu
		, avg(replacement_cost^2) over (partition by rating) as E_x_sq
	from
		film
) as B
order by
	z desc
	, title asc
;



/*
3. Problem 1 & 2 do not consider the fact that we have multiple copies of films in our inventory.  Repeat #2 using "weighted" mu and sigma where the weight is the number of copies of each film in inventory.

Hint: Copy the code from hwk03 #1 for table "t1".  This produces a weighted dataset where each film is repeated once for each copy in inventory.  Copy your code from #2, but use table t1 rather than film.

This will produce a table with multiple (identical) rows for each film.  The instructions for #1 demand a SINGLE row for each film.  You may now use group by to remove the duplicates.
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



-- 1 nested
select
	title
	, rating
	, x
	, round(mu, 2)
	, round(sqrt(E_x_sq - mu^2), 2) as sigma
	, round((x - mu) / sqrt(E_x_sq - mu^2),2) as z
	, count(1) as N
from (
	select
		title
		, rating
		, replacement_cost as x
		, avg(replacement_cost) over (partition by rating) as mu
		, avg(replacement_cost^2) over (partition by rating) as E_x_sq
	from
		t1
) as C
group by
 1, 2, 3, 4, 5, 6
order by
	z desc
	, title asc
;
