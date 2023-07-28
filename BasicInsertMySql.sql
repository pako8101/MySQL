-- towns (id, name)
-- addresses (id, address_text, town_id)
-- departments (id, name)
-- employees (id, first_name, middle_name, last_name, job_title, department_id, hire_date, salary, address_id) 

create table towns (
id int primary key auto_increment,
name varchar(40)
);

create table departemnts (
id int primary key auto_increment,
name varchar(40)
);

create table addresses(
id int primary key auto_increment,
address_text varchar(50) not null,
town_id int,
foreign key (town_id)
references towns(id)
);

 CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    job_title VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DOUBLE,
    address_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments (id),
    FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);


