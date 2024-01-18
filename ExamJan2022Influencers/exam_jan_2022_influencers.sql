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
    COUNT(DISTINCT l.id) AS 'count_of_likes',
    COUNT(DISTINCT c.id) AS 'count_of_comments'
FROM
    photos AS p
        LEFT JOIN
    likes AS l ON p.id = l.photo_id
        LEFT JOIN
    comments AS c ON p.id = c.photo_id
GROUP BY p.id
ORDER BY count_of_likes DESC , count_of_comments DESC , p.id;

# 09. The Photo on the Tenth Day of the Month

SELECT 
#concat(left(p.description,30))
    CONCAT(SUBSTRING(p.description, 1, 30),'...') AS summary, date
FROM
    photos AS p
WHERE
    DAY(date) = 10
ORDER BY date DESC;

# 10. Get user’s photos count
DELIMITER $$
create function udf_users_photos_count(username VARCHAR(30))
returns int
deterministic
begin
DECLARE photosCount INT;
set photosCount:=(
SELECT 
    COUNT(p.id)
FROM
    photos AS p
        RIGHT JOIN
    users_photos AS up ON p.id = up.user_id
GROUP BY up.user_id);

RETURN photosCount;
END$$

create procedure udp_modify_user






