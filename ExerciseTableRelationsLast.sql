# 1. One-To-One Relationship

CREATE TABLE passports (
    passport_id INT PRIMARY KEY AUTO_INCREMENT,
    passport_number VARCHAR(8) UNIQUE
);
insert into passports(passport_id,passport_number)
values(101,'N34FG21B'), (102,'K65LO4R7'), (103,'ZE657QP2');

CREATE TABLE people (
    person_id INT UNIQUE NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10 , 2 ) DEFAULT 0,
    passport_id INT UNIQUE,
    
    foreign key (passport_id)
references passports(passport_id)
); 

insert into people(first_name, salary, passport_id)
values('Roberto', 43300.00, 102), ('Tom', 56100.00, 103), ('Yana', 60200.00, 101);


-- alter table people
-- add constraint pk_people
-- primary key (person_id),
-- add constraint fk_people_passports
-- foreign key (passport_id)
-- references passports(passport_id);




#2. One-To-Many Relationship

CREATE TABLE manufacturers (
    manufacturer_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(50) UNIQUE NOT NULL,
    established_on datetime NOT NULL DEFAULT NOW()
);

CREATE TABLE models (
    model_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(50),
    manufacturer_id INT,
    CONSTRAINT fk_models_manufacturers FOREIGN KEY (manufacturer_id)
        REFERENCES manufacturers (manufacturer_id)
);

alter table models auto_increment = 101;

insert into manufacturers(name, established_on)
values
('BMW', '1916-03-01'),
('Tesla','2003-01-01'),
('Lada','1966-05-01');

insert into models(name,manufacturer_id)
values (
'X1',1),
('i6',1),
('Model S',2),
('Model X',2),
('Model 3',2),
('Nova',3);

# 03. Many-To-Many Relationship
CREATE TABLE exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
)  AUTO_INCREMENT=101;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE students_exams (
   exam_id INT,
    student_id INT,
     
    CONSTRAINT pk_students_exam PRIMARY KEY (exam_id , student_id),
    CONSTRAINT fk_students_exams FOREIGN KEY (exam_id)
        REFERENCES exams (exam_id),
    CONSTRAINT fk_exams_students FOREIGN KEY (student_id)
        REFERENCES students (student_id)
);

insert into students (name)
values('Mila'),('Toni'),('Ron');

insert into exams (name)
values ('Spring MVC'),('Neo4j'),
('Oracle 11g');

insert into students_exams(student_id,exam_id)
values (1,101),(1,102),(2,101),(3,103),(2,102),
(2,103);
# 4 
drop table teachers;
create table teachers (
teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    manager_id int
);
insert into teachers values 
(101,'John',null),
(102,'Maya',106),
(103,'Silvia',106),
(104,'Ted',105),
(105,'Mark',101),
(106,'Greta',101);

alter table teachers add foreign key (manager_id) references teachers(teacher_id);

# 05. Online Store Database
create schema online_store;
use online_store;
drop schema online_store;

create table cities (
city_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
    );
    
    create table customers (
customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    birthday date,
    city_id int,
     CONSTRAINT fk_customers_cities FOREIGN KEY (city_id)
        REFERENCES cities (city_id)
);

create table orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
   customer_id int ,
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

create table item_types (
item_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);
create table items (
item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    item_type_id int,
     CONSTRAINT fk_items_item_types FOREIGN KEY (item_type_id)
        REFERENCES item_types (item_type_id)
    
);

create table order_items (
order_id INT ,
   item_id int,
   primary key (order_id,item_id),
    CONSTRAINT fk_order_items_items FOREIGN KEY (item_id)
        REFERENCES items (item_id),
         CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
);









# 06. University Database

CREATE TABLE subjects (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    subject_name VARCHAR(50) NOT NULL
);
CREATE TABLE majors (
    major_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(12) NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    major_id INT(11),
    CONSTRAINT fk_students_majors FOREIGN KEY (major_id)
        REFERENCES majors (major_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    payment_amount DECIMAL(8 , 2 ),
    student_id INT,
    CONSTRAINT fk_payments_students FOREIGN KEY (student_id)
        REFERENCES students (student_id)
);

CREATE TABLE agenda (
    student_id INT,
    subject_id INT,
    CONSTRAINT pk_agenda PRIMARY KEY (student_id , subject_id),
    CONSTRAINT fk_agenda_students FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT fk_agenda_subjects FOREIGN KEY (subject_id)
        REFERENCES subjects (subject_id)
);


# 09. Peaks in Rila
SELECT 
    m.mountain_range,
    p.peak_name,
    p.elevation as peak_elevation
FROM
    mountains AS m
        JOIN
    peaks AS p ON m.id = p.mountain_id
WHERE
    m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;


