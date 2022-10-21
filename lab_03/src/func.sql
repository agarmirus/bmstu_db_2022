-- Скалярная функция
create or replace function is_even(value int) returns boolean
    language sql
    return value % 2 = 0;

select *
from space_programs
where is_even(budget);

-- Подставляемая табличная функция
create or replace function get_glx_aos(glx_id int) returns table (ao_name text, ao_type text)
    as
    $$
    select astro_object_name, astro_object_type
    from astro_objects
    where galaxy_id = glx_id
    $$
    language sql;

select *
from get_glx_aos(835);

-- Многооператорная табличная функция
create or replace function old_csms() returns table (csm_name text, csm_birth_year int)
    as
    $$
    declare avg_birth_year int = 0;
    begin        
        select avg(birth_year) into avg_birth_year
        from cosmonauts;
    
        return query select name, birth_year from cosmonauts where birth_year < avg_birth_year;
    end;
    $$
    language plpgsql;

select *
from old_csms();

-- Рекурсивная функция
create or replace function fib(n int) returns int
    as 
    $$
    begin
        if n = 0 or n = 1 then
            return 1;
        elsif n > 1 then
            return fib(n - 1) + fib(n - 2);
        end if;
        
        return 0;
    end;
    $$
    language plpgsql;

select *
from fib(10);

-- Хранимая процедура с параметрами
create or replace procedure add_sp(sp_name text, sp_year int, sp_wc int, sp_country text, sp_budget int)
    as 
    $$
    insert into space_programs (id, name, foundation_year, workers_count, country, budget)
    select MAX(id) + 1, sp_name, sp_year, sp_wc, sp_country, sp_budget
    from space_programs;
    $$
    language sql;

call add_sp('Kerbal Space Program', 2015, 500, 'Kerbin', 10000000);

-- Рекурсивная хранимая процедура