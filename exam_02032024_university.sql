create database exam_02032024_university;
use exam_02032024_university;

create table countries
(
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(40) not null unique

);

create table cities
(
    `id`       INT PRIMARY KEY AUTO_INCREMENT,
    name       varchar(40) not null unique,
    population int         not null unique,
    country_id int         not null,
    CONSTRAINT fk_cities_countries FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

create table universities
(
    `id`            INT PRIMARY KEY AUTO_INCREMENT,
    name            varchar(60)    not null unique,
    address         varchar(80)    not null unique,
    tuition_fee     decimal(19, 2) not null,
    number_of_staff int,
    city_id         int,
    CONSTRAINT fk_universities_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

create table students
(
    `id`         INT PRIMARY KEY AUTO_INCREMENT,
    first_name   varchar(40) not null,
    last_name    varchar(40) not null,
    age          int,
    phone        varchar(20) not null unique,
    email        varchar(255) unique,
    is_graduated tinyint(1)  not null,
    city_id      int,

    CONSTRAINT fk_students_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)


);

create table courses
(
    `id`           INT PRIMARY KEY AUTO_INCREMENT,
    name           varchar(40) not null unique,
    duration_hours decimal(19, 2),
    start_date     date,
    teacher_name   varchar(60) not null,
    description    text,
    university_id  int,

    CONSTRAINT fk_courses_universities FOREIGN KEY (university_id)
        REFERENCES universities (id)
);

create table students_courses
(
    grade      decimal(19, 2) not null,
    student_id int            not null,
    course_id  int            not null,

    CONSTRAINT fk_students_courses_students FOREIGN KEY (student_id)
        REFERENCES students (id),
    CONSTRAINT fk_students_courses_courses FOREIGN KEY (course_id)
        REFERENCES courses (id)

);

# 2
insert into courses (name, duration_hours, start_date,
                     teacher_name, description, university_id)
select concat(c.teacher_name, ' ', 'course'),
       length(c.name) / 10,
       adddate(c.start_date, INTERVAL 5 day),
       reverse(teacher_name),
       concat('Course ', c.teacher_name, reverse(c.description)),
       day(c.start_date)

from courses as c
where c.id <= 5;

# 3

update universities
set tuition_fee = tuition_fee + 300
where id >= 5
  and id <= 12;


# 4
delete u
from universities u
where number_of_staff is null;

#5

select id, name, population, country_id
from cities
order by population desc;

#6

select first_name, last_name, age, phone, email
from students
where age >= 21
order by first_name desc, email asc, id
limit 10;

# 7

select concat(first_name, ' ', last_name)
                      as full_name,
       substr(email, 2, 10),
       reverse(phone) as password
from students
         left join students_courses sc on students.id = sc.student_id
where sc.course_id is null
order by password desc;


# 8
select count(*) as students_count, u.name as university_name
from universities as u
         join courses c on u.id = c.university_id
         join students_courses sc on c.id = sc.course_id
group by university_name
having students_count >= 8
order by students_count desc, university_name desc;

# 9

select u.name   as university_name,
       c.name   as city_name,
       u.address,
       (CASE
            WHEN u.tuition_fee < 800 THEN 'cheap'
            WHEN u.tuition_fee < 1200 THEN 'normal'
            WHEN u.tuition_fee < 2500 THEN 'high'
            ELSE 'expensive'
           END) AS price_rank,
       u.tuition_fee
from universities as u
         join cities c on c.id = u.city_id
order by tuition_fee;

# 10
DELIMITER $$
create function udf_average_alumni_grade_by_course_name(
    course_name VARCHAR(60))
    returns decimal(10, 2)
    deterministic
begin
    declare average_alumni_grade decimal(10, 2);
    set average_alumni_grade := (select avg(sc.grade)
                                 from courses as c
                                          join students_courses sc on c.id = sc.course_id
                                          join students s on s.id = sc.student_id
                                 where c.name = course_name
                                   and s.is_graduated = true
                                 group by c.id);
    return average_alumni_grade;
end $$


select udf_average_alumni_grade_by_course_name('Quantum Physics');


# 11
create procedure udp_graduate_all_students_by_year(year_started int)

begin
    update
        students s
            join students_courses sc on s.id = sc.student_id
            join courses c on c.id = sc.course_id
    set s.is_graduated = true
    where year(c.start_date) = year_started;


end;

call udp_graduate_all_students_by_year(2017)






















