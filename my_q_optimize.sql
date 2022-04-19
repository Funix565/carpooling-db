-- select info about drivers
-- for 6 month (range)? -> (LIKE ____-01-__); 
-- NOT on the carS (e.g. Opel, Deawoo)
-- pref=is_pet

-- вывести челов, у которых средний заработок больше, чем средний заработок в указанных областях
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

SELECT
    -- get info about drivers. fileds as a proof.
    mu.id
    ,mu.name
    ,mu.contact_number
    ,ca.make
    ,mp.is_pet
    
    -- earnings for every driver
    ,avg(ri.price_per_head) AS salary

    -- easier to group by. SRC matters, not DST
    ,src.state_name

    -- how many people they helped
    ,sum(ri.seats_available) AS pplcount

    -- and how many rides they made
    ,count(ri.created_on) AS days
FROM
    memberuser mu
    ,memberuser_car mc
    ,car ca
    ,memberuser_preference mp
    ,ride ri
    ,city src
    ,city dst
WHERE 
    mu.id=mc.memberuser_id
    AND mc.car_id=ca.id
    AND mp.memberuser_id=mu.id
    AND ri.memberuser_car_id=mc.id
    AND ri.src_city_id=src.id
    AND ri.dst_city_id=dst.id

    -- exclude bad cars
    AND ca.make <> ALL (SELECT make FROM car WHERE make LIKE 'Opel' OR make LIKE 'Daewoo')
    
    -- pets allowed
    AND mp.is_pet <> 'N'

    -- exclude states
    AND (src.state_name <> 'Zhytomyr Oblast' AND src.state_name <> 'Vinnytsia Oblast')
    AND (dst.state_name <> 'Zhytomyr Oblast' AND dst.state_name <> 'Vinnytsia Oblast')

    -- specify date. change to date comparison
    AND ri.created_on::text LIKE '____-11-__'
GROUP BY
    -- for every driver
    mu.id

    -- this should not affect the result because driver is unique
    ,ca.make
    ,mp.is_pet
    ,src.state_name
    
    -- compare selected avg driver's salary with avg salary by states
HAVING avg(ri.price_per_head) > ALL
    (
	    SELECT
	        avg(ri.price_per_head)
	    FROM
	        memberuser_car mc
	        ,ride ri
	        ,city src
	        ,city dst
	    WHERE
	        mc.id=ri.memberuser_car_id
	        AND ri.src_city_id=src.id
	        AND ri.dst_city_id=dst.id
	        AND (src.state_name <> 'Zhytomyr Oblast' AND src.state_name <> 'Vinnytsia Oblast')
	        AND (dst.state_name <> 'Zhytomyr Oblast' AND dst.state_name <> 'Vinnytsia Oblast')

        -- SRC matters
	    GROUP BY src.state_name 
	)
ORDER BY salary DESC, pplcount DESC, days ASC
;
