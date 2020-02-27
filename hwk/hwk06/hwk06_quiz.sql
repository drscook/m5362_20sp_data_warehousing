/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 06 Quiz
Due 2020/02/11

Below is my code for problem #3.  Please extend it to solve problem 4.
4. Add rental_count to the inventory table using a join.  Note that, in problem 2, we saw that at least one inventory item has never rented.  Make sure such items EXIST and have 0 in the rental_count column.  Order by rental_count (smallest on top) then by inventory_id (smallest on top).
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
select * from rental_counts order by rental_count asc, inventory_id asc;