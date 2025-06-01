-- Active: 1748422892414@@127.0.0.1@5432@assignment_2

-- creating necessary table
create table rangers (
    ranger_id serial primary key,
    "name" varchar(50),
    "region" text
)

create table species (
    species_id serial primary key,
    common_name varchar(50),
    scientific_name varchar(50),
    discovery_date date,
    conservation_status text
)

create table sightings (
    sighting_id serial primary key,
    ranger_id int REFERENCES rangers (ranger_id) on delete CASCADE,
    species_id int REFERENCES species (species_id) on delete CASCADE,
    sighting_time TIMESTAMP,
    location text,
    notes text
)

-- data insertion into the table

insert into rangers (name, region) 
values('Alice Green', 'Northern Hills'),
('Bob White','River Delta'),
('Carol King', 'Mountain Range')

insert into species(common_name, scientific_name, discovery_date, conservation_status) 
values ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

insert into sightings (species_id, ranger_id, location, sighting_time, notes)
values (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

-- problem 1
insert into rangers (name, region) values('Derek Fox','Coastal Plains');

-- problem 2

select count(*) as unique_species_count from (select species_id from sightings group by species_id) as species_group;

-- problem 3

select * from  sightings where location like '%Pass';

-- problem 4  

select r.name, count(s.ranger_id) as total_sightings from rangers as r join sightings as s on s.ranger_id = r.ranger_id group by r.name;

-- problem 5

select common_name from species where species_id not IN (select species_id from sightings);

-- problem 6

select sp.common_name, si.sighting_time,r.name as ranger_name from rangers as r join sightings as si on r.ranger_id = si.ranger_id join species as sp on si.species_id = sp.species_id  order by sighting_time DESC limit 2;

-- problem 7

update species set conservation_status = 'Historic' where extract(year from discovery_date) < 1800;

-- problem 8

select sighting_id, case when extract(hour from sighting_time) < 12 then 'Morning' when extract(hour from sighting_time) >= 12 and extract(hour from sighting_time) <17 then 'Afternoon' else 'Evening' end as time_of_day from sightings;

-- problem 9 

delete from rangers where ranger_id not in (select ranger_id from sightings);

