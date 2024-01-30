use soft_uni;

select * from soft_uni.employees;

#1
SELECT 
    e.employee_id, e.job_title, a.address_id, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

# 2

SELECT 
    e.first_name, e.last_name, t.name, a.address_text
FROM
    employees AS e
        JOIN
    addresses AS a ON e.address_id = a.address_id
        JOIN
    towns AS t ON t.town_id = a.town_id
ORDER BY e.first_name , e.last_name
LIMIT 5;

# 3
SELECT 
    e.employee_id, e.first_name, e.last_name, d.department_id
FROM
    employees AS e
        JOIN
    departments AS d ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;


