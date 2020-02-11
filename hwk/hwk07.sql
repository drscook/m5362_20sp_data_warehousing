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



/*
1. Create table "film_category_profit" which adds category_name to film_profits.  Order by category (A on top) then rating then title (A on top)
*/



/*
For problems 2-5, we will use different groupings, but always return columns category_name, rating (except #2), count, min profit, avg profit (round to 2 decimals), max profit and always order by order by category_name (A on top) then rating (except #2).
*/



/*
2. Use our familiar "group by" command to group by category.
*/



/*
3. Use the new "grouping sets" command to expand the resultset from #2 to show subtotals for each rating within each category.  Ex: There should be rows for Action-G, Action-PG, Action-PG-13, Action-R, Action-NC-17, and Action-Null (which appeared #2).
*/



/*
4. Use the new "rollup" command to expands the resultset from #3 to include one extra "grand total" row for all films.  
*/



/*
5. Use the new "cube" command to combine group by (category, rating) AND group by (rating) AND group by (category) AND group by ().
*/



/*
6. Find the most profitable film in each (category, rating) group.  Columns:
- category_name
- rating
- title
- profit
order by profit (smallest on top).  
*/