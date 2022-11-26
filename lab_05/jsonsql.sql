-- 1. Извлечение данных в JSON
select row_to_json(sp) from space_programs sp;
select row_to_json(s) from satellites s;
select row_to_json(c) from cosmonauts c;
select row_to_json(ao) from astro_objects ao;

-- 2. Выгрузка JSON-файла в таблицу
copy (select row_to_json(c) from cosmonauts c)
to '/data/c.json';

create temp table if not exists cosm
(
    id int primary key,
    name text,
    birth_year int,
    mass int,
    growth int,
    
    space_program_id int
);

create temp table if not exists cosm_json(d json);

copy cosm_json from '/data/c.json';

select * from cosm_json;
