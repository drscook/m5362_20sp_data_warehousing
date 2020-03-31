drop table source cascade;
create table source (
	id serial,
	table_name varchar(20) not null,
	url varchar null,
	refresh_date date null

);

drop table country cascade;
create table country (
	id serial,
	name varchar(44) not null unique,
	region_name varchar(20) not null,
	population bigint null,
	area bigint null,
	population_density real null,
	coastline numeric(10,2) null,
	net_migration float null,
	infant_mortality float null,
	gdp int null,
	literacy float null,
	phones float null,
	arable float null,
	crops float null,
	other float null,
	climate float null,
	birthrate float null,
	deathrate float null,
	agriculture float null,
	industry float null,
	service float null,
	constraint country_pk primary key (id)
--	constraint country_fk foreign key (region_id) references region (id)
);


drop table region cascade;
create table region (
	id serial,
	name varchar(35),
	population bigint null,
	area bigint null,
	population_density float(2) null,
	constraint region_pk primary key (id)
);


drop table city cascade;
create table city (
	id serial,
	name varchar(255) not null,
	population int null,
	country_name varchar(255) not null,
	constraint city_pk primary key (id)
	--constraint city_fk foreign key (country_name) references country (name)
);


drop table goal cascade;
create table goal (
	id varchar(2) not null,
 	name varchar(255) null,
 	descr varchar(255) null,
	constraint goal_pk primary key (id)
);


drop table target cascade;
create table target (
	id varchar(2) not null,	
	descr varchar(255) null,
	goal_id varchar(2) not null,
  	constraint target_pk primary key (goal_id, id)
  	--constraint target_fk foreign key (goal_id) references goal (id)
  	);


drop table entity_type cascade;
create table entity_type (
	id serial,
	name varchar(30),
	abbr varchar(8),
	constraint entity_type_pk primary key (id)
);


drop table entity_type_fix cascade;
create table entity_type_fix (
	id serial,
	orig_name varchar(40),
	new_entity_id varchar(30),
	constraint entity_type_fix_pk primary key (id)
);




drop table entity cascade;
create table entity (
	id serial,
	name varchar(255) not null unique,
	city_id int null,
	entity_type_code varchar(4) not null,
	constraint entity_pk primary key (id)
	--constraint entity_fk1 foreign key (entity_type_code) references entity_type (code),
	--constraint entity_fk2 foreign key (city_id) references city (id)
);


drop table project cascade;
create table project (
	id serial,
	un_id varchar(5) not null unique,
	title varchar(255),
	reg_date date,
	constraint project_pk primary key (id)
);


drop table project_entity cascade;
create table project_entity (
	project_id int not null,
	entity_id int not null,
	constraint project_entity_pk primary key (project_id, entity_id)
	--constraint project_entity_fk1 foreign key (project_id) references project (id),
	--constraint project_entity_fk2 foreign key (entity_id) references entity (id)
);


drop table project_target cascade;
create table project_target (
	project_id int not null,
	goal_id varchar(2) not null,
	target_id varchar(2) not null,
	constraint project_target_pk primary key (project_id, goal_id, target_id)
	--constraint project_target_fk1 foreign key (target_id, goal_id) references target (id, goal_id),
	--constraint project_target_fk2 foreign key (project_id) references project (id)
);