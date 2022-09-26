create table if not exists galaxies
(
    id int not null primary key,
    name text not null,
    galaxy_type text,
    radius float8,
    mass float8
);
