/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 01
Assigned 2020/01/14
Due 2020/01/21
Submit 
*/



/*
0. Create a Google Drive folder named m5362_20sp_data_warehousing_*your last name*.  Share it with scook4242@gmail.com with edit privileges.  Create a subfolder of that called "hwk".  Create a subfolder of that called "hwk01".  Your submission goes into this folder.

For each future hwk, create a new subfolder of the hwk folder named "hwkXX".

Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).
*/



/*
This homework uses the DVD rental database.  We'll keep this short - it is mostly to test whether we are fully setup and that I can see your submissions.  Try to get it done asap so we can discuss any setup issues on Thursday.
*/



/*
1. Write a query to create a dataset with 1 column named "shelf_stickers" for the films in the store which have the form "Title (rating): $rental_rate".  Ex: Chamber Italian (NC-17): $4.99"
*/


select
	title || ' (' || rating || '): $' || rental_rate as self_stickers
from
	film
;

/*
2. Write a query that selects film title, length, rental_rate, and replacement_cost and computes:
- column named "ROI" which is the number of times a film must be rented to recoup the replacement_cost.
- column named "rental_value" which number of minutes per dollar spent to rent the film.
*/


select
	title
	, length
	, rental_rate
	, replacement_cost
	, replacement_cost / rental_rate as ROI
	, ceiling(replacement_cost / rental_rate) as ROI_rounded
	, length / rental_rate as rental_value
from
	film
;