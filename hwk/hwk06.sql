/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 06
Assigned 2020/02/04
Due 2020/02/11

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
*/



/*
1. Use "except" to find all film_id's with no inventory, order by film_id (smallest on top).  In other words, all film_id from the film table with no corresponding rows on the inventory table.  (We talked about this in week 2 and solved it using joins.  Now, do it with except).
*/



/*
2. Use "except" to find all inventory items that have never rented, order by inventory_id (smallest on top).  In other words, all inventory_id from the inventory table with no corresponding rows on the rental table.
*/



/*
3. Using only the rental table, create a table called rental_counts that counts the number of times each inventory item has rented with the following columns:
- inventory_id
- number of times rented alised as rental_count
order by rental_count (smallest on top) then by inventory_id (smallest on top).
*/



/*
4. Add rental_count to the inventory table using a join.  Note that, in problem 2, we saw that at least one inventory item has never rented.  Make sure such items EXIST and have 0 in the rental_count column.  You may find the "coalesce" function helpful: https://www.postgresqltutorial.com/postgresql-coalesce/.  Order by rental_count (smallest on top) then by inventory_id (smallest on top).
*/



/*
5. Define "profit" for an inventory item as rental_count * rental_rate - replacement_cost.  Create a table called "inventory_profit" with a row for each inventory item with the following columns
- inventory_id
- store_id
- film_id
- title
- rental_rate
- replacement_cost
- rental_count
- profit
order by profit (smallest on top) then by title (A on top).
*/



/*
6. Repeat #5 for each FILM (drop inventory_id & store_id, add inventory_count).  Apply appropriate aggregation to combine films with multiple inventory items.
*/