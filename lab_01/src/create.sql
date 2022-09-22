create table if not exists galaxies
(
    id int not null primary key,
    name text not null,
    galaxy_type text,
    radius float8,
    mass float8
);

create table if not exists planet_systems
(
    id int not null primary key,
    name text not null,
    planets_count int,
    satelites_count int,
    comets_count int,
    galaxy_id int
);

create table if not exists stars
(
    id int not null primary key,
    name text not null,
    stellar_class char(1),
    mass float8,
    photosphere_temperature float8,
    planet_system_id int
);

create table if not exists planets
(
    id int not null primary key,
    name text not null,
    avrg_radius float8,
    mass float8,
    satelites_count int,
    planet_system_id int
);

create table if not exists satelites
(
    id int not null primary key,
    name text not null,
    avrg_radius float8,
    mass float8,
    planet_rotation_time float8,
    planet_id int
);
