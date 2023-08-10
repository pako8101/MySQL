# ExamPrepMarkov
# 1
drop database exam_prep_second_edition;
create database exam_prep_second_edition;
use exam_prep_second_edition;
create table brands
(
    id   int primary key auto_increment,
    name varchar(40) not null unique

);
create table categories
(
    id   int primary key auto_increment,
    name varchar(40) not null unique

);
create table reviews
(
    id           int primary key auto_increment,
    content      text,
    rating       decimal(10, 2) not null,
    picture_url  varchar(80)    not null,
    published_at datetime       not null


);
create table products
(
    id                int primary key auto_increment,
    name              varchar(40)    not null,
    price             decimal(19, 2) not null,
    quantity_in_stock int,
    description       text,
    brand_id          int            not null,
    category_id       int            not null,
    review_id         int,
    constraint fk_products_brands
        foreign key (brand_id)
            references brands (id),
    constraint fk_products_categories
        foreign key (category_id)
            references categories (id),
    constraint fk_products_reviews
        foreign key (review_id)
            references reviews (id)
);
create table costumers
(
    id            int primary key auto_increment,
    first_name    varchar(20) not null,
    last_name     varchar(20) not null,
    phone         varchar(30) not null unique,
    address       varchar(60) not null,
    discount_card bit

);
create table orders
(
    id             int primary key auto_increment,
    order_datetime datetime not null,
    customer_id    int      not null,
    constraint fk_orders_costumers
        foreign key (customer_id)
            references costumers (id)

);
create table orders_products
(
    order_id   int,
    product_id int,
    key `pk_orders_products` (`order_id`, `product_id`),
    constraint fk_op_orders
        foreign key (order_id)
            references orders (id),
    constraint fk_op_products
        foreign key (product_id)
            references products (id)

);

# 2 insert
insert into reviews(content, rating, picture_url, published_at)
select left(p.description, 15), p.price / 8, reverse(p.name), date('2010/10/10')
from products as p
where p.id >= 5;

#3 update
update products as p
set p.quantity_in_stock = p.quantity_in_stock - 5
where p.quantity_in_stock between 60 and 70;

# 4 delete
delete c
from costumers as c
         left join orders o on c.id = o.customer_id
where o.customer_id is null;

# 05.	Categories

select *
from categories as c
order by c.name desc;

# 6 Quantity
select p.id, p.brand_id, p.name, p.quantity_in_stock
from products as p

where p.price > 1000
  and p.quantity_in_stock < 30
order by p.quantity_in_stock, p.id;


# 7 Review
select *
from reviews as r
where (select r.content like 'My%' and LENGTH(r.content) > 61)
order by rating desc;

# 8 08.	First customers

select concat_ws(' ', c.first_name, c.last_name) as full_name, c.address, o.order_datetime as order_date
from orders as o
         join costumers c on o.customer_id = c.id
where year(o.order_datetime) <= 2018
order by full_name desc;

# 09. Best categories

select count(c.id)              as items_count,
       c.name,
       sum(p.quantity_in_stock) as total_quantity
from products as p
         join categories as c on p.category_id = c.id
group by c.id
order by items_count desc, total_quantity asc
limit 5;

# 10. Extract client cards count

create function udf_customer_products_count(name VARCHAR(30))
    returns int
    return (select count(c.id)
            from costumers as c
                     join orders as o on c.id = o.customer_id
                     join orders_products op on o.id = op.order_id
            where c.first_name = 'Shirley'
            group by c.id);
delimiter $$
create function udf_customer_products_count2(name VARCHAR(30))
    returns int
begin
    declare count_of_products int;
    set count_of_products :=
            (select count(c.id)
             from costumers as c
                      join orders as o on c.id = o.customer_id
                      join orders_products op on o.id = op.order_id
             where c.first_name = 'Shirley'
             group by c.id);
    return count_of_products;
end $$;
delimiter

# 11	Reduce price
create procedure udp_reduce_price(category_name varchar(50))
begin
update products as p
join reviews r on r.id = p.review_id
join categories c on c.id = p.category_id
set p.price = p.price * 0.7
where  c.name = category_name
and r.rating < 4;
end;


















































