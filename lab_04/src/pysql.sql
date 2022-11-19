create extension plpython3u;

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
        if stlt['ao_id'] == ao:
            res.append(stlt)
    
    return res
    $$
    language plpython3u;

select * from clr_table_func(987);

-- Хранимая процедура
create or replace procedure clr_proc() as
    $$
    stlts = list(map(lambda x: x["id"], plpy.execute("select id from satellites")))
    supported_stlts = list(map(lambda x: x["id"], plpy.execute("select satellite_id as id from prog_stlt_rel")))
    garbage = []
    
    for stlt in stlts:
        if (stlt not in supported_stlts):
            garbage.append(stlt)
    
    for g in garbage:
        query = "delete from satellites where id = $1"
        pr = plpy.prepare(query, ["integer"])
        plpy.execute(pr, [g])
    $$
    language plpython3u;

insert into satellites
values (1001, 'ROQUE', 'Астрономический', 10000, 2015, 2015, 120);

call clr_proc();

-- Триггер
create or replace function clr_trigger_func() returns trigger as
    $cli_trigger_func$
    plpy.error("You tried to delete russian program. Soon you will be sent to Syberia.")
    return TD["old"]
    $cli_trigger_func$
    language plpython3u;

create trigger clr_trigger after delete on space_programs
for each row
when (OLD.country = 'Russia')
execute function clr_trigger_func();

insert into space_programs
values (1001, 'Mother Russia Space Program', 1995, 500, 'Russia', 100000000);

delete from space_programs
where id = 1001;

-- Определяемый пользователем тип данных
create type pair as
(
    p1 int,
    p2 int
);

create function clr_user_type_func(p pair) returns int as
    $$
    return p["p1"];
    $$
    language plpython3u;

select *
from clr_user_type_func((1, 2));
