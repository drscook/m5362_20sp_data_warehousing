-- https://www.kaggle.com/fernandol/countries-of-the-world/data#

drop table country cascade;
create table country (
	id serial,
	name varchar(33) null unique,
	region_name varchar(35) null,
	population bigint null,
	area bigint null,
	population_density float null,
	coastline float null,
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
	-- constraint country_fk foreign key (region_id) references region (id)  -- mot yet ... make region_ids next
);




drop table region;
create table region as (
	select
		region_name,
		sum(population) as population,
		sum(area) as area
	from
		country
	group by
		1
);
select * from region;
