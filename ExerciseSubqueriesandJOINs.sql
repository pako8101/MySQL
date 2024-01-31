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
    e.employee_id, e.first_name, e.last_name, d.name as department_name
FROM
    employees AS e
        JOIN
    departments AS d ON e.department_id = d.department_id
WHERE
    d.name = 'Sales'
ORDER BY e.employee_id DESC
;


# 4
SELECT e.employee_id,
       e.first_name,
       e.salary,
       d.name as department_name
FROM employees AS e
         JOIN
     departments AS d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
limit 5
;

# 5
SELECT e.employee_id,
       e.first_name
FROM employees as e
         left join employees_projects ep on e.employee_id = ep.employee_id
where ep.project_id IS NULL
ORDER BY e.employee_id desc
limit 3;

# 6
select e.first_name
     , e.last_name
     , e.hire_date
     , d.name as dept_name
from employees as e
         join departments d on d.department_id = e.department_id
where date(e.hire_date) > '1999-01-01'
  and d.name in ('Sales', 'Finance')
order by hire_date asc;

# 7
SELECT e.employee_id,
       e.first_name,
       p.name as project_name
FROM employees as e
         join employees_projects ep on e.employee_id = ep.employee_id
         join projects p on p.project_id = ep.project_id
where date(p.start_date) > '2002-08-13'
  and p.end_date is null
order by first_name, project_name
limit 5;

#8

SELECT e.employee_id,
       e.first_name,
       if(year(p.start_date) >= 2005, null, p.name) as project_name
FROM employees as e
         join employees_projects ep on e.employee_id = ep.employee_id
         join projects p on p.project_id = ep.project_id
where e.employee_id = 24
order by p.name;


# 9

SELECT e.employee_id,
       e.first_name,
       e.manager_id,
       m.first_name as manager_name
FROM employees as e
         join employees m on m.employee_id = e.manager_id
where e.manager_id in (3, 7)
order by first_name;

# 10
SELECT e.employee_id,
       concat_ws(' ', e.first_name, e.last_name) as employee_name,
       concat_ws(' ', m.first_name, m.last_name) as manager_name,
       d.name                                   as department_name
FROM employees as e
         join employees m on m.employee_id = e.manager_id
         join departments d on d.department_id = e.department_id
order by employee_id
limit 5;

# 11

select  avg(salary) as avg_salary from  employees
group by department_id
order by avg_salary
limit 1;

# 12
select *
from geography.countries;

select c.country_code
     , m.mountain_range
     , p.peak_name
     , p.elevation
from countries as c
         join mountains_countries mc on c.country_code = mc.country_code
         join mountains m on mc.mountain_id = m.id
         join peaks p on m.id = p.mountain_id
where p.elevation > 2835
  and c.country_code in ('BG')
order by elevation desc;

# 13
select mc.country_code
     , count(*) mountain_range
from mountains_countries as mc
where country_code in ('BG', 'RU', 'US')
group by mc.country_code
order by mountain_range desc;

# 14
select c.country_name, r.river_name
from countries as c
         left join countries_rivers cr on c.country_code = cr.country_code
         left join rivers r on r.id = cr.river_id
where c.continent_code = 'AF'
order by country_name
limit 5;

# 15

select c.continent_code
     , c.currency_code
     , count(*) as currency_usage
from countries as c

group by c.continent_code, c.currency_code
having currency_usage > 1 and currency_usage = (select count(*) as max
                         from countries
                         where continent_code = c.continent_code
                         group by currency_code
                         order by max desc
                         limit 1)
order by c.continent_code;


# 16

select count(*) as country_count
from countries as c
         left join mountains_countries mc on c.country_code = mc.country_code
where mc.mountain_id is null;

# 17
select country_name,
       max(p.elevation) as highest_peak_elevation,
       max(r.length) as longest_river_length
from countries as c

         left join mountains_countries mc on c.country_code = mc.country_code
         left join mountains m on m.id = mc.mountain_id
         left join peaks p on mc.mountain_id = p.mountain_id
         left join countries_rivers cr on c.country_code = cr.country_code
         left join rivers r on r.id = cr.river_id
group by c.country_name
order by highest_peak_elevation desc, longest_river_length desc,
         country_name
limit  5;









