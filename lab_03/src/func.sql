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
    
        return select name, birth_year from cosmonauts where birth_year < avg_birth_year;
    end;
    $$
    language plpgsql;

select *
from old_csms();
