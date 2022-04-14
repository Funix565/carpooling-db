do $$
declare
	car_id uuid := 'cdcd9726-6978-4c39-8770-ee1c4775c1bc';
    driver_user_id uuid;
    user_car_id uuid;
    src_city_id_rnd uuid;
    dst_city_id_rnd uuid;
    ride_date date;
begin

    -- we use real cities
    src_city_id_rnd := gen_random_uuid();
    dst_city_id_rnd := gen_random_uuid();
    insert into city (id, city_name, state_name, country) values (src_city_id_rnd, 'Pavlohrad', 'Dnipropetrovsk Oblast', 'Ukraine');
    insert into city (id, city_name, state_name, country) values (dst_city_id_rnd, 'Blyznyuky', 'Kharkiv Oblast', 'Ukraine');
    
    -- gen 15-000 drivers in one car
	for iter_driver in 1..15000 loop
        driver_user_id := gen_random_uuid();
        user_car_id := gen_random_uuid();

        insert into memberuser (id, name, contact_number, licence_valid_from) 
        values (driver_user_id,
                substr(md5(random()::text), 0, (random() * 10 + 5)::int) || ' ' || substr(md5(random()::text), 0, (random() * 10 + 5)::int),
                (random() * 999999999999 + 380000000000000)::bigint::character(15),
                (NOW() - (random() * (NOW() + '7 years' - NOW())))::date);

        -- not for everyone
        if iter_driver % 3 = 0 then
            insert into memberuser_preference (memberuser_id, is_smoking, is_pet) 
            values (driver_user_id, case when random() < 0.5 then 'Y' else 'N' end, case when random() < 0.5 then 'Y' else 'N' end);
        end if;

        insert into memberuser_car (id, memberuser_id, car_id, car_number, car_color) 
        values (user_car_id, driver_user_id, car_id, upper(substr(md5(random()::text), 0, 8)), substr(md5(random()::text), 0, 6));

            -- gen 2 rides with this cities and this driver
            for iter_ride in 1..2 loop
                ride_date := (NOW() - (random() * (NOW()+'228 days' - NOW())))::date;
                insert into ride (memberuser_car_id, created_on, travel_start, src_city_id, dst_city_id, seats_available, price_per_head)
                values (user_car_id, ride_date, ride_date, src_city_id_rnd, dst_city_id_rnd, 
                       (random() * 7 + 1)::smallint, 
                       (random() * 200)::numeric(9,2));
            end loop;
    end loop;
end $$;
