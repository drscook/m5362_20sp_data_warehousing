/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 08
Assigned 2020/02/11
Due 2020/02/20

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


with cte as (
	select
		title,
		rating,
		replacement_cost as x,
		avg(replacement_cost) over (partition by rating) as mu,
		avg(replacement_cost^2) over (partition by rating) as E_x_sq
	from
		film
)
select
	title,
	rating
	x,
	round(mu, 2),
	round(sqrt(E_x_sq - mu^2), 2) as sigma,
	round((x - mu) / sqrt(E_x_sq - mu^2),2) as z
from 
	cte
order by
	z desc,
	title asc
;


/*
The next 2 problems are more "open" than prior homework and require more decision making.

Goal
In https://www.postgresqltutorial.com/postgresql-recursive-query/, we used recursive CTE to create the "org chart" of subordinates beneath any employee of a company.  Our goal to do something similar for the prequesties of Tarleton Math Courses numbered below 5000 using http://catalog.tarleton.edu/syllabus/?subject=MATH&edition=2019-20.  Observe that many courses list one (or more) lower courses as a prereq.  But that may itself have prereqs.  And so on.  This mimics the org_chart example.
*/

/*
2. We first need to create a database.  To this point, we have been using the pre-made DVD Rental dataset; this will our first time creating a databsase from scratch.

Change from previously posted version of this hwk: 
The .sql file you submit should create all tables and insert all data.  Do NOT export the database and upload.  The .sql file should create everything and be self-contained.  Note that https://www.postgresqltutorial.com/postgresql-recursive-query/ is self-contained because it includes all create and insert statements.  

We need to make some choices.  Clearly, we must have columns for course_number and course_title and it is clear what goes into these columns.

The prereq descriptions are less clear because they vary.  Here is some guidance.  Please bring any other ambiguous cases to my attention:
a) "Enrollment in this course will be in accordance with the Mathematics Placement and Continuing Enrollment Rules." -> NULL
b) "MATH 1314 or concurrent registration." -> MATH 1314 (ignore "or concurrent enrollments)
c) "High school Algebra I and II or a grade of C or better in MATH 0304." -> MATH 0304  (ignore references outside of Tarletone and grade/GPA requirements)
d) MATH 2413. Lab fee $5." -> MATH 2413 (ignore lab fees)
e) "6 hours of Mathematics including MATH 2413." -> 6 math hours AND MATH 2413
f) "Mathematics major, junior standing, 24 semester hours MATH and department head approval." -> Math major AND junior standing AND 24 math hours AND department head approval
g) MATH 3450 says "MATH 1314 or MATH 1316 or MATH 2412 or MATH 2413." Note that 2413 requires 2412, which requires 1316, which requires 1314.  So, for this purpose, I think we can just use MATH 1314 and ignore the rest.
h) MATH 4305 says "Junior Standing with at least one of the following: C or better in MATH 3305 or MATH 4302 or concurrent enrollment in MATH - 4302." -> "junior standing" AND MATH 4302
i) combine terms "upper level" & "advanced" & "degree-applicable" into a single term "advanced"
j) MATH 2413 says "MATH 1316 or MATH 2412. Lab fee: $2" -> MATH 2412
k) MATH 4304 says "MATH 2413 and MATH 3302 or MATH 4302 or concurrent enrollment." -> MATH 2413 AND MATH 3302


In class on 2/13, we determined that prereqs come in 2 basic types: course and non-course prereqs.  We decided to handle non-course prereqs by creating the following columns
- "prereq_hours" & "prereq_hours_type" Ex:
  -  Math 3303 says "minimum of 45 hours complete" -> prereq_hours=45 & prereq_hours_type="overall"
  -  Math 3360 says "3 hours of COSC" -> prereq_hours=3 & prereq_hours_type="COSC"
  -  Math 4320 says "6 hours of advanced MATH" -> prereq_hours=6 & prereq_hours_type="advanced math"
- "dept_head_approval" - T/F column that is F unless "department head approval" is required
- "standing" - Null unless it says something like "junior standing"
- "math major" -  T/F column that is F unless "math major" is required
  
Ex: Math 4088 says "Mathematics major, junior standing, 24 semester hours MATH and department head approval".  So prereq_hours=24 & prereq_hours_type="math", dept_head_approval=T, standing="junior", math_major=T

Now, let's discuss "course" prereqs

The presence of "AND" (ex: Math 3332 says "MATH 2414, MATH 2332 and MATH 3320") forces us to choose between 2 options for our database, the "denormalized" and "normalized" versions:
1) Denormalized - A single table with multiple columns called "prereq_1", "prereq_2", "prereq_3", ...  There will be a lot of null values, which makes this rather inefficient.
2) Normalized - Two tables.
	- "courses" - columns are "number", "title", "prereq_hours", "prereq_hours_type", "dept_head_approval", "standing", "math major"
	- "prereq_courses" - 3 columns called "number", "prereq_number", and a primary key "ID".  A course with n course prereqs will have n rows on this table (a course with no course prereqs will not have any rows).
Please use the normalized form.  This means you ust create 2 tables in your database.
*/



DROP TABLE math_courses cascade;
CREATE TABLE math_courses (
	course_number VARCHAR(8) PRIMARY KEY,
	course_title VARCHAR(255) NOT NULL,
	prereq_hours INT NULL,
	prereq_hours_type VARCHAR(255) NULL,
	dept_head_approval BOOLEAN NOT NULL DEFAULT FALSE,
	standing VARCHAR(10) NULL,
	math_major BOOlEAN NOT NULL DEFAULT FALSE
	);

INSERT INTO math_courses
	(course_number, course_title)
VALUES
	('MATH0001', 'NCBO Math'),
	('MATH0303', 'Basic Mathematics'),
	('MATH0304', 'Fundamentals of College Algebra'),
	('MATH0305', 'Foundations of Statistics'),
	('MATH0306', 'Foundations of College Algebra'),
	('MATH1314', 'College Algebra'),
	('MATH1316', 'Plane Trigonometry'),
	('MATH1324', 'Math for Business & Social Sciences I (Finite Mathematics)'),
	('MATH1325', 'Math for Business & Social Sciences I (Business Calculus)'),
	('MATH1332', 'Contemporary Mathematics I'),
	('MATH1342', 'Elementary Statistical Methods'),
	('MATH2332', 'Applied Matrix Algebra'),
	('MATH2412', 'Precalculus'),
	('MATH2413', 'Calculus I'),
	('MATH2414', 'Calculus II'),
	('MATH3302', 'Principles of Geometry'),
	('MATH3305', 'Concepts of Elementary Mathematics II'),
	('MATH3306', 'Differential Equations'),
	('MATH3310', 'Discrete Mathematics'),
	('MATH3311', 'Probability and Statistics I'),
	('MATH3320', 'Foundations of Mathematics'),
	('MATH3332', 'Linear Algebra'),
	('MATH3433', 'Calculus III'),
	('MATH3450', 'Principles of Bio-Statistics'),
	('MATH4302', 'College Geometry'),
	('MATH4304', 'Survey of Mathematical Ideas'),
	('MATH4306', 'Partial Differential Equations'),
	('MATH4309', 'Advanced Analysis'),
	('MATH4311', 'Probability and Statistics II'),
	('MATH4332', 'Abstracts Algebra'),
	('MATH4486', 'Mathematics Problems')
;

INSERT INTO math_courses
	(course_number, course_title, prereq_hours, prereq_hours_type, dept_head_approval, standing, math_major)
VALUES
	('MATH1100', 'Transitioning to University Studies in Mathematics', NULL, NULL, false, NULL, true)
	, ('MATH3301', 'Number Theory', 6, 'math', false, null, false)
	, ('MATH3303', 'Concepts of Elementary Mathematics I', 45, 'university', false, NULL, false)
	, ('MATH3360', 'Numerical Analysis', 3, 'cosc', false, NULL, false)
	, ('MATH4086', 'Mathematics Problems', NULL, NULL, true, NULL, false)
	, ('MATH4088', 'Undergraduate Research Project', 24, 'math', true, 'junior', true)
	, ('MATH4305', 'Concepts of Elementary Mathematics III', NULL, NULL, false, 'junior', true)
	, ('MATH4320', 'Mathematical Modeling', 6, 'advanced math', false, NULL, false)
	, ('MATH4370', 'Introduction to the History of Mathematics', 6, 'advanced math', false, NULL, false)
	, ('MATH4384', 'Introduction to the History of Mathematics', 24, 'advanced math', true, 'junior', false)
	, ('MATH4390', 'Math Topics', 6, 'advanced math', false, NULL, false)
;
SELECT * FROM math_courses;


DROP TABLE course_prereqs cascade;
CREATE TABLE course_prereqs (
	prereq_id serial PRIMARY KEY,
	course_number VARCHAR(8) REFERENCES math_courses (course_number),  -- references is optional b/c we did not know about foreign keys at this point
	prereq_course_number VARCHAR(8) REFERENCES math_courses (course_number)  -- references is optional b/c we did not know about foreign keys at this point
	);
	
INSERT INTO course_prereqs
	(course_number, prereq_course_number)
VALUES
	('MATH1316', 'MATH1314')
	, ('MATH1325', 'MATH1324')
	, ('MATH1332', 'MATH0304')
	, ('MATH2332', 'MATH2413')
	, ('MATH2413', 'MATH2412')
	, ('MATH2414', 'MATH2413')
	, ('MATH3301', 'MATH2413')
	, ('MATH3302', 'MATH2413')
	, ('MATH3303', 'MATH1314')
	, ('MATH3305', 'MATH3303')
	, ('MATH3306', 'MATH2414')
	, ('MATH3310', 'MATH2413')
	, ('MATH3311', 'MATH2414')
	, ('MATH3320', 'MATH2413')
	, ('MATH3332', 'MATH2414')
	, ('MATH3332', 'MATH2332')
	, ('MATH3332', 'MATH3320')
	, ('MATH3360', 'MATH2414')
	, ('MATH3433', 'MATH2414')
	, ('MATH3450', 'MATH1314')
	, ('MATH4302', 'MATH2413')
	, ('MATH4304', 'MATH2413')
	, ('MATH4304', 'MATH3302')
	, ('MATH4305', 'MATH4302')
	, ('MATH4306', 'MATH3306')
	, ('MATH4309', 'MATH2414')
	, ('MATH4309', 'MATH3320')
	, ('MATH4311', 'MATH3311')
	, ('MATH4320', 'MATH2414')
	, ('MATH4332', 'MATH2414')
	, ('MATH4332', 'MATH3320')
	, ('MATH4390', 'MATH2414')
;
select * from course_prereqs;



/*
3. Write a recursive CTE using the database from #2 that returns the "prereq_chart" for any math course.  Please determine which course has the most rows in its prereq_chart and submit that as the resultset for this problem.
*/

WITH RECURSIVE prereq_chart AS (
	SELECT
		c.course_number
	FROM
    	course_prereqs c
   	WHERE
    	course_number = 'MATH3332'
   	UNION
      	SELECT
			c.prereq_course_number
      	FROM
			course_prereqs c
      	INNER JOIN 
			prereq_chart p
		ON
			p.course_number = c.course_number
)
SELECT * FROM prereq_chart;


-- Also acceptable
WITH RECURSIVE prereq_chart AS (
	SELECT
		c.*
	FROM
    	course_prereqs c
   	WHERE
    	course_number = 'MATH3332'
   	UNION
      	SELECT
			c.*
      	FROM
			course_prereqs c
      	INNER JOIN 
			prereq_chart p
		ON
			c.course_number = p.prereq_course_number
)
SELECT * FROM prereq_chart;