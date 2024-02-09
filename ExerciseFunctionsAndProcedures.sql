# exercise Function and procedure
use soft_uni;
#1

create procedure usp_get_employees_salary_above_35000()

begin
    select first_name, last_name
    from employees
    where salary > 35000
    order by first_name, last_name, employee_id;


end;

call usp_get_employees_salary_above_35000();

select first_name, last_name
from employees
where salary > 35000
order by first_name, last_name, employee_id;


#2

create procedure usp_get_employees_salary_above(target_salary DECIMAL(10, 4))

begin


    select first_name, last_name
    from employees
    where salary >= target_salary
    order by first_name, last_name, employee_id;

end;

call usp_get_employees_salary_above(70000);


# 3

create procedure usp_get_towns_starting_with(symbol VARCHAR(20))

begin


    select name
    from towns
    where name like concat(symbol, '%')
    order by name;


end;
call usp_get_towns_starting_with('b');

#4

create procedure usp_get_employees_from_town(town_name VARCHAR(100))

begin
    select e.first_name, e.last_name
    from employees e
             join addresses a on a.address_id = e.address_id
             join towns t on t.town_id = a.town_id
    where t.name = town_name
    order by e.first_name, e.last_name, e.employee_id;


end;
call usp_get_employees_from_town('Sofia');
#5
DELIMITER $$
create function ufn_get_salary_level(
    salary_level decimal(10, 2))
    returns varchar(20)
    deterministic
begin
    declare result varchar(20);
    if (salary_level < 30000) then
        set result := 'Low';
    elseif (salary_level >= 30000 and salary_level <= 50000) then
        set result := 'Average';
    else
        set result := 'High';
    end if;
    return result;

end $$

select ufn_get_salary_level(50000);

#6

create procedure usp_get_employees_by_salary_level(salary_level varchar(20))

begin
    select e.first_name, e.last_name
    from employees e
    where salary_level = ufn_get_salary_level(salary)
    order by first_name desc, last_name desc;


end;
call usp_get_employees_by_salary_level('High');

# 7
delimiter $$
create function ufn_is_word_comprised(
    set_of_letters varchar(50), word varchar(50))
    returns tinyint
    deterministic
begin

    return word
        regexp
           concat('^[', set_of_letters, ']+$');


end;

select ufn_is_word_comprised('bobr', 'Rob');

# 8
create procedure usp_get_holders_full_name()

begin
    select concat(first_name, ' ', last_name) as full_name
    from account_holders
    order by full_name;

end;

# 9

create procedure usp_get_holders_with_balance_higher_than(
    target_salary decimal(19, 4))

begin
    select ah.first_name, ah.last_name
    from account_holders ah
             join accounts a on ah.id = a.account_holder_id
    group by ah.id
    having sum(a.balance) > target_salary
    order by ah.id;
    #     where target_salary < (select sum(balance)
#                            from accounts
#                            where  accounts.account_holder_id = ah.id
#                            group by accounts.account_holder_id)
#     group by ah.id
#     order by ah.id;

end;

drop procedure usp_get_holders_with_balance_higher_than;

#10

delimiter $$
create function ufn_calculate_future_value(
    initial decimal(10, 4), interest_rate decimal(10, 4), numYears int)
    returns decimal(10, 4)
    reads sql data
begin

    return initial * pow(1 + interest_rate, numYears);


end;

select ufn_calculate_future_value(1000, 0.5, 5);

# 11

create procedure usp_calculate_future_value_for_account(
    acc_id int, interest decimal(10, 4))

begin
    select a.id      as account_id,
           ah.first_name,
           ah.last_name,
           a.balance as current_balance,
           ufn_calculate_future_value(a.balance, interest, 5)
    from account_holders ah
             join accounts a on ah.id = a.account_holder_id
    where a.id = acc_id;


end;

drop procedure usp_calculate_future_value_for_account;
drop function ufn_calculate_future_value;
call usp_calculate_future_value_for_account(1, 0.1);


# 12

create procedure
    usp_deposit_money(acc_id int, money_amount decimal(10, 4))

begin
    start transaction ;
    if ((select count(*) from accounts where id = acc_id) <> 1 or
        money_amount < 0) then
        rollback ;
    else
        update accounts
        set balance = balance + money_amount
        where id = acc_id;
        commit;
    end if;

end;

call usp_deposit_money(1, 10);

# 13
create procedure
    usp_withdraw_money(acc_id int, money_amount decimal(19, 4))

begin
    start transaction ;
    if ((select count(*) from accounts where id = acc_id) <> 1 or
        ((select balance from accounts where id = acc_id) < money_amount) or
        money_amount < 0) then
        rollback ;
    else
        update accounts
        set balance = balance - money_amount
        where id = acc_id;
        commit;
    end if;

end;

drop procedure usp_withdraw_money;

call usp_withdraw_money(1, 10);

#14

create procedure
    usp_transfer_money(
    acc_id int, target_id int, money_amount decimal(19, 4))

begin
    start transaction ;
    if ((select count(*) from accounts where id = acc_id) <> 1 or
        (select count(*) from accounts where id = target_id) <> 1 or
        acc_id = target_id or
        ((select balance from accounts where id = acc_id) < money_amount) or
        money_amount < 0) then
        rollback;
    else
        update accounts
        set balance = balance - money_amount
        where id = acc_id;
        update accounts
        set balance = balance + money_amount
        where id = target_id;
        commit;
    end if;

end;

call usp_transfer_money(2,1,10);


# 15

create table logs(
    log_id int primary key auto_increment
                 , account_id int not null
                 , old_sum decimal(19,4)
                 , new_sum decimal(19,4));
delimiter $$
create trigger tr_update
after update
    on accounts
    for each row
    begin
        insert into  logs(account_id, old_sum, new_sum)
            values (old.id,old.balance,new.balance);

    end $$
delimiter ;
call usp_deposit_money(1,10);
select * from logs;




