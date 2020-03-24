/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 10
Assigned 2020/03/24
Due 2020/03/31

Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).

Many problems could be done either using "select" OR  "create table".  Unless specified, you are free to choose.  I typically specify "create table" if I think that table will be helpful later.  When you create a table, please generate a resultset to submit using using a separate "select * from ____ order by ____" statement.

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
All question use the DVDrental database.  This is a redo of the midterm exam, but you may use may use all resources normally available for homework.
*/


/*
1. Create a table with daily sales totals for each store.  Columns:
- store_id
- store_date
- sum of rental_rate in that store on that date as revenue
order by store_id (smallest on top) then by store_date (earliest on top).  We will use this table in #2.

Notes
- You will create store_date from rental_date when you aggegrate.
- Use "rental_rate" on film, not "amount" on payment.
*/


/*
2. Using the table in #1, z-transform each store daily revenue using the mean and variance of daily revenues from that store.  Recall: mu = avg(x), sigma^2 = avg(x^2) - avg(x)^2, z = (x - mu) / sigma.  Columns:
- store_id
- store_date
- revenue
- mu (round to 2 decimals)
- sigma (round to 2 decimals)
- z  (round to 2 decimals)
order by z (largest on top) then by store_date (earliest on top).
*/

/*
3. Compute the "rental frequency" of each inventory item, which is the number of days elapsed between its first and last rental divided by the number of rentals.  EVERY inventory item must appear - handle exceptions appropriately.

Notes:
- Note that 19 / 2 is not 8 or 9.  It is 8.5.  Multiply by 1.0.

Hint: If you get undesired rounding from (last_rental_date - first_rental_date) / rentals, use 1.0 * (last_rental_date - first_rental_date) / rentals.  Columns:
- inventory_id (null allowed)
- number of rentals (null NOT allowed, 0 if never rented)
- first_rental_date (null allowed)
- last_rental_date (null allowed)
- elapsed_days (null allowed)
- rental_frequency (null NOT allowed, 999 if never rented, round to 2 decimals)
order by rental frequency (largest on top) then by inventory_id (smallest on top).
*/

/*
4. The film_actor table handles the many-to-many relationship between films and actors.  Create a copy of table film_actor containing only 'G' rated films of length >= 120.  Order by actor_id then by film_id (smallest on top).  We will use this table in #5.
*/

/*
5. In the trivia/party game "6 degrees of Kevin Bacon", we say that two actors are "linked" if they appear together in a movie.  A player is challenged with the name of an actor and must identify a sequence of links (aka "path") of length <=6 that leads to Kevin Bacon (a prolific American actor). Examples:
- Elvis Presley was in "Change of Habit" with Ed Asner.  Ed Asner was in "JFK" with Kevin Bacon.  A path of length 2.
- Ian McKellen was in "X-Men: Days of Future Past" with Michael Fassbender.  Michael Fassbender was in "X-Men: First Class" with Kevin Bacon.  A path of length 2 also.

Using the table from #4, write a recursive CTE to find all actors that have a path of ANY length to "Ed Chase" using ONLY 'G' rated films of length >= 120.  For simplicity, you don't need to give the path itself, its length, or worry if the length is <= 6.  Just give the correct set of actors.
Columns:
- actor_id
- first_name
- last_name
Order by actor_id (smallest on top).  Hint: My solution used a nested join in the recursive CTE step (though perhaps there is a non-nested option I don't see).

Side note - Though "6 degrees of Kevin Bacon" was originally a trivia & party game, it has led to serious study.  Mathematicians play this game centered on Paul Erdos where a link is a co-authored paper.  People do it Wikipedia articles and "Philosophy".  It has lead to the discovery of the "small world effect", "scale-free networks", and "preferential attachment models" of social networks.
*/
