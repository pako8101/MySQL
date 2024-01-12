drop schema fsd_exam_sept2022;
create schema fsd_exam_sept2022;
use fsd_exam_sept2022;

#table design
CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL
);

CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    country_id INT NOT NULL,
    CONSTRAINT fk_towns_countries FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE stadiums (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    capacity INT NOT NULL,
    town_id INT NOT NULL,
    CONSTRAINT fk_stadiums_towns FOREIGN KEY (town_id)
        REFERENCES towns (id)
);

CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base BIGINT(20) NOT NULL,
    stadium_id INT NOT NULL,
    CONSTRAINT fk_teams_stadiums FOREIGN KEY (stadium_id)
        REFERENCES stadiums (id)
);

create table skills_data (
id int auto_increment primary key ,
dribbling int default(0),
pace int default(0),
passing int default(0),
shooting int default(0),
speed int default(0),
strength int default(0)
);

create table coaches (
id int primary key auto_increment,
first_name varchar(10) not null,
last_name varchar(20) not null,
salary decimal(10,2) not null default(0),
coach_level int not null default(0)
);

create table players (
id int primary key auto_increment,
first_name varchar(10) not null,
last_name varchar(20) not null,
age int not null  default(0),
position char(1) not null,
salary decimal(10,2) not null default(0),
hire_date datetime,
skills_data_id int not null,
team_id int,
constraint fk_players_skills_data
foreign key (skills_data_id)
references skills_data(id),
constraint fk_players_teams
foreign key (team_id)
references teams(id)
);

create table players_coaches(
player_id int,
coach_id int,
constraint fk_players_coaches_players
foreign key (player_id)
references players(id),
constraint fk_players_coaches_coaches
foreign key (coach_id)
references coaches(id)
);

# insert
insert into coaches 
(first_name,
    last_name,
    salary,coach_level)
(
SELECT 
    p.first_name,
    p.last_name,
    p.salary,
    char_length(p.first_name) AS coach_level
FROM
    players AS p
WHERE
    p.age >= 45);

#update 
UPDATE coaches AS c 
SET 
    c.coach_level = c.coach_level + 1
WHERE
    c.id IN (SELECT 
            coach_id
        FROM
            players_coaches)
        AND first_name LIKE 'A%';

set SQL_SAFE_UPDATES = 0;

#DELETE
delete from players
where 
age >= 45; 

#Querying 
#players
select first_name,age,salary from
players 
 order by salary desc ;

#Young offense players without contract

SELECT 
    p.id,concat_ws(' ',p.first_name,p.last_name) as full_name, p.age, p.position, p.hire_date
FROM
    players AS p
        JOIN
    skills_data AS sd ON p.skills_data_id = sd.id
WHERE
    p.age < 23 AND sd.strength > 50
        AND p.hire_date IS NULL
        AND p.position = 'A'
ORDER BY p.salary , p.age;

# Detail info for all team

SELECT 
    t.name AS team_name,
    t.established,
    t.fan_base,
    COUNT(p.id) AS players_count
FROM
    teams AS t
        LEFT JOIN
    players AS p ON t.id = p.team_id
GROUP BY t.id
ORDER BY players_count DESC , t.fan_base DESC;

# The fastest player by towns
SELECT 
    MAX(sd.speed) AS max_speed, tw.name
FROM
    skills_data AS sd
        RIGHT JOIN
    players AS p ON sd.id = p.skills_data_id
        RIGHT JOIN
    teams AS t ON t.id = p.team_id
        JOIN
    stadiums AS s ON s.id = t.stadium_id
        RIGHT JOIN
    towns AS tw ON tw.id = s.town_id
WHERE
    t.name != 'Devify'
GROUP BY tw.id
ORDER BY max_speed DESC , tw.name;

#Total salaries and players by country

SELECT 
    c.name,
    COUNT(p.id) AS total_count_of_players,
    SUM(p.salary) AS total_sum_of_salaries
FROM
    countries AS c
        LEFT JOIN
    towns AS tw ON c.id = tw.country_id
        LEFT JOIN
    stadiums AS s ON s.town_id = tw.id
        LEFT JOIN
    teams AS t ON t.stadium_id = s.id
        LEFT JOIN
    players AS p ON p.team_id = t.id
GROUP BY c.id
ORDER BY total_count_of_players DESC , c.name ASC;
    
# Find all players that play on stadium
DELIMITER $$
create function udf_stadium_players_count (stadium_name VARCHAR(30)) 
returns int
deterministic
begin
declare stadium_players_count int;
set stadium_players_count := (
select count(p.id) from players as p 
right join teams as t on t.id = p.team_id
right join stadiums as s on s.id = t.stadium_id
where s.name = stadium_name
group by s.id
);
return stadium_players_count;
end$$

SELECT udf_stadium_players_count ('Linklinks') as `count`;

#  Find good playmaker by teams
DELIMITER $$
CREATE PROCEDURE udp_find_playmaker(min_dribble_points int,team_name VARCHAR(45))
begin 
SELECT 
    CONCAT_WS(' ', p.first_name, p.last_name) AS full_name,
    p.age,
    p.salary,
    sd.dribbling,
    sd.speed,
    t.name as  'team_name'
FROM
    players AS p
        JOIN
    skills_data AS sd ON p.skills_data_id = sd.id
        JOIN
    teams AS t ON p.team_id = t.id
WHERE
    sd.dribbling > min_dribble_points AND t.name = team_name
        AND sd.speed > (SELECT 
            AVG(speed)
        FROM
            skills_data)
ORDER BY sd.speed DESC
LIMIT 1;


end$$

call udp_find_playmaker(20, 'Skyble');





