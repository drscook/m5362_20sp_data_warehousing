drop table country cascade;
create table country (
	id serial,
	name varchar(33) null unique,
	region_name varchar(35) null,
	population bigint null,
	area bigint null,
	population_density float(2) null,
	coastline float(2) null,
	net_migration float(2) null,
	infant_mortality float(2) null,
	gdp int null,
	phones float(2) null,
	arable float(2) null,
	crops float(2) null,
	other float(2) null,
	climate float(1) null,
	birthrate float(2) null,
	deathrate float(2) null,
	agriculture float(2) null,
	industry float(2) null,
	service float(2) null,
	constraint country_pk primary key (id),
	-- constraint country_fk foreign key (region_id) references region (id)  -- make region_ids next
);

