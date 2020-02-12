/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 08
Assigned 2020/02/11
Due 2020/02/18

Most questions will be of the form "Write a query that ...".  You must submit BOTH the resulting dataset and the query.  You must submit a separate .csv for each dataset.  You have the option whether to submit the queries in separate .sql files or combine into 1 file (with clear problem labels).

Many problems could be done either using "select" OR  "create table".  Unless specified, you are free to choose.  I typically specify "create table" if I think that table will be helpful later.

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
1. Repeat #2 from hwk 05 replacing subqueries by CTE's.
*/


/*
The next 2 problems are more "open" than prior homework and require more decision making.

Goal
In https://www.postgresqltutorial.com/postgresql-recursive-query/, we used recursive CTE to create the "org chart" of subordinates beneath any employee of a company.  Our goal to do something similar for the prequesties of Tarleton Math Courses numbered below 5000 using http://catalog.tarleton.edu/syllabus/?subject=MATH&edition=2019-20.
*/

/*
2. We first need to create a database.  To this point, we have been using the pre-made DVD Rental dataset; this will our first time creating a databsase from scratch.  You need to make some choices.  Clearly, we must have columns for course_number and course_title; its clear what goes into these columns.

But the prerequisites are less clear because the descriptions vary.  Here is some guidance.  Please bring any other ambiguous cases to my attention:
a) "Enrollment in this course will be in accordance with the Mathematics Placement and Continuing Enrollment Rules." -> NULL
b) "MATH 1314 or concurrent registration." -> MATH 1314 (ignore "or concurrent enrollments)
c) "High school Algebra I and II or a grade of C or better in MATH 0304." -> MATH 0304  (ignore references outside of Tarletone and grade/GPA requirements)
d) MATH 2413. Lab fee $5." -> MATH 2413 (ignore lab fees)
e) "6 hours of Mathematics including MATH 2413." -> 6 math hours AND MATH 2413
f) "Mathematics major, junior standing, 24 semester hours MATH and department head approval." -> Math major AND junior standing AND 24 math hours AND department head approval
g) MATH 3450 says "MATH 1314 or MATH 1316 or MATH 2412 or MATH 2413." Note that 2413 requires 2412, which requires 1316, which requires 1314.  So, for this purpose, I think we can just use MATH 1314 and ignore the rest.
h) MATH 4305 says "Junior Standing with at least one of the following: C or better in MATH 3305 or MATH 4302 or concurrent enrollment in MATH - 4302." -> "junior standing" AND MATH 4302
i) combine terms "upper level" & "advanced" & "degree-applicable" into a single term "advanced"


The presence of "AND" forces us to choose between 2 options for our database, the "denormalized" and "normalized" versions:
1) Denormalized - A single table with multiple columns called "prereq_1", "prereq_2", "prereq_3", ...  There will be a lot of null values.
2) Normalized - Two tables.
	- "courses" - columns are number, title, and any other info you want except for prereqs
	- "prereqs" - 2 columns called "number" and "prereq".  A course with no prereqs will not have a row but a course with n prereqs will have n rows.
	

I don't want to tell you which way to go - I want you to decide for yourself through experimentation.

I'd like you to submit your database so I can use it, but, at this moment, I'm not exactly sure how to do that (though I'm guessing it is easy).  Let me know if you figure it out.
*/



/*
3. Write a recursive CTE using the database from #2 that returns the "prereq_chart" for any math course.  Please determine which course has the most rows in its prereq_chart and submit that as the resultset for this problem.
*/

