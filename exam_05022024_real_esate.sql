create database real_estates;
use real_estates;

create table cities
(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(60) not null unique

);

create table property_types
(
    `id`        INT PRIMARY KEY AUTO_INCREMENT,
    type        varchar(40) not null unique,
    description text

);

create table properties
(
    `id`             INT PRIMARY KEY AUTO_INCREMENT,
    address          varchar(80)    not null unique,
    price            decimal(19, 2) not null,
    area             decimal(19, 2),
    property_type_id int,
    city_id          int,

    CONSTRAINT fk_properties_property_types FOREIGN KEY (property_type_id)
        REFERENCES property_types (id),
    CONSTRAINT fk_properties_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)


);

create table agents
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(40) not null,
    last_name  varchar(40) not null,
    phone      varchar(20) not null unique,
    email      varchar(50) not null unique,
    city_id    int,
    CONSTRAINT fk_agents_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)


);
create table buyers
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    first_name varchar(40) not null,
    last_name  varchar(40) not null,
    phone      varchar(20) not null unique,
    email      varchar(50) not null unique,
    city_id    int,
    CONSTRAINT fk_buyers_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)

);

create table property_offers
(
    property_id    int            not null,
    agent_id       int            not null,
    price          decimal(19, 2) not null,
    offer_datetime datetime,

    CONSTRAINT fk_property_offers_properties FOREIGN KEY (property_id)
        REFERENCES properties (id),
    CONSTRAINT fk_property_offers_agents FOREIGN KEY (agent_id)
        REFERENCES agents (id)


);

create table property_transactions
(
    `id`             INT PRIMARY KEY AUTO_INCREMENT,
    property_id      int not null,
    buyer_id         int not null,
    transaction_date date,
    bank_name        varchar(30),
    iban             varchar(40) unique,
    is_successful    tinyint(1),
    CONSTRAINT fk_property_transactions_properties FOREIGN KEY (property_id)
        REFERENCES properties (id),
    CONSTRAINT fk_property_transactions_buyers FOREIGN KEY (buyer_id)
        REFERENCES buyers (id)

);

insert into property_transactions(property_id, buyer_id,
                                  transaction_date, bank_name, iban,
                                  is_successful)
SELECT po.agent_id + day(po.offer_datetime),
       po.agent_id + month(po.offer_datetime),
       DATE(po.offer_datetime),
       concat('Bank', ' ', po.agent_id),
       concat('BG', po.price, po.agent_id),
       true
from property_offers as po
where po.agent_id <= 2;

#3

update properties

set price = price - 50000
where price >= 800000;

# 4
delete pt
from property_transactions as pt
where is_successful = false;


# 5
select *
from agents
order by city_id desc, phone desc;

# 6
select *
from property_offers po
where year(po.offer_datetime) = 2021
order by price asc
limit 10;

#7
select substr(p.address, 1, 6)       as agent_name,
       char_length(p.address) * 5430 as price
from properties p
         left join property_offers po on p.id = po.property_id
where po.agent_id is null
order by agent_name desc, price desc;

# 8
select bank_name, count(distinct iban) as count
#select bank_name, count(*) as count
from property_transactions
group by bank_name
 having count >= 9
order by count
desc , bank_name asc;

# 9

select p.address,p.area,
       (CASE
            WHEN p.area <= 100 THEN 'small'
            WHEN p.area <= 200 THEN 'medium'
            WHEN p.area <= 500 THEN 'large'
            ELSE 'extra large'
           END) AS 'size'
from properties as p
order by area, address desc ;

# 10

DELIMITER $$
create function udf_offers_from_city_name(cityName VARCHAR(50))
    returns int
    deterministic
begin
    declare offers_count int;
    set offers_count :=(
        select COUNT(*) from property_offers as po
                        join properties p on p.id = po.property_id
                        join cities c on c.id = p.city_id
                        where cityName = c.name

    );
    return offers_count;
end $$

select udf_offers_from_city_name('Vienna') as 'offers_count';




create procedure udp_special_offer (first_name VARCHAR(50))

begin
    update
        property_offers po
    join agents a on a.id = po.agent_id
    set po.price = price * 0.9
    where a.first_name = first_name;


end ;

call udp_special_offer('Hans');














