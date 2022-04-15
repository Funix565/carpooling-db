-- select info about drivers
-- for 6 month (range)? -> (LIKE ____-01-__); 
-- NOT on the carS (e.g. Opel, Deawoo)
-- pref=is_pet

-- вывести челов, у которых средний заработок больше, чем средний заработок во всех областях
-- with avg earning greater than all avg earning in Oblast ORDER DESC -> All; ANY. group by Oblast

-- NOT in cities from some stateS (e.g. Kyiv Oblast, Poltava Oblast ...) -> use OR change to IN
-- how many people they had  ORDER ASC
-- =================================================================================================
-- include subqueries with select -> a kind of filter to minimaze rows for join
-- but in reality we will get rid of this redundancy

-- Also, the ANY and ALL operators are some that you should be careful with because, 
-- by including these into your queries, the index won’t be used. 
-- Alternatives that will come in handy here are aggregation functions like MIN or MAX.
-- that the biggest table is placed last in the join.

select mu.id, 
mu.name, mu.contact_number, ca.make, mp.is_pet, src.city_name, dst.city_name, ri.created_on,
sum(ri.price_per_head), sum(ri.seats_available)
from car ca, memberuser_car mc, memberuser mu, memberuser_preference mp, ride ri, city dst, city src
where ca.id=mc.car_id
and mu.id=mc.memberuser_id
and mu.id=mp.memberuser_id
and ri.memberuser_car_id=mc.id
and ri.src_city_id=src.id
and ri.dst_city_id=dst.id
and mp.is_pet = 'Y'
and ca.make = 'Opel'
and ri.created_on > '2021-12-12'
and src.city_name='Uzhhorod'
group by mu.id, ca.make, mp.is_pet, src.city_name, dst.city_name, ri.created_on
order by sum(ri.price_per_head), sum(ri.seats_available)