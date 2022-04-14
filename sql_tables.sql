-- Simple car table
CREATE TABLE car (
    id uuid DEFAULT gen_random_uuid () PRIMARY KEY,
    make varchar(50),
    model varchar(50),
    make_year smallint,
    comfort_level smallint
);

-- Simple member table
CREATE TABLE memberuser (
    id uuid DEFAULT gen_random_uuid () PRIMARY KEY,
    name varchar(50),
    contact_number character(15),
    licence_valid_from date NOT NULL
);

-- Simple preference table
CREATE TABLE memberuser_preference (
    memberuser_id uuid PRIMARY KEY REFERENCES memberuser(id),
    is_smoking character(1),
    is_pet character(1)
);

-- Simple memberuser_car table
CREATE TABLE memberuser_car (
    id uuid DEFAULT gen_random_uuid () PRIMARY KEY,
    memberuser_id uuid REFERENCES memberuser(id),
    car_id uuid REFERENCES car(id),
    car_number varchar(50),
    car_color varchar(50)
);

-- Simple city table
CREATE TABLE city (
    id uuid DEFAULT gen_random_uuid () PRIMARY KEY,
    city_name varchar(200) UNIQUE,
    state_name varchar(100),
    country varchar(90)
);

-- Simple ride table
CREATE TABLE ride (
    id uuid DEFAULT gen_random_uuid () PRIMARY KEY,
    memberuser_car_id uuid REFERENCES memberuser_car(id),
    created_on date,
    travel_start date,
    src_city_id uuid REFERENCES city(id),
    dst_city_id uuid REFERENCES city(id),
    seats_available smallint,
    price_per_head numeric(9,2)
);
