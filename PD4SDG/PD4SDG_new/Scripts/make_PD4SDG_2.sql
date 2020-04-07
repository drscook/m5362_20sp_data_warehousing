



drop table country_name_fix cascade;
create table country_name_fix as (
	select
		trim(initcap(orig)) as orig
		, trim(initcap(repl)) as repl
	from
		raw_country_name_fix
);
alter table country_name_fix add primary key (orig, repl);
alter table country_name_fix add unique (orig);



drop table entity_name_fix cascade;
create table entity_name_fix as (
	select
		trim(initcap(orig)) as orig
		, trim(initcap(repl)) as repl
	from
		raw_entity_name_fix
);
alter table entity_name_fix add primary key (orig, repl);
alter table entity_name_fix add unique (orig);




drop table city_temp cascade;
create table city_temp as (
	select distinct
		A.city_id
		, A.city_name
		, A.subcountry_name 
		, coalesce(B.repl, A.country_name) as country_name
	from (
		select
			city_id
			, trim(initcap(city_name)) as city_name
			, trim(initcap(subcountry_name)) as subcountry_name 
			, trim(initcap(country_name)) as country_name
		from
			raw_city
		) as A
	left join
		country_name_fix as B
	on 
		A.country_name = B.orig
	order by
		country_name, subcountry_name, city_name 
);
alter table city_temp add primary key (city_id);
alter table city_temp add unique (city_name, subcountry_name, country_name);




drop table country_data_temp cascade;
create table country_data_temp as (
	select 
		A.*
		, trim(initcap(coalesce(B.repl, A.country_name))) as country_name_new
	from 
		raw_country_data as A
	left join
		country_name_fix as B
	on 
		trim(initcap(A.country_name)) = B.orig
	order by
		country_name
);
alter table country_data_temp drop column country_name, drop column id;
alter table country_data_temp add unique (country_name_new);



drop table t1 cascade;
create table t1 as (
	select distinct
		country_name
	from
		city_temp
);
insert into t1 values ('Global'), ('European Union');



drop table country cascade;
create table country as (
	select
		A.*
		, B.*
	from
		t1 as A
	left join
		country_data_temp as B
	on 
		A.country_name = B.country_name_new
	order by 
		A.country_name
);
alter table country add column country_id int generated always as identity (start with 1) primary key;
alter table country drop column country_name_new;
alter table country add unique (country_name);



drop table subcountry cascade;
create table subcountry as (
	select distinct
		A.subcountry_name
		, A.country_name
		, B.country_id
	from 
		city_temp as A
	left join 
		country as B
	on
		A.country_name = B.country_name
	order by
		2, 1
);
alter table subcountry add column subcountry_id int generated always as identity (start with 1000) primary key;
alter table subcountry add unique (subcountry_name, country_name);
alter table subcountry add constraint subcountry_fk foreign key (country_id) references country(country_id);



drop table city cascade;
create table city as (
	select 
		A.city_id
		, A.city_name
		, A.subcountry_name
		, A.country_name
		, B.subcountry_id
		, B.country_id
	from
		city_temp as A
	left join
		subcountry as B
	on
		A.subcountry_name = B.subcountry_name
		and A.country_name = B.country_name
);
alter table city add unique (city_name, subcountry_name, country_name);
alter table city add constraint city_fk1 foreign key (country_id) references country(country_id);
alter table city add constraint city_fk2 foreign key (subcountry_id) references subcountry(subcountry_id);




drop table city_temp cascade;
drop table country_data_temp cascade;
drop table t1 cascade;



drop table site cascade;
create table site (
	site_id int primary key
	, city_name varchar(60) null
	, subcountry_name varchar(60) null
	, country_name varchar(60) not null
	, form_1 varchar(100) not null
	, form_2 varchar(100) null
	, form_3 varchar(100) null
	, form_4 varchar(100) null
);

insert into site (site_id, country_name, form_1)
select
	country_id
	, country_name
	, country_name
from
	country
;	
	
insert into site (site_id, subcountry_name, country_name, form_1, form_2)
select
	subcountry_id
	, subcountry_name
	, country_name
	, subcountry_name || ', ' || country_name
	, subcountry_name
from
	subcountry
;

insert into site (site_id, city_name, subcountry_name, country_name, form_1, form_2, form_3, form_4)
select
	city_id
	, city_name
	, subcountry_name
	, country_name
	, city_name || ', ' || subcountry_name || ', ' || country_name
	, city_name || ', ' || country_name
	, city_name || ', ' || subcountry_name
	, city_name
from
	city
;
alter table site add unique (city_name, subcountry_name, country_name);
alter table site add constraint site_fk1 foreign key (country_name) references country(country_name);




drop table entity_type cascade;
create table entity_type (
	id serial primary key
	, code varchar(8) not null unique
	, name varchar(29) not null unique
);

insert into entity_type (code, name)
values
	('Ngo', 'Non-Governmental Organization')
	, ('Priv', 'Private Sector')
	, ('Acad', 'Academic Institution')
	, ('Subgov', 'Sub-National Government')
	, ('Sci', 'Scientific Community')
	, ('Natgov', 'National Government')
	, ('Intergov', 'Inter-National Government')
	, ('Un', 'United Nations Entity')
	, ('Supgov', 'Supra-National Government')
;



drop table entity cascade;
create table entity as (
	select
		A.*
		, city_name || ', ' || subcountry_name || ', ' || country_name as site
	from (
		select
			id
			, trim(initcap(name)) as name
			, trim(initcap(type)) as type
			, trim(initcap(city_name)) as city_name
			, trim(initcap(subcountry_name)) as subcountry_name
			, trim(initcap(country_name)) as country_name
		from 
			raw_entity
		) as A
);
alter table entity add primary key (id);
alter table entity add unique (name);
alter table entity add constraint entity_fk1 foreign key (type) references entity_type(code);



drop table project cascade;
create table project as (
	select
		id
		, un_id
		, trim(initcap(title)) as title
		, trim(initcap(site)) as site
		, repeats
	from 
		raw_project
);
alter table project add primary key (id);
alter table project add unique (un_id);









drop table project_entity cascade;
create table project_entity as (
	select 
		E.project_id
		, F.id as entity_id
	from (
		select 
			C.project_id
			, coalesce(D.repl, C.entity_name) as entity_name 
		from (
			select
				B.id as project_id
				, A.entity_name as entity_name
			from
				raw_project_entity as A
			left join
				project as B
			on 
				A.un_id = B.un_id 
			) as C
		left join 
			entity_name_fix as D
		on
			C.entity_name = D.orig
		) as E
	left join
		entity as F
	on
		E.entity_name = F.name
);
alter table project_entity add primary key (project_id, entity_id);
alter table project_entity add constraint project_entity_fk1 foreign key (project_id) references project(id);
alter table project_entity add constraint project_entity_fk2 foreign key (entity_id)  references entity(id);
