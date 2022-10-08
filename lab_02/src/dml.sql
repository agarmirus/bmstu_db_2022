-- 1. Инструкция SELECT, использующая предикат сравнения
select name, country, workers_count
from space_programs
where workers_count > 500
order by workers_count;

-- 2. Инструкция SELECT, использующая предикат BETWEEN
select distinct ao.astro_object_name, ao.discovery_year, glx.name
from astro_objects ao inner join galaxies glx on ao.galaxy_id = glx.id
where ao.discovery_year between 1950 and 1970
order by ao.discovery_year;

-- 3. Инструкция SELECT, использующая предикат LIKE
select name, birth_year
from cosmonauts
where name like '% %son'
order by name;

-- 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом
select stlt.stlt_name, stlt.stlt_type, stlt.astro_object_id
from satellites stlt
where stlt.id in (select satellite_id
                  from prog_stlt_rel
                  where space_program_id = 641)
order by stlt.stlt_name;

-- 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом
select stlt_name, stlt_type, astro_object_id
from satellites
where not exists (select satellite_id
                  from prog_stlt_rel
                  where satellite_id = satellites.id)
order by stlt_name;

-- 6. Инструкция SELECT, использующая предикат сравнения с квантором
select csm1.name, csm1.birth_year, csm1.space_program_id
from cosmonauts csm1
where csm1.birth_year >= all (select csm2.birth_year
                              from cosmonauts csm2
                              where csm1.space_program_id = csm2.space_program_id
                              and csm1.id != csm2.id)
order by csm1.space_program_id;

-- 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
select country, round(avg(budget)) avg_budget, round(sum(budget) / count(country)) truth_avg
from (select country, budget
      from space_programs) country_total_budget
group by country
order by country;

-- 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов
select name,
(select round(avg(mass))
from cosmonauts csm1
where csm1.space_program_id = csm2.space_program_id) prog_avg_mass
from cosmonauts csm2;

-- 9. Инструкция SELECT, использующая простое выражение CASE
select name,
case country
    when 'Russia' then 'Отечественная'
    else 'Иностранная'
end is_russian
from space_programs
order by is_russian desc;

-- 10. Инструкция SELECT, использующая поисковое выражение CASE
select stlt_name,
case
    when launch_year = creation_year then 'Запущен сразу'
    else 'Запущен позже'
end fast_launch
from satellites
order by fast_launch desc;

-- 11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
--select *
--into temp lenticular_galaxy
--from galaxies
--where galaxy_type = 'Линзообразная';

-- 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM.
select tall_cosmonauts.name, tall_cosmonauts.growth, sp.name
from space_programs sp inner join (select id, name, growth, space_program_id
                                   from cosmonauts
                                   where growth >= 190)
                                   as tall_cosmonauts on tall_cosmonauts.space_program_id = sp.id
order by tall_cosmonauts.growth, tall_cosmonauts.name;

-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3
select *
from galaxies
where id in (select galaxy_id
             from astro_objects ao
             where ao.id not in (select distinct stlt.astro_object_id
                                 from satellites stlt
                                 where stlt.astro_object_id = ao.id));

-- 14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
select country, round(avg(growth)) as avg_growth
from cosmonauts csm inner join space_programs sp on csm.space_program_id = sp.id
group by country
order by country;

-- 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING
select country, round(avg(growth)) as avg_growth
from cosmonauts csm inner join space_programs sp on csm.space_program_id = sp.id
group by country
having avg(growth) > 175
order by country;

-- 16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
insert into prog_stlt_rel (space_program_id, satellite_id)
values (681, 1);

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса
insert into space_programs (id, name, foundation_year, workers_count, country, budget)
select MAX(id) + 1, 'Kerbal Space Program', 2015, 500, 'Kerbin', MAX(budget)
from space_programs;

-- 18. Простая инструкция UPDATE
update galaxies
set galaxy_type = 'Спиральная с перемычкой'
where id = 193;

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
update cosmonauts
set growth = (select MAX(growth)
              from cosmonauts)
where id = 10;

-- 20. Простая инструкция DELETE.
delete from space_programs
where country = 'Kerbin';

-- 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
delete from satellites stlt
where stlt.id not in (select distinct satellite_id
                      from prog_stlt_rel);

-- 22. Инструкция SELECT, использующая простое обобщенное табличное выражение
with cte (name, price) as (
    select stlt_name, price
    from satellites
    where price >= 200000000
)
select round(avg(price))
from cte;

-- 23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
with recursive rec_cte (id, name, birth_year, space_program_id) as
(
    select csm1.id, csm1.name, csm1.birth_year, csm1.space_program_id
    from cosmonauts csm1
    where csm1.id = 995
    union all
    select csm2.id, csm2.name, csm2.birth_year, csm2.space_program_id
    from cosmonauts csm2 inner join rec_cte rc on rc.id + 1 = csm2.id
)
select *
from rec_cte;

-- 24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
select stlt_name,
       avg(price) over(partition by astro_object_id) avg_price,
       min(price) over(partition by astro_object_id) min_price,
       max(price) over(partition by astro_object_id) max_price,
       astro_object_id
from satellites;

-- 25. Оконные функции для устранения дублей
insert into space_programs (id, name, foundation_year, workers_count, country, budget)
select MAX(id) + 1, 'Kerbal Space Program', 2015, 500, 'Kerbin', MAX(budget)
from space_programs;

insert into space_programs (id, name, foundation_year, workers_count, country, budget)
select MAX(id) + 1, 'Kerbal Space Program', 2015, 500, 'Kerbin', MAX(budget)
from space_programs;

with sp_pr (num, name, country) as
(
    select row_number() over (partition by name, country order by sp.id) as num, name, country
    from space_programs sp
    where sp.id >= 995
)
select name, country
from sp_pr
where num = 1;
