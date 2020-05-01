/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Final Exam
released - 2020/05/01
due - 2020/05/06 (into syncplicity)
*/


/*
You may use EXISTING resources like
	https://www.postgresqltutorial.com/
	https://www.postgresql.org/docs/12/index.html
	https://stackoverflow.com/
	class materials (including anything on our git hub & canvas repos)
	textbooks
	blogs
	divine intervention
	me
	etc
	
You may NOT get NEW help from anything or anybody.  This includes (but is not limited to):
	face-to-face conversations
	phone calls
	emails
	chat rooms
	online posts you make (ex: you CAN use an existing question on stackoverflow, but you can NOT post a new one)
	
In short, stuff that existed BEFORE 4/30 is OK, but not stuff created after.
*/


/*
There are 7 problems; you must do 6 and may skip 1.  I will give extra credit if you do all 7.  However, some problems depend on others, which makes skipping those more difficult.
*/


/*
Question 1-4 use the familiar DVDRental database.  You must use the exact version of the DVD rental database here: https://www.postgresqltutorial.com/postgresql-sample-database/.  Because you might have changed in during the semester, please download and use a fresh copy.

Questions 5-7 use the PD4SDG_newer database here: https://github.com/drscook/m5362_20sp_data_warehousing.  Download and use a fresh copy - there have been changes since 4/30.  You should only need PD4SDG_small.tar and the ER-diagram, but I have included all other files in case you want them.

Reminder: unzip, then use "restore" to load the .tar files.
*/


/*
Problems can be solved in different ways (select vs create table, nested queries vs create intermediate tables vs CTE).  All are acceptable if they give the correct dataset.  You may include more columns than requested by the question.  Use "select * from ...." to get a .csv.

Submit a separate .csv with the resultset for each problem and at least one .sql file with your code.
*/


/*
If you divide with integers, remember to cast to float to avoid unwanted rounding.  Ex:
BAD
count(*) / (select sum count(*) from A)

GOOD
1.0 * count(*) / (select sum count(*) from A)
*/


/*************************************************************************************************************/


/*
DVD-Rental
1. Compute the count, sum, avg, and standard deviation of payment-amount for each country.
Required columns:
- country_id
- country
- count of amounts
- sum of amounts
- avg of amounts
- standard deviation of amounts as sigma
order by sum (biggest on top)
*/


/*
DVD-Rental
2. Using the results above, perform a z-transform for each payment-amount based on the country's statistics.
Required columns:
- payment_id
- customer_id
- last_name, first_name as customer_full_name
- country_id
- country
- z  (round to 2 decimals)
order by z (largest on top) then by full_name (A on top).

(optional) You can check your solution by confirming that, within each country, z has avg=0 and sigma=1.
*/


/*
DVD-Rental
3. With the z-scores from the prior two questions, we can identify the most extreme payment-amounts relative to the country.  Now, suppose we want to open a new store in the city with the highest sales (total payment-amount) relative to its country.  So, compute z-scores for each city relative to its country; only include countries with at least 5 cities.  You 

Required columns:
- city_id
- city
- country_id
- country
- z  (round to 2 decimals)
order by z (largest on top) then by city (A on top).

(optional) You can check your solution by confirming that, within each country, z has avg=0 and sigma=1.
*/


/*
DVD-Rental
4. Find the most popular actor in each country as measured by the sum of payment-amount of rentals of their films in that country.
Required columns:
- country_id
- country
- actor_id
- last_name, first_name as actor_full_name
- sum of payment-amount
order by country (A on top)
*/



/*
PD4SDG
5. Table Entity_data may have rows for entities that did not actually work on a project.  Create a table called "active_entity" that removes these rows and adds a column that counts the number of projects that entity worked on.
Required columns:
- all of entity_data
- count of projects
order by count (biggest on top)
*/


/*
PD4SDG
6. Similar to the last problem of the midterm - Create a recursive CTE for the network of collaborations among the entities in PD4SDG.  Two entities are "linked" if they worked on any project together.  This network has a "giant component" (gc) containing most (but not all) entities.  Find all entities in the gc. 

(Hint: The midterm specifed to start the recursion from the actor "Ed Chase".  However, this problem does not specify a start point.  Because the gc contains most entities, you should be able to easily find a suitable start point for yourself.)

(optional - you may check your solution using the published PD4SDG paper in the .zip file, which contains the (almost correct) row count.)
Required columns:
- entity_id
- entity_name
- entity_type
- city_geonameid
order by entity_id (smallest on top)
*/




/*
PD4SDG
7. Using the results of the prior two problems, compare the entity_type percentages for the entire network (all active entities) to the giant component (only entities in the gc).

(optional - you may check your solution using the published PD4SDG paper in the .zip file.  The published percentages for the giant component are very close to the correct answers.  I think we published values for the entire network, but they are similar to the gc.  Make sure both columns sum to 100)

Required columns:
- entity_type
- percent of entire network as all_pct (round to 2 decimals)
- percent of giant component as gc_pct (round to 2 decimals)
order by all_pct (biggest on top)
*/

