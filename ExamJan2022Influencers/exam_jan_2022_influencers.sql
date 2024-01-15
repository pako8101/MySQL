drop schema instd;
create schema instd;
use  instd;
set sql_safe_updates = 0;

create table users (
id int primary key auto_increment, 
username varchar(30) not null, 
password varchar(30) not null, 
email varchar(50) not null,
 gender char not null, 
 age int not null, 
 job_title varchar(40) not null, 
ip varchar(30) not null

);

create table addresses (
id int auto_increment primary key, 
address varchar(50), 
town varchar(30) not null, 
country varchar(30) not null,
 user_id int not null,
  CONSTRAINT fk_addresses_users FOREIGN KEY (user_id)
        REFERENCES users (id)
);

create table photos (
id int auto_increment primary key,  
description text not null, 
date datetime not null,
views int not null default 0
);


create table comments (
id int auto_increment primary key,  
comment varchar(255) not null, 
date datetime not null,
photo_id int not null,
 CONSTRAINT fk_comments_photos FOREIGN KEY (photo_id)
        REFERENCES photos (id)
);


CREATE TABLE users_photos (
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    CONSTRAINT fk_users_photos FOREIGN KEY (user_id)
        REFERENCES users (id),
    CONSTRAINT fk_photos_users FOREIGN KEY (photo_id)
        REFERENCES photos (id)
);

CREATE TABLE likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    photo_id INT NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_likes_photos FOREIGN KEY (photo_id)
        REFERENCES photos (id),
    CONSTRAINT fk_likes_users FOREIGN KEY (user_id)
        REFERENCES users (id)
);

# 2 insert

insert into addresses (address,town,country,user_id)
(select 
u.username ,
u.password ,
u.ip ,
u.age
from users as u
where u.gender = 'M');

#update
UPDATE addresses AS a 
SET 
    country = (CASE
        WHEN country LIKE 'B%' THEN 'Blocked'
        WHEN country LIKE 'T%' THEN 'Test'
        WHEN country LIKE 'P%' THEN 'In progress'
        ELSE country
    END);

#delete

delete from addresses as a
where a.id % 3 = 0;

#Querying
# Users

SELECT 
    username, gender, age
FROM
    users AS u
ORDER BY age DESC , username
;

# 06. Extract 5 Most Commented Photos

SELECT 
    p.id,
    p.date AS date_and_time,
    p.description,
    COUNT(c.id) AS commentsCount
FROM
    photos AS p
        JOIN
    comments AS c ON p.id = c.photo_id
GROUP BY p.id

ORDER BY commentsCount DESC , p.id ASC
limit 5;

# 07. Lucky Users
SELECT 
    CONCAT_WS(' ', u.id, u.username) AS id_username, u.email
FROM
    users AS u
        JOIN
    users_photos AS up ON u.id = up.user_id AND u.id = up.photo_id
ORDER BY u.id;

# 08. Count Likes and Comments

SELECT 
    p.id AS photo_id,
    COUNT(l.id) AS likes_count,
    COUNT(c.id) AS comments_count
FROM
    photos AS p
        JOIN
    users_photos AS up ON p.id = up.photo_id
        JOIN
    likes AS l ON up.photo_id = l.photo_id
        JOIN
    comments AS c ON l.photo_id = c.id
ORDER BY likes_count DESC , comments_count DESC , photo_id;

# 09. The Photo on the Tenth Day of the Month














