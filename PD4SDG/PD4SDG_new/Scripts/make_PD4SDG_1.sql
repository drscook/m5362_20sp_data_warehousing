drop table if exists raw_city cascade;
create table raw_city (
	city_id int primary key
	, city_name varchar(60) not null
	, subcountry_name varchar(60) not null
	, country_name varchar(60) not null
);


drop table if exists raw_country_data cascade;
create table raw_country_data (
	id serial primary key
	, country_name varchar(60) not null unique
	, region_name varchar(60) not null
	, population bigint null
	, area bigint null
	, population_density float null
	, coastline float null
	, net_migration float null
	, infant_mortality float null
	, gdp int null
	, literacy float null
	, phones float null
	, arable float null
	, crops float null
	, other float null
	, climate float null
	, birthrate float null
	, deathrate float null
	, agriculture float null
	, industry float null
	, service float null
);


drop table if exists raw_country_name_fix cascade;
create table raw_country_name_fix (
	orig varchar(60) not null
	, repl varchar(60) not null
);



drop table if exists raw_entity_name_fix cascade;
create table raw_entity_name_fix (
	orig varchar(255) not null
	, repl varchar(255) not null
);


drop table if exists raw_entity cascade;
create table raw_entity (
	id serial primary key
	, name varchar(255) not null unique
	, type varchar(8) not null
	, city_name varchar(60) not null
	, subcountry_name varchar(60) null
	, country_name varchar(60) not null
);


drop table if exists raw_project cascade;
create table raw_project (
	id serial primary key
	, un_id varchar(68) not null
	, title varchar(258) not null
	, site varchar(60) null
	, repeats int not null
);


drop table if exists raw_project_entity cascade;
create table raw_project_entity (
	un_id varchar(68) not null
	, entity_name varchar(255) not null
	, n int null
);