alter table galaxies add constraint galaxy_type_check check(radius > 0);
alter table galaxies add constraint galaxy_mass_check check(mass > 0);

alter table planet_systems add constraint pl_count_check check(planets_count >= 0);
alter table planet_systems add constraint st_count_check check(satelites_count >= 0);
alter table planet_systems add constraint cm_count_check check(comets_count >= 0);
alter table planet_systems add constraint glx_id_frgn_key foreign key (galaxy_id) references galaxies(id);

alter table stars add constraint stellar_class_check
check(stellar_class in ('O', 'B', 'A', 'F', 'G', 'K', 'M'));
alter table stars add constraint star_mass_check check(mass > 0);
alter table stars add constraint ph_temp_check check(photosphere_temperature > 0);
alter table stars add constraint pl_sys_id_frgn_key foreign key (planet_system_id) references planet_systems(id);

alter table planets add constraint pl_radius_check check(avrg_radius > 0);
alter table planets add constraint pl_mass_check check(mass > 0);
alter table planets add constraint pl_st_count_check check(satelites_count >= 0);
alter table planets add constraint pl_sys_id_frgn_key foreign key (planet_system_id) references planet_systems(id);

alter table satelites add constraint stlt_radius_check check(avrg_radius > 0);
alter table satelites add constraint stlt_mass_check check(mass > 0);
alter table satelites add constraint pl_rot_time_check check(planet_rotation_time >= 0);
alter table satelites add constraint pl_id_frgn_key foreign key (planet_id) references planets(id)