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

-- we can definetly add inner select for src and dst cities.
-- it'll be a kind of filter, we'll get their id's and then run finding in ride with them
-- instead of comparing every ride with all cities
-- we'll have a limited list of cities.
-- Well, we need somehow prefilter data for easier joining
-- and we can perform this inner select to join on them
-- not on the whole tables
-- but in reality we should get rid of them bcs Postres joins know better :=)