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

-- select tgz.name, tgz.salary, tgz.seats_available
-- from
-- (

select 
mu.id, 
mu.name, 
mu.contact_number, 
ca.make, 
mp.is_pet, 
avg(ri.price_per_head) as salary, 
src.state_name, 
dst.state_name, 
sum(ri.seats_available) as pplcount
, ri.created_on
from memberuser mu, memberuser_car mc, car ca, memberuser_preference mp, ride ri, city src, city dst
where mu.id=mc.memberuser_id
and mc.car_id=ca.id
and mp.memberuser_id=mu.id
and ri.memberuser_car_id=mc.id
and ri.src_city_id=src.id
and ri.dst_city_id=dst.id
and ca.make <> ALL (select make from car where make like 'Opel' or make like 'Daewoo')
and mp.is_pet <> 'N'
and (src.state_name <> 'Zhytomyr Oblast' and src.state_name <> 'Vinnytsia Oblast' and src.state_name <> 'Chernivtsi Oblast')
and (dst.state_name <> 'Zhytomyr Oblast' and dst.state_name <> 'Vinnytsia Oblast' and dst.state_name <> 'Chernivtsi Oblast')
--and ri.created_on::text like '____-01-__'
  
  group by 
  mu.id, 
  ca.make, 
  mp.is_pet, 
  src.state_name, 
  dst.state_name--,-- 
  ,ri.created_on -- find date range in subquery
--) as tgz


;