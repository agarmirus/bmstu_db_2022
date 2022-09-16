create table if not exists galaxies
(
    id int not null primary key,
    name text not null,
    galaxy_type text,
    radius float8 check(radius > 0),
    mass float8 check(mass > 0),
    absolute_magnitude float8
);

create table if not exists planet_systems
(
    id int not null primary key,
    name text not null,
    planets_count int check(planets_count >= 0),
    satelites_count int check(satelites_count >= 0),
    comets_count int check(comets_count >= 0),
    galaxy_center_distance float8 check(galaxy_center_distance > 0),
    galaxy_id int,
    foreign key (galaxy_id) references galaxies(id)
);

create table if not exists stars
(
    id int not null primary key,
    name text not null,
--    stellar_class char(1) check(stellar_class == 'W' or
--                                stellar_class == 'O' or
--                                stellar_class == 'B' or
--                                stellar_class == 'A' or 
--                                stellar_class == 'F' or
--                                stellar_class == 'G' or
--                                stellar_class == 'K' or
--                                stellar_class == 'M' or
--                                stellar_class == 'L' or
--                                stellar_class == 'T'),
    stellar_class char(1),
    mass float8 check(mass > 0),
    avrg_diameter float8 check(avrg_diameter > 0),
    absolute_magnitude float8,
    planet_system_id int,
    foreign key (planet_system_id) references planet_systems(id)
);

create table if not exists planets
(
    id int not null primary key,
    name text not null,
    avrg_radius float8 check(avrg_radius > 0),
    mass float8 check(mass > 0),
    star_rotation_time float8 check(star_rotation_time > 0),
    axis_rotation_time float8 check(axis_rotation_time > 0),
    satelites_count int check(satelites_count > 0),
    planet_system_id int,
    star_id int,
    foreign key (planet_system_id) references planet_systems(id),
    foreign key (star_id) references stars(id)
);

create table if not exists satelites
(
    id int not null primary key,
    name text not null,
    avrg_radius float8 check(avrg_radius > 0),
    mass float8 check(mass > 0),
    planet_rotation_time float8 check(planet_rotation_time > 0),
    axis_rotation_time float8 check(axis_rotation_time > 0),
    planet_id int,
    foreign key (planet_id) references planets(id)
);
