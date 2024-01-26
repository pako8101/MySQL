create schema SoftUni_Stores_System;
use SoftUni_Stores_System;
drop schema SoftUni_Stores_System;



CREATE TABLE pictures (
    id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(100) NOT NULL,
    added_on DATETIME NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE ,
    price DECIMAL(10 , 2 ) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    picture_id INT NOT NULL,
    CONSTRAINT fk_product_categorie FOREIGN KEY (category_id)
        REFERENCES categories (id),
    CONSTRAINT fk_product_picture FOREIGN KEY (picture_id)
        REFERENCES pictures (id)
);
create table towns (
  id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    town_id INT NOT NULL,
      CONSTRAINT fk_address_town FOREIGN KEY (town_id)
        REFERENCES towns (id)
);
CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    rating FLOAT NOT NULL,
    has_parking TINYINT(1),
    address_id INT NOT NULL,
    CONSTRAINT fk_store_address FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);


CREATE TABLE products_stores (
    product_id INT,
    store_id INT,
    primary key (product_id ,store_id ),
      CONSTRAINT fk_product_store_product FOREIGN KEY (product_id)
        REFERENCES products (id),
           CONSTRAINT fk_product_store_store FOREIGN KEY (store_id)
        REFERENCES stores (id)
);


CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL,
    middle_name CHAR(1) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(19 , 2 ) DEFAULT 0 not null,
    hire_date DATE NOT NULL,
    manager_id INT,
    store_id INT NOT NULL,
      CONSTRAINT fk_employee_store FOREIGN KEY (store_id)
        REFERENCES stores (id),
          CONSTRAINT sr_employee_manager FOREIGN KEY (manager_id)
        REFERENCES employees (id)
);

# 2 
INSERT INTO products_stores (product_id, store_id)
SELECT products.id AS product_id, 1 AS store_id
FROM products
LEFT JOIN products_stores ON products.id = products_stores.product_id
WHERE products_stores.product_id IS NULL;

# 3 
update employees as e
set e.manager_id = 3 , e.salary = e.salary + 500
where
hire_date > '2003-01-01'
and e.store_id not in (
select id from stores
where name in('Cardguard','Veribet')
);

# 4
DELETE FROM employees 
WHERE
    manager_id IS NOT NULL
    AND salary >= 6000;


#  Querying
# 5 
SELECT 
    first_name, middle_name, last_name, salary, hire_date
FROM
    employees
ORDER BY hire_date DESC;

# 6

SELECT 
    p.name AS product_name,
    p.price,
   p.best_before,
    CONCAT( substr(p.description,1,10), '...') AS short_description,
    url
FROM
    products AS p
        JOIN
    pictures AS ps ON p.picture_id = ps.id
WHERE
    p.price > 20
        AND YEAR(ps.added_on) < 2019
        AND LENGTH(p.description > 100)
ORDER BY p.price DESC
;

# 7 

SELECT 
    s.name, COUNT(p.id) AS product_count,round(AVG(p.price),2) AS `avg`
FROM
    stores AS s
        LEFT OUTER JOIN
    products_stores AS ps ON s.id = ps.store_id
        LEFT OUTER JOIN
    products AS p ON ps.product_id = p.id
GROUP BY s.id
ORDER BY product_count DESC , `avg` DESC , s.id;

# 8
SELECT 
    concat(e.first_name,' ',e.last_name) as Full_name,
    s.name as Store_name,
    a.name as address, e.salary
FROM
    employees AS e
        JOIN
    stores AS s ON e.store_id = s.id
        JOIN
    addresses AS a ON s.address_id = a.id
WHERE
    e.salary < 4000 AND a.name LIKE '%5%'
        AND LENGTH(s.name) > 8
        AND e.last_name LIKE '%n';

# 9
SELECT 
    REVERSE(s.name),
    CONCAT(UPPER(t.name), '-', a.name) AS full_address,
    (SELECT 
            COUNT(e.id)
        FROM
            employees e
        WHERE
            e.store_id = s.id) AS employees_count
FROM
    stores AS s
        JOIN
    addresses AS a ON s.address_id = a.id
        JOIN
    towns AS t ON t.id = a.town_id
WHERE
    (SELECT 
            COUNT(e.id)
        FROM
            employees e
        WHERE
            e.store_id = s.id) > 0
ORDER BY full_address;
# 9 var 2
SELECT 
    REVERSE(s.name),
    CONCAT(UPPER(t.name), '-', a.name) AS full_address,
    COUNT(e.id) AS employees_count
FROM
    stores AS s
        JOIN
    addresses AS a ON s.address_id = a.id
        JOIN
    towns AS t ON t.id = a.town_id
        JOIN
    employees AS e ON e.store_id = s.id
GROUP BY s.id
HAVING employees_count > 0
ORDER BY full_address;

# 10
DELIMITER $$
create function udf_top_paid_employee_by_store(store_name VARCHAR(50)) 
returns varchar(100)
begin

return(select concat(e.first_name,' ',e.middle_name,'. ', e.last_name
,'works in store for',2020 - year(hire_date), 'years') from employees as e 
join store as s on e.store_id = s.id
where s.name = store_name
order by e.salari desc limit 1);

END$$

# 11
DELIMITER $$
create procedure  udp_update_product_price (address_name VARCHAR (50))
begin
declare increase_level int;
if address_name like '0%' then set increase_level = 100;
else set increase_level = 100;
end if;
UPDATE products p 
SET 
    p.price = p.price + increase_level
WHERE
    p.id IN (SELECT 
            ps.product_id
        FROM
            addresses a
                JOIN
            stores ON a.id = s.address_id
                JOIN
            products_stores ps ON ps.store_id = s.id
        WHERE
            a.name = address_name);

end$$










