create table if not exists galaxies
(
    id int primary key,
    name text,
    galaxy_type text,
    radius float8,
    mass float8
);

create table if not exists space_programs
(
    id int primary key,
    name text,
    foundation_year int,
    workers_count int,
    country text,
    budget int
);

create table if not exists astro_objects
(
    id int primary key,
    astro_object_name text,
    discovery_year int,
    distance float8,
    
    galaxy_id int,
    foreign key (galaxy_id) references galaxies(id)
);

create table if not exists satellites
(
    id int primary key,
    stlt_type text,
    price int,
    creation_year int,
    launch_year int,
    
    astro_object_id int,
    foreign key (astro_object_id) references astro_objects(id)
);

create table if not exists stlt_prog_rel
(
    space_program_id int,
    satellite_id int,
    foreign key (space_program_id) references space_programs(id),
    foreign key (satellite_id) references satellites(id)
);

create
