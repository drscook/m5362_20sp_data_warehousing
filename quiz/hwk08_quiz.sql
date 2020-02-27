/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 08 Quiz
Due 2020/02/20

Below is table creation code for problem #2 and some of the inserts.
*/

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
...
;
INSERT INTO math_courses
	(course_number, course_title, prereq_hours, prereq_hours_type, dept_head_approval, standing, math_major)
VALUES
	('MATH1100', 'Transitioning to University Studies in Mathematics', NULL, NULL, false, NULL, true)
	, ('MATH3301', 'Number Theory', 6, 'math', false, null, false)
...
;

CREATE TABLE course_prereqs (
	prereq_id serial PRIMARY KEY,
	course_number VARCHAR(8) REFERENCES math_courses (course_number),
	prereq_course_number VARCHAR(8) REFERENCES math_courses (course_number)
	);
	
INSERT INTO course_prereqs
	(course_number, prereq_course_number)
VALUES
	('MATH1316', 'MATH1314')
	, ('MATH1325', 'MATH1324')
...
;

/*
Now, here is part of my code for #3.  Please complete it.

3. Write a recursive CTE using the database from #2 that returns the "prereq_chart" for any math course.  Please determine which course has the most rows in its prereq_chart and submit that as the resultset for this problem.
*/


WITH RECURSIVE prereq_chart AS (
	SELECT
		c.course_number
	FROM
    	course_prereqs c
   	WHERE
    	course_number = 'MATH3332'