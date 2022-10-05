-- 1. Программы с числом сотрудников более 500
select name, country, workers_count
from space_programs
where workers_count > 500
order by workers_count;

-- 2. Астрономические объекты, открытые между 1950 и 1970 годами
select distinct ao.astro_object_name, ao.discovery_year, glx.name
from astro_objects ao inner join galaxies glx on ao.galaxy_id = glx.id
where ao.discovery_year between 1950 and 1970
order by ao.discovery_year;

-- 3. Космонавты, в фамилиях которых присутствует окончание 'son'
select name, birth_year
from cosmonauts
where name like '% %son'
order by name;

-- 4. Спутники, поддерживаемые программой id = 641
select stlt.stlt_name, stlt.stlt_type, stlt.astro_object_id
from satellites stlt
where stlt.id in (select satellite_id
                  from prog_stlt_rel
                  where space_program_id = 641)
order by stlt.stlt_name;

-- 5. Список неподдерживаемых спутников (космический мусор)
select stlt_name, stlt_type, astro_object_id
from satellites
where not exists (select satellite_id
                  from prog_stlt_rel
                  where satellite_id = satellites.id)
order by stlt_name;

-- 6. Самые молодые космонавты в каждой программе
select csm1.name, csm1.birth_year, csm1.space_program_id
from cosmonauts csm1
where csm1.birth_year >= all (select csm2.birth_year
                              from cosmonauts csm2
                              where csm1.space_program_id = csm2.space_program_id
                              and csm1.id != csm2.id)
order by csm1.space_program_id;

-- 7. Средний бюджет программ по странам
select country, round(avg(budget)) avg_budget, round(sum(budget) / count(country)) truth_avg
from (select country, budget
      from space_programs) country_total_budget
group by country
order by country;

-- 8. Средняя масса космонавтов по программам
select name,
(select round(avg(mass))
from cosmonauts csm1
where csm1.space_program_id = csm2.space_program_id) prog_avg_mass
from cosmonauts csm2;

-- 9. Поиск российских программ
select name,
case country
    when 'Russia' then 'Отечественная'
    else 'Иностранная'
end is_russian
from space_programs
order by is_russian desc;

-- 10. Поиск спутников, запущенных сразу после создания
select stlt_name,
case
    when launch_year = creation_year then 'Запущен сразу'
    else 'Запущен позже'
end fast_launch
from satellites
order by fast_launch desc;

-- 11. Временная таблица с информацией о линзообразных галактиках
--select *
--into temp lenticular_galaxy
--from galaxies
--where galaxy_type = 'Линзообразная';
