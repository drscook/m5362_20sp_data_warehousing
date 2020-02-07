/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 07
Assigned 2020/02/06
Due 2020/02/13

Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).

This homework uses the DVD rental database.

NEW: Many problems could be done either using "select" OR  "create table".  Unless specified, you are free to choose.  I typically specify "create table" if I think that table will be helpful later.

When you create a table, please generate a resultset to submit using using a separate "select * from ____ order by ____" statement.

create table A as (
	select
		inventory_id
	from
		rental
);
select * from A order by inventory_id asc;

We don't usually order the table itself; we order the select.

NEWER: Each hwk submission should "stand alone".  This means that, if I download a fresh copy of the DVD rental dataset and run ONLY the sql you submit for this hwk,  it should work.  In other words, your hwk07 sql should work even if I haven't run your hwk01, 02, ..., 06 .  Of course, you may freely copy and reuse code from prior hwk.
*/

/*
0. Re-create table "film_profit" from hwk06 #6.  If you did not select column "rating", do so this time.
*/
drop table rental_counts;
create table rental_counts as (
	select
		inventory_id
		, count(1) as rental_count
	from
		rental
	group by
		inventory_id
);

drop table inventory_rentals;
create table inventory_rentals as (
	select
		A.*
		, coalesce(B.rental_count, 0) as rental_count
	from
		inventory as A
	left join 
		rental_counts as B
	on
		A.inventory_id = B.inventory_id
);

drop table inventory_profit;
create table inventory_profit as (
	select
		A.inventory_id
		, A.store_id		
		, A.film_id
		, B.title
		, B.rating
		, B.rental_rate
		, B.replacement_cost
		, A.rental_count
		, A.rental_count * B.rental_rate - B.replacement_cost as profit
	from
		inventory_rentals as A
	left join
		film as B
	on
		A.film_id = B.film_id
);

drop table film_profit;
create table film_profit as (
	select
		film_id
		, title
		, rating
		, rental_rate
		, replacement_cost
		, count(1) as inventory_count
		, sum(rental_count) as rental_count
		, sum(profit) as profit
	from
		inventory_profit
	group by
		1, 2, 3, 4, 5
);

/*
1. Create table "film_category_profit" which adds category_name to film_profits.  Order by category (A on top) then rating then title (A on top)
*/

drop table film_category_profit;
create table film_category_profit as (
	select
		A.*
		, C.name as category_name
	from
		film_profit as A
	left join
		film_category as B
	using
		(film_id)
	left join
		category C
	using
		(category_id)
);
select * from  film_category_profit order by category_name, rating, title;

/*
For problems 2-5, we will use different groupings, but always return columns category_name, rating (except #2), count, min profit, avg profit (round to 2 decimals), max profit and always order by order by category_name (A on top) then rating (except #2).
*/


/*
2. Use our familiar "group by" command to group by category.
*/


select
	category_name
	, count(1) as N
	, min(profit)
	, round(avg(profit), 2) as avg
	, max(profit)
from
	film_category_profit
group by
	1
order by
	1
;


/*
3. Use the new "grouping sets" command to expand the resultset from #2 to show subtotals for each rating within each category.  Ex: There should be rows for Action-G, Action-PG, Action-PG-13, Action-R, Action-NC-17, and Action-Null (which appeared #2).
*/

select
	category_name
	, rating
	, count(1) as N
	, min(profit)
	, round(avg(profit), 2) as avg
	, max(profit)
from
	film_category_profit
group by
	grouping sets (
		(1, 2)
		, (1)
	)
order by
	1, 2
;


/*
4. Use the new "rollup" command to expands the resultset from #3 to include one extra "grand total" row for all films.  
*/


select
	category_name
	, rating
	, count(1) as N
	, min(profit)
	, round(avg(profit), 2) as avg
	, max(profit)
from
	film_category_profit
group by
	rollup(1, 2)
order by
	1, 2
;


/*
5. Use the new "cube" command to combine group by (category, rating) AND group by (rating) AND group by (category) AND group by ().
*/


select
	category_name
	, rating
	, count(1) as N
	, min(profit)
	, round(avg(profit), 2) as avg
	, max(profit)
from
	film_category_profit
group by
	cube(1, 2)
order by
	1, 2
;



/*
6. Find the most profitable film in each (category, rating) group.  Columns:
- category_name
- rating
- title
- profit
order by profit (smallest on top).  
*/



select
	*
from (
	select
		category_name
		, rating
		, title
		, profit
		, profit - (max(profit) over (partition by category_name, rating)) as diff
	from
		film_category_profit
	) as A
where
	diff >= 0
order by
	profit desc
;