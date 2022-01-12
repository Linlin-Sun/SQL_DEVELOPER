-- As aggregate function (within group) -- returns one row for each group
-- analytic function (over clause) -- returns every row
select * from v$parameter where name like '%max_string_size%';
-- 11g and +
select listagg(first_name) from hr.employees;
select listagg(first_name, ',') from hr.employees;
select listagg(first_name, ',') within group (order by department_id) from hr.employees;
select listagg(first_name, ',') within group (order by first_name) from hr.employees;
select department_id, listagg(first_name, ',') from hr.employees group by department_id order by department_id;
select department_id, listagg(first_name, ',') within group(order by first_name) from hr.employees group by department_id;

select hr.employees.department_id, listagg(first_name, ',') over (partition by department_id)from hr.employees;

-- ORA-01489: result of string concatenation is too long
select listagg(last_name || last_name || last_name || last_name || last_name || last_name || last_name, ',') from hr.employees;

-- on overflow truncate (12.2 or +)
select listagg(last_name || last_name || last_name || last_name || last_name || last_name || last_name, ',' on overflow truncate) from hr.employees;
select listagg(last_name || last_name || last_name || last_name || last_name || last_name || last_name, ',' on overflow truncate with count) from hr.employees;
-- on overflow truncate 'some wording' [with count] -- default (12.2 or +)
select listagg(last_name || last_name || last_name || last_name || last_name || last_name || last_name, ',' on overflow truncate 'some wording') from hr.employees;
select listagg(last_name || last_name || last_name || last_name || last_name || last_name || last_name, ',' on overflow truncate 'some wording' with count) from hr.employees;
-- on overflow truncate 'some wording' without count
select listagg(last_name || last_name || last_name || last_name || last_name || last_name || last_name, ',' on overflow truncate 'some wording' without count) from hr.employees;

-- distinct (19c or +)
select length(listagg(distinct first_name, ',')) from hr.employees;
-- within group is no longer mandatory (19c or +)
