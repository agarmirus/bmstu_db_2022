-- create extension plpython3u;

-- Скалярная функция
create or replace function clr_scalar_func(a float8) returns float8 as 
    $$
    import math
    if a < 0.0:
        return 0.0;
    else:
        return math.sqrt(a)
    $$
    language plpython3u;

select *
from clr_scalar_func(4.0);

-- Агрегатная функция
create or replace function mult_func(n int, m int) returns int as
    $$
    return n * m
    $$
    language plpython3u;

create or replace aggregate mult(int)
(
    initcond = 1,
    stype = int,
    sfunc = mult_func
);

select mult(id) from space_programs where id between 1 and 5;

-- Табличная функция
create or replace function clr_table_func(ao int)
returns table (s_name text, s_type text, ao_id int) as
    $$
    res = []
    satellites = plpy.execute("select stlt_name as s_name, stlt_type as s_type, astro_object_id as ao_id from satellites")
    
    for stlt in satellites:
        plpy.info(stlt)
        if stlt['ao_id'] == ao:
            res.append(stlt)
    
    return res
    $$
    language plpython3u;

select * from clr_table_func(987);


