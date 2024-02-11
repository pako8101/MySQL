drop database preserves_db;
create database preserves_db;
use preserves_db;
create table continents
(
    id   int primary key auto_increment,
    name varchar(40) not null unique

);

create table countries
(
    id           int primary key auto_increment,
    name         varchar(40) not null unique,
    country_code varchar(10) not null unique,
    continent_id int         not null,
    constraint fk_countries_continents
        foreign key (continent_id)
            references continents (id)

);

create table preserves
(
    id             int primary key auto_increment,
    name           varchar(255) not null unique,
    latitude       decimal(9, 6),
    longitude      decimal(9, 6),
    area           int,
    type           varchar(20),
    established_on date

);
create table positions
(
    id           int primary key auto_increment,
    name         varchar(40) not null unique,
    description  text,
    is_dangerous tinyint(1)

);
create table workers
(
    id              int primary key auto_increment,
    first_name      varchar(40) not null,
    last_name       varchar(40) not null,
    age             int,
    personal_number varchar(20) not null unique,
    salary          decimal(19, 2),
    is_armed        tinyint(1),
    start_date      date,
    preserve_id     int,
    position_id     int,
    constraint fk_workers_preserves
        foreign key (preserve_id)
            references preserves (id),
    constraint fk_workers_positions
        foreign key (position_id)
            references positions (id)
);

create table countries_preserves
(
    country_id  int,
    preserve_id int,
    constraint fk_countries_preserves_countries
        foreign key (country_id)
            references countries (id),
    constraint fk_countries_preserves_preserves
        foreign key (preserve_id)
            references preserves (id)

);

# 2
insert into preserves(name, latitude,
                      longitude, area, type, established_on)
select concat(p.name, ' ', 'is in South Hemisphere'),
       p.latitude,
       p.longitude,
       p.area * p.id,
       lower(p.type),
       p.established_on
from preserves as p
where p.latitude < 0;

# 3

update workers as w
set w.salary = w.salary + 500
where w.position_id in (5, 8, 11, 13);

# 4
delete p
from preserves as p
where established_on is null;

# 5

select concat(w.first_name, ' ', w.last_name)
                                            as full_name,
       datediff('2024-01-01', w.start_date) as
                                               days_of_experience
from workers as w
having days_of_experience > 5 * 365

order by days_of_experience desc
limit 10;

# 6
select w.id,
       w.first_name,
       w.last_name,
       p.name as preserve_name,
       c.country_code


from workers as w
         join preserves p on p.id = w.preserve_id
         join countries_preserves cp on p.id = cp.preserve_id
         join countries c on c.id = cp.country_id
where w.salary > 5000
  and age < 50
order by c.country_code asc;

# 7

select p.name, count(*) as armed_workers
from preserves as p
         join workers w on p.id = w.preserve_id
where w.is_armed is true
group by p.name
order by armed_workers desc, p.name;

# 8
select p.name,
       c.country_code,
       year(p.established_on)
           as founded_in
from preserves as p
         join countries_preserves cp on p.id = cp.preserve_id
         join countries c on c.id = cp.country_id
where month(established_on) = 5
order by established_on;


# 9
select p.id,
       p.name,
       (CASE
            WHEN p.area <= 100 THEN 'very small'
            WHEN p.area <= 1000 THEN 'small'
            WHEN p.area <= 10000 THEN 'medium'
            WHEN p.area <= 50000 THEN 'large'
            ELSE 'very large'
           END) AS 'category'
from preserves as p

order by p.area desc ;

# 10
delimiter $$
create function udf_average_salary_by_position_name (position_name VARCHAR(40))
    returns decimal(10,2)
deterministic
    begin
        declare position_average_salary decimal(10,2);
    set position_average_salary:= (
        select avg(w.salary) as position_average_salary
        from  workers as w
                  join positions p on p.id = w.position_id
        where p.name = position_name
        group by p.name
        );
        return position_average_salary;
end $$

drop function  udf_average_salary_by_position_name;
select udf_average_salary_by_position_name('Forester');
select  p.name, avg(w.salary) as position_average_salary
from  workers as w
join positions p on p.id = w.position_id
where p.name = 'Forester';

# 11
DELIMITER $$
CREATE PROCEDURE udp_increase_salaries_by_country
    (country_name VARCHAR(40))
begin
#     declare country_id int;
#     SELECT id INTO country_id
#     FROM countries
#     WHERE name = country_name;
    update workers as w
        join preserves p on p.id = w.preserve_id
        join countries_preserves cp on p.id = cp.preserve_id
     join countries c on c.id = cp.country_id
    set w.salary = round(w.salary * 1.05,2)
    where c.name = country_name;
#     select  w.first_name,w.last_name
#          ,round(w.salary * 1.05,1.3) as salary_after from  workers as w
#                                                     join preserves p on p.id = w.preserve_id
#                                                     join countries_preserves cp on p.id = cp.preserve_id
#                                                     join countries c on c.id = cp.country_id
end $$

drop procedure udp_increase_salaries_by_country;
call udp_increase_salaries_by_country('');

select  w.first_name,w.last_name,'->',w.salary salary_before
     ,w.salary * 1.05 as salary_after from  workers as w
join preserves p on p.id = w.preserve_id
join countries_preserves cp on p.id = cp.preserve_id
join countries c on c.id = cp.country_id
where c.name = 'Germany';














