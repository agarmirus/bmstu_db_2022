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
    astro_object_type text,
    discovery_year int,
    distance float8,
    
    galaxy_id int,
    foreign key (galaxy_id) references galaxies(id)
);

create table if not exists satellites
(
    id int primary key,
    stlt_name text,
    stlt_type text,
    price int,
    creation_year int,
    launch_year int,
    
    astro_object_id int,
    foreign key (astro_object_id) references astro_objects(id)
);

create table if not exists cosmonauts
(
    id int primary key,
    name text,
    birth_year int,
    mass int,
    growth int,
    
    space_program_id int,
    foreign key (space_program_id) references space_programs(id)
);

create table if not exists prog_stlt_rel
(
    space_program_id int,
    satellite_id int,
    foreign key (space_program_id) references space_programs(id),
    foreign key (satellite_id) references satellites(id)
);

create table if not exists prog_obj_rel
(
    space_program_id int,
    astro_object_id int,
    foreign key (space_program_id) references space_programs(id),
    foreign key (astro_object_id) references astro_objects(id)
);
