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

--select * from cosm_json, json_populate_record(null::cosm, d);
--
--select json_populate_record(null::cosm, d)
--from cosm_json;

insert into cosm
select id, name, birth_year, mass, growth, space_program_id
from cosm_json, json_populate_record(null::cosm, d);

select * from cosm;

-- 3. Таблица с json
insert into cosm_json
select * from json_build_object('id', 1001, 'name', 'Bruh Bruhovych', 'birth_year', 1999, 'mass', 99, 'growth', 199, 'space_program_id', null);

select * from cosm_json;

-- 4.
-- 4.1
select * from json_extract_path_text((select * from cosm_json where json_extract_path_text(d, 'id') = '998'), 'name');

-- 4.2
select d->'name' as name
from cosm_json;

-- 4.3
select (d->'id')::text::int as id
from cosm_json
where (d->'id')::text::int = 2000;

-- 4.4

