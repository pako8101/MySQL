use soft_uni;
select * from soft_uni.towns;

# 1 
select first_name,last_name from employees
  where first_name like 'Sa%'
  order by employee_id;

# 2 
SELECT 
    first_name, last_name
FROM
    employees
WHERE
    last_name LIKE '%ei%'
    order by employee_id;

# 3
SELECT 
    first_name
FROM
    employees
WHERE
    (department_id = 3
        OR department_id = 10)
        AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;

# 4 
select first_name,last_name from employees
where job_title not like "%engineer%"
order by employee_id;

# 5
SELECT 
    name
FROM
    towns
WHERE
    (char_length(name) = 5 OR char_length(name) = 6)
ORDER BY name ASC;

# 6

SELECT town_id,
    name
FROM
    towns
WHERE
   -- ( name LIKE '%M' OR name LIKE '%K'
--         OR name LIKE '%B'
--         OR name LIKE '%E')
left(name,1) in ('M','K','B','E')
ORDER BY name ASC;

#7

SELECT town_id,
    name
FROM
    towns
WHERE
   -- ( name LIKE '%M' OR name LIKE '%K'
--         OR name LIKE '%B'
--         OR name LIKE '%E')
left(name,1) not in ('R','B','D')
ORDER BY name ASC;


# 8
CREATE VIEW v_employees_hired_after_2000 AS
    SELECT 
        first_name, last_name
    FROM
        employees
    WHERE
        year(hire_date) > 2000;

# 9

SELECT 
    first_name, last_name
FROM
    employees
WHERE
    CHAR_LENGTH(last_name) = 5
;
use geography;
# 10
SELECT 
    country_name, iso_code
FROM
    countries
WHERE
country_name like '%A%A%A%'
   #LENGTH(country_name) - LENGTH(REPLACE(upper(country_name), 'A', '')) >= 3
ORDER BY iso_code;

# 11
select * from peaks,rivers;

SELECT 
    peak_name,
    river_name,
    CONCAT(LOWER(peak_name),
            SUBSTRING(lower(river_name), 2)) AS 'mix'
FROM
    peaks,
    rivers
WHERE
    RIGHT(peak_name, 1) = LEFT(river_name, 1)
    #SUBSTRING(peak_name, - 1) = SUBSTRING(river_name, 1,1)
ORDER BY mix;
-- 12 
use diablo;
SELECT 
    name, DATE_FORMAT(start, '%Y-%m-%d') AS start
FROM
    games
WHERE
    YEAR(start) IN (2011 , 2012)
ORDER BY start
LIMIT 50;
    -- 13
    SELECT 
    user_name,
    SUBSTRING(email, locate('@', email)+1) AS 'email provider'
FROM
    users
ORDER BY 'email provider' , user_name;
    
     SELECT 
    user_name,
    REGEXP_REPLACE(email, '.*@', '') AS 'email provider'
FROM
    users
ORDER BY `email provider` asc , user_name;
    
    -- 14
    SELECT 
    user_name, ip_address
FROM
    users
WHERE
    ip_address LIKE '___.1%.%.___'
ORDER BY user_name;
    -- 15
    SELECT 
    name AS games,
    CASE
        WHEN HOUR(start) BETWEEN 0 AND 11 THEN 'Morning'
        WHEN HOUR(start) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS 'Part of the Day',
    CASE
        WHEN duration <= 3 THEN 'Extra Short'
        WHEN duration BETWEEN 4 AND 6 THEN 'Short'
        WHEN duration BETWEEN 7 AND 10 THEN 'Long'
        ELSE 'Extra Long'
    END AS 'Duration'
FROM
    games
ORDER BY name;
    

     -- 16 

SELECT 
    product_name,
    order_date,
    DATE_ADD(order_date, INTERVAL 3 DAY) AS pay_due,
    DATE_ADD(order_date, INTERVAL 1 MONTH) AS deliver_due
FROM
    orders;












