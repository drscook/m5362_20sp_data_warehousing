/*
Math 5362 - Data Warehousing
Spring 2020, Tarleton State University
Dr. Scott Cook
Homework 09
Assigned 2020/02/18
Due 2020/02/25
*/


/*
This homework begins our work turning the PD4SDG database created by Dr. Anne Egleston of Tarleton State University Political Science Department into a well-structured relational database.  Please download the PD4SDG.zip file from the github repo.

Each project lists 1 or more "partners", 1 or more "goals", and 1 more "targets".  This entire process will get fairly complicated, so let's start with one of the simpler components.

https://sustainabledevelopment.un.org/sdgs lists all 17 "Sustainable Development Goals" (SDG).  Each SDG has "targets".  Each target has "indicators".  You can see them by clicking on the SDG and then on "Targets & Indicators".  We will use composite primary keys in the targets and indicators tables.  We will also use "foreign key" constraints to ensure referential integrity.  We may also find the "upsert" functionality helpful - it is a variant of insert which will update an existing row if one exists and will create a new one if not.

1. Create and populate a table for the SDGs.
2. Create and populate a table for targets including a foreign key constraint to SDGs.
3. Create and populate a table for indicators including foreign key constraints to both SDGs and targets.

Below is a portion of my code for #3.  Use this as a guide and refer to the following sections of the postgres tutorial
https://www.postgresqltutorial.com/postgresql-primary-key/
https://www.postgresqltutorial.com/postgresql-foreign-key/
https://www.postgresqltutorial.com/postgresql-upsert/



CREATE TABLE indicators (
	sdg_id varchar(2) NOT NULL
	, targ_id varchar(2) NOT NULL
	, ind_id varchar(2) NOT NULL
	, ind_desc VARCHAR(255) NULL
  	, constraint ind_PK primary key (sdg_id, targ_id, ind_id)
  	, constraint ind_FK1 foreign key (sdg_id) references sdgs (sdg_id)
	, constraint ind_FK2 foreign key (sdg_id, targ_id) references targets (sdg_id, targ_id)
  	);
	
INSERT INTO indicators
	(sdg_id, targ_id, ind_id, ind_desc)
VALUES
	('1', '1', '1', 'Proportion of population below the international poverty line, by sex, age, employment status and geographical location (urban/rural)')
	, ('1', '2', '1', 'Proportion of population living below the national poverty line, by sex and age')	
	, ('1', '2', '2', 'Proportion of men, women and children of all ages living in poverty in all its dimensions according to national definitions')
	-- more data
on conflict on constraint ind_pk do update set
 	ind_desc = excluded.ind_desc
;
*/