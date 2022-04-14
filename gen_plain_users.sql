do $$
declare
    driver_user_id uuid;
begin

    -- gen users without car
	for iter_driver in 1..500000 loop
        driver_user_id := gen_random_uuid();

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
        
    end loop;
end $$;
