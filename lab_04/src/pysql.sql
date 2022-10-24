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

-- 
