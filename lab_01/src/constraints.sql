alter table galaxies add constraint galaxy_type_check check(radius > 0);
alter table galaxies add constraint galaxy_mass_check check(mass > 0);

alter table space_programs add constraint foundation_year_check check(foundation_year > 0);
alter table space_programs add constraint workers_count_check check(workers_count > 0);
alter table space_programs add constraint budget_check check(budget >= 0);

alter table astro_objects add constraint discovery_year_check check(discovery_year > 0);
alter table astro_objects add constraint distance_check check(distance > 0);

alter table satellites add constraint price_check check (price > 0);
alter table satellites add constraint creation_year_check check (creation_year > 0);
alter table satellites add constraint launch_year_check check (launch_year > 0);

alter table cosmonauts add constraint birth_year_check check(birth_year > 0);
alter table cosmonauts add constraint mass_check check(mass > 0);
alter table cosmonauts add constraint growth_check check(growth > 0);
