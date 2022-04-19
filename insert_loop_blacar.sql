DO $$
DECLARE
    car_id uuid := 'cdcd9726-6978-4c39-8770-ee1c4775c1bc';
    driver_user_id uuid;
    user_car_id uuid;
    src_city_id_rnd uuid;
    dst_city_id_rnd uuid;
    ride_date date;
BEGIN

    -- we use real cities
    src_city_id_rnd := gen_random_uuid();
    dst_city_id_rnd := gen_random_uuid();
    INSERT INTO city (id, city_name, state_name, country) VALUES (src_city_id_rnd, 'Pavlohrad', 'Dnipropetrovsk Oblast', 'Ukraine');
    INSERT INTO city (id, city_name, state_name, country) VALUES (dst_city_id_rnd, 'Blyznyuky', 'Kharkiv Oblast', 'Ukraine');
    
    -- gen 15-000 drivers in one car
    FOR iter_driver IN 1..15000 LOOP
        driver_user_id := gen_random_uuid();
        user_car_id := gen_random_uuid();

        INSERT INTO memberuser (id, name, contact_number, licence_valid_from) 
        VALUES (driver_user_id,
                substr(md5(random()::text), 0, (random() * 10 + 5)::int) || ' ' || substr(md5(random()::text), 0, (random() * 10 + 5)::int),
                (random() * 999999999999 + 380000000000000)::bigint::character(15),
                (NOW() - (random() * (NOW() + '7 years' - NOW())))::date);

        -- not for everyone
        IF iter_driver % 3 = 0 THEN
            INSERT INTO memberuser_preference (memberuser_id, is_smoking, is_pet) 
            VALUES (driver_user_id, CASE WHEN random() < 0.5 THEN 'Y' ELSE 'N' END, CASE WHEN random() < 0.5 THEN 'Y' ELSE 'N' END);
        END IF;

        INSERT INTO memberuser_car (id, memberuser_id, car_id, car_number, car_color) 
        VALUES (user_car_id, driver_user_id, car_id, upper(substr(md5(random()::text), 0, 8)), substr(md5(random()::text), 0, 6));

            -- gen 2 rides with this cities and this driver
            FOR iter_ride IN 1..2 LOOP
                ride_date := (NOW() - (random() * (NOW()+'228 days' - NOW())))::date;
                INSERT INTO ride (memberuser_car_id, created_on, travel_start, src_city_id, dst_city_id, seats_available, price_per_head)
                VALUES (user_car_id, ride_date, ride_date, src_city_id_rnd, dst_city_id_rnd, 
                       (random() * 7 + 1)::smallint, 
                       (random() * 200)::numeric(9,2));
            END LOOP;
    END LOOP;
END $$;
