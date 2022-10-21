-- Скалярная функция
create or replace function is_even(value int) returns boolean
    language sql
    return $1 % 2 = 0;

select *
from space_programs
where is_even(budget);

-- Подставляемая табличная функция
create or replace function get_glx_aos(glx_id int) returns table (ao_name text, ao_type text)
    as
    $$
    select astro_object_name, astro_object_type
    from astro_objects
    where galaxy_id = $1
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

