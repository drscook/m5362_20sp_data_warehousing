truncate region cascade;
insert into
	entity_type (name, abbr)
values
	('Non-Governmental Org', 'ngo'),
	('National Government', 'natgov'),
	('United Nations Entity', 'un'),
	('Private Sector', 'priv'),
	('Academic Institution', 'acad'),
	('Intergovernmental Organization', 'intergov'),
	('Scientific Community', 'sci'),
	('Subnational Government', 'subgov'),
	('Local Government', 'locgov'),
	('Supranational Government', 'supgov'),
	('Government', 'gov'),
	('Civil Society Orgaanization', 'civsoc')
;

truncate region cascade;
insert into region (name, population, area, population_density )
select
	*,
	population / area as population_density
from (
	select
		region_name as name,
		sum(population) as population,
		sum(area) as area
	from
		country
	group by
		region_name
) A
order by
	name
;