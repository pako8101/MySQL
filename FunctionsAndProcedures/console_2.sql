set global log_bin_trust_function_creators = 1;
set sql_safe_updates = 0;

# 1. Find Names of All Employees by First Name
delimiter $$
create procedure usp_get_employees_salary_above_35000()
begin
    select first_name, last_name
    from employees
    where salary > 35000
    order by first_name, last_name, employee_id;
end $$
delimiter ;


# 02. Employees with Salary Above Number
delimiter  $$
create procedure usp_get_employees_salary_above(salary_limit decimal(19, 4))
begin
    select first_name, last_name
    from employees
    where salary >= salary_limit
    order by first_name, last_name, employee_id;
end $$
delimiter ;

# 03. Town Names Starting With
delimiter  $$
create procedure usp_get_towns_starting_with(name_starts_with varchar(50))
begin
    select name
    from towns
    where name like concat(name_starts_with, '%')
    order by name;
end $$
delimiter ;

call usp_get_towns_starting_with('b');

# 04. Employees from Town
delimiter  $$
create procedure usp_get_employees_from_town(town_name varchar(50))
begin
    select first_name, last_name
    from employees as e
             join addresses as a on a.address_id = e.address_id
             join towns as t on t.town_id = a.town_id
    where t.name = town_name
    order by e.first_name, e.last_name, e.employee_id;
end $$
delimiter ;

call usp_get_employees_from_town('Sofia');

# 05. Salary Level Function
delimiter  $$
create function ufn_get_salary_level(salary decimal(19, 4))
    returns varchar(7)
    return (
        case
            when salary < 30000 then 'low'
            when salary <= 50000 and salary >= 30000 then 'Average'
            else 'High'
            end
        );
delimiter ;

select ufn_get_salary_level(70000);

# 06. Employees by Salary Level
delimiter $$
create procedure usp_get_employees_by_salary_level(salary_level varchar(7))
begin
    select first_name, last_name
    from employees
    where (salary < 30000 and salary_level = 'Low')
       or (salary >= 30000 and salary <= 50000 and salary_level = 'Average')
       or (salary > 50000 and salary_level = 'High')
    order by first_name desc, last_name desc;

end$$
delimiter ;
call usp_get_employees_by_salary_level('High');

# 07. Define Function
delimiter $$
create function ufn_is_word_comprised3(set_of_letters varchar(50), word varchar(50))
    returns int
    return word regexp (concat('^[', set_of_letters, ']+$'));

select ufn_is_word_comprised3('oistmiahf', 'Sofia');

# 8. Find Full Name
delimiter $$
create procedure usp_get_holders_full_name()
begin
    select concat_ws(' ', first_name, last_name) as full_name
    from account_holders
    order by full_name;
end$$
delimiter ;

call usp_get_holders_full_name();

# 9. People with Balance Higher Than
delimiter $$
create procedure usp_get_holders_with_balance_higher_than(money_to_compare decimal(19, 4))
begin
    select ah.first_name, ah.last_name, sum(a.balance)
    from account_holders as ah
             join accounts as a on a.account_holder_id = ah.id
    group by ah.id
    having sum(a.balance) > money_to_compare
    order by ah.id;
end$$
delimiter ;

call usp_get_holders_with_balance_higher_than(8000);

# 10. Future Value Function
create function ufn_calculate_future_value(initial_sum decimal(19, 4),
                                           interest_rate_per_year decimal(19, 4), years int)
    returns decimal(19, 4)
    return initial_sum * pow((1 + interest_rate_per_year), years);

select ufn_calculate_future_value(1000, 0.5, 5);


# 11. Calculating Interest
delimiter $$
create procedure usp_calculate_future_value_for_account(account_id int, interest_per_year decimal(10, 4))
begin
    select ah.id,
           ah.first_name,
           ah.last_name,
           a.balance as current_balance,
           ufn_calculate_future_value(a.balance, interest_per_year, 5)
                     as balance_in_5_years
    from accounts as a
             join account_holders as ah on a.account_holder_id = ah.id
    where a.id = account_id;
end $$
delimiter ;

call usp_calculate_future_value_for_account(1, 0);

# 13. Withdraw Money
delimiter $$
create procedure usp_withdraw_money(account_id int, money_amount decimal(19, 4))
begin
    if money_amount > 0 then
        start transaction ;

        update accounts as a
        set a.balance = a.balance - money_amount
        where account_id = a.id;
        if (select balance from accounts where account_id = id) < 0
        then
            rollback;
        else
            commit ;
        end if;
    end if;
end$$
delimiter  ;

call usp_withdraw_money(1, 100);

# 14. Money Transfer
delimiter  $$
create procedure usp_transfer_money(from_account_id int, to_account_id int, amount decimal(19, 4))
begin
    if amount > 0
        and (select id from accounts where from_account_id = id) is not null
        and (select id from accounts where to_account_id = id) is not null
        and (select balance from accounts where from_account_id = id) >= amount
    then
        start transaction ;
        update accounts
        set balance = balance - amount
        where id = from_account_id;
        update accounts
        set balance = balance + amount
        where id = to_account_id;

    end if;
end$$
delimiter  ;
call usp_transfer_money(1, 202, 83);
select balance
from accounts
where id in (1, 2);


# 15. Log Accounts Trigger
# logs(log_id, account_id, old_sum, new_sum).

create table logs
(
    log_id     int primary key auto_increment not null,
    account_id int                            not null,
    old_sum    decimal(19, 4),
    new_sum    decimal(19, 4)

);
create trigger trigger_balance_update
    after update
    on accounts
    for each row
begin
    if old.balance <> NEW.balance
    then
        insert into logs(account_id, old_sum, new_sum) VALUE (old.id, old.balance, new.balance);
    end if;
end;

# 16. Emails Trigger
# notification_emails(id, recipient, subject, body)
create table notification_emails
(
    id        int primary key auto_increment,
    recipient int          not null,
    subject   varchar(100) not null,
    body      text         not null
);
create trigger trigger_email_creation
    after insert
    on logs
    for each row
begin
    insert into notification_emails(recipient, subject, body) values (new.account_id,
concat('Balance change for account: ', new.account_id),
         concat_ws(' ',
             'On',
             date_format(now(), '%b %d %y at %r'),
                'your balance was changed from',
             NEW.old_sum,
             'to',
             new.new_sum));

        end;

update accounts
set balance = 100
where id = 1;

select  * from notification_emails





















