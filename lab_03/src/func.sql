-- Скалярная функция
create or replace function is_even(value int) returns boolean
    language sql
    return value % 2 = 0;

select *
from space_programs
where is_even(budget);

-- Подставляемая табличная функция
create or replace function get_glx_aos(glx_id int) returns table (ao_name text, ao_type text) as
    $$
    select astro_object_name, astro_object_type
    from astro_objects
    where galaxy_id = glx_id
    $$
    language sql;

select *
from get_glx_aos(835);

-- Многооператорная табличная функция
create or replace function old_csms() returns table (csm_name text, csm_birth_year int) as
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
create or replace function fib(n int) returns int as 
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
create or replace procedure add_sp(sp_name text, sp_year int, sp_wc int, sp_country text, sp_budget int) as 
    $$
    insert into space_programs (id, name, foundation_year, workers_count, country, budget)
    select MAX(id) + 1, sp_name, sp_year, sp_wc, sp_country, sp_budget
    from space_programs;
    $$
    language sql;

call add_sp('Kerbal Space Program', 2015, 500, 'Kerbin', 10000000);

-- Рекурсивная хранимая процедура
create or replace procedure add_sp_n(sp_name text, sp_year int, sp_wc int, sp_country text, sp_budget int, n int = 1) as
    $$
    begin
        if n > 0 then
            call add_sp(sp_name, sp_year, sp_wc, sp_country, sp_budget);
            call add_sp_n(sp_name, sp_year, sp_wc, sp_country, sp_budget, n - 1);
        end if;
    end;
    $$
    language plpgsql;

call add_sp_n('Kerbal Space Program', 2015, 500, 'Kerbin', 10000000, 2);

-- Хранимая процедура с курсором
create or replace procedure drop_sp(sp_name text) as
    $$
    declare sp_id int;
    declare curs cursor for select id from space_programs where name = sp_name;
    begin
        open curs;
        loop
            fetch curs into sp_id;
            if sp_id is null then
                exit;
            end if;
            delete from space_programs where id = sp_id;
        end loop;
        close curs;
    end;
    $$
    language plpgsql;

call drop_sp('Kerbal Space Program');

-- Триггер AFTER
create or replace function tr1_func() returns trigger as
    $tr1$
    begin
        if new.workers_count is null then
            update space_programs
            set workers_count = 1
            where id = new.id;
        end if;
        return old;
    end
    $tr1$
    language plpgsql;

create or replace trigger tr1 after update of workers_count on space_programs
    for each row
    execute function tr1_func();

update space_programs
set workers_count = null
where name = 'Kerbal Space Program';

-- Триггер INSTEAD OF
create or replace view v1 as
    select *
    from space_programs
    where name = 'Kerbal Space Program';

create or replace function tr2_func() returns trigger as
    $tr2$
    begin
        raise exception 'deleting is forbidden';
        return new;
    end
    $tr2$
    language plpgsql;

create or replace trigger tr2 instead of delete on v1
    for each row
    execute procedure tr2_func();

delete from v1 where name = 'Kerbal Space Program';
