create database minions;
use minions;

CREATE TABLE minions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(47),
    age INT
);



create table towns(
town_id int primary key auto_increment,
name varchar(47)
);


alter table minions 
add column town_id int;

alter table minions
add constraint fk_minions_towns
foreign key minions(town_id)
references towns(id);

use minions;

INSERT INTO towns (id, name) 
values (1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna') ;

insert into minions (name, age, town_id)
values ('Kevin', 22, 1),
 ('Bob', 15, 3),
 ('Steward', null, 2);


select * from  minions;

truncate table minions;


drop table minions;
drop table towns;


CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    heigth DOUBLE(10 , 2 ),
    weigth DOUBLE(10 , 2 ),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);

INSERT INTO people(name, gender, birthdate)
VALUES
('test','m', DATE(NOW())),
('testche','f', DATE(NOW())),
('test','m', DATE(NOW())),
('testche','f', DATE(NOW())),
('test','m', DATE(NOW()));

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time DATETIME,
    is_deleted BOOLEAN
);

insert into users(username, password)
values('test','test'),
('test','test'),
('test','test'),
('test','test'),
('test','test');

ALTER TABLE users
DROP PRIMARY KEY,
add constraint pk_users2
PRIMARY KEY users(id,username);

ALTER TABLE users









