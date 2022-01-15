-- As aggregate function (within group) -- returns one row for each group
-- analytic function (over clause) -- returns for every raw data row

--row_number() over([query_partition_clause], order_by_clause)
--rank() over([query_partition_clause], order_by_clause)
--dense_rank() over([query_partition_clause], order_by_clause)
--percent_rank() over([query_partition_clause], order_by_clause)
--ntile(expression) over([query_partition_clause], order_by_clause)
--lead(expression, [, offset][, default]) over ([query_partition_clause, ] order_by_clause)
--lag(expression, [, offset][, default]) over ([query_partition_clause, ] order_by_clause)
--nth_value() (expression, N)  FROM { FIRST | LAST } ] { RESPECT | IGNORE } NULLS ] OVER ([ query_partition_clause ] order_by_clause [frame_clause])

select * from hr.employees order by salary, commission_pct;
-- rank() -- Olympic medal ranking
-- dense_rank() -- NO GAP RANKING
-- row_number() -- NO TIES
-- percent_rank()
-- As aggregate function
select rank(10000, 0.25) within group (order by salary, commission_pct) from hr.employees;
select rank(3000) within group (order by salary) from hr.employees;
select dense_rank(3000) within group (order by salary) from hr.employees;
select percent_rank(3000) within group (order by salary) from hr.employees;
-- As analytic functions
select hr.employees.*, rank() over(partition by department_id order by salary, commission_pct) ranking from hr.employees;
select hr.employees.*, dense_rank() over(partition by department_id order by salary, commission_pct) ranking from hr.employees;
select hr.employees.*, row_number() over(partition by department_id order by salary, commission_pct) ranking from hr.employees;
select hr.employees.*, percent_rank() over(order by salary desc), dense_rank() over(order by commission_pct) from hr.employees;

-- ntile(n) -- Split data into n buckets. ntile() is order sensitive so over(order by) is required. Does NOT support windowing clause
select emp.*, ntile(4) over (order by salary desc) from hr.employees emp;
select emp.*, ntile(4) over (partition by department_id order by salary desc) from hr.employees emp;

-- first_value(), last_value()
select emp.*, first_value(salary) over() from hr.employees emp;
select emp.*, first_value(salary) over(order by salary) from hr.employees emp;
select emp.*, first_value(salary) over(partition by department_id order by salary) dept_lowest_sal from hr.employees emp;
select emp.*, first_value(salary) over(partition by department_id order by salary) dept_lowest_sal, 
    salary - first_value(salary) over(partition by department_id order by salary) diff_from_low from hr.employees emp;
select emp.*, last_value(salary) over(order by salary  rows between unbounded preceding and unbounded following) highest_sal from hr.employees emp;
-- Show the lowest and highest salary in the department
select emp.*, first_value(salary) over(partition by department_id order by salary) dept_lowest_sal,
    first_value(salary) over(partition by department_id order by salary desc) dept_highest_sal from hr.employees emp;
-- Show the lowest and highest salary in the department using first_value() and last_value(). 
-- Performance is better than using first_value() asc and desc
select emp.*, first_value(salary) over(partition by department_id order by salary) dept_lowest_sal,
    last_value(salary) over(partition by department_id order by salary rows between unbounded preceding and unbounded following) dept_highest_sal 
    from hr.employees emp;

-- nth_value()
-- display the 3rd lowest salary along with the raw data
select emp.*, nth_value(salary, 4) from first over (order by salary) nth_low_sal from hr.employees emp;
select emp.*, nth_value(salary, 4) from first over (order by salary rows between unbounded preceding and current row) nth_low_sal from hr.employees emp;
select emp.*, nth_value(salary, 4) from first over (order by salary rows between unbounded preceding and unbounded following) nth_low_sal from hr.employees emp;
select emp.*, nth_value(salary, 4) from first over (order by salary rows between unbounded preceding and unbounded following) nth_low_sal,
    salary - nth_value(salary, 4) from first over (order by salary rows between unbounded preceding and unbounded following) diff_from_nth from hr.employees emp;
select emp.*, nth_value(salary, 4) from last over (order by salary) nth_high_sal from hr.employees emp;
select emp.*, nth_value(salary, 4) from last over (order by salary rows between unbounded preceding and unbounded following) nth_high_sal from hr.employees emp;
select emp.*, nth_value(salary, 4) from last over (order by salary rows between unbounded preceding and unbounded following) nth_high_sal,
    salary - nth_value(salary, 4) from last over (order by salary rows between unbounded preceding and unbounded following) diff_from_nth from hr.employees emp;

-- nth_value(), first_value(), last_value()
select emp.*, first_value(salary) over(order by salary) lowest_1, nth_value(salary, 1) over(order by salary) lowest_2 from hr.employees emp;
select emp.*, first_value(salary) over(order by salary) lowest_1, nth_value(salary, 1) from first over(order by salary) lowest_2 from hr.employees emp;
select emp.*, last_value(salary) over(order by salary rows between unbounded preceding and unbounded following) highest_1, 
    nth_value(salary, 1) over(order by salary desc) highest_2 from hr.employees emp;

-- lag(), lead() -- allow access to a column value from previous/following row
select emp.*, lag(salary) over(order by salary ) from hr.employees emp;
select emp.*, lag(salary, 1) over(order by salary ) from hr.employees emp;
select emp.*, lag(salary, 1, 0) over(order by salary ) from hr.employees emp;
select emp.*, lag(salary, 1, 0) over(partition by department_id order by salary ) from hr.employees emp;

-- corr(), corr_s(), corr_k()
select corr(sysdate - hire_date, salary) from hr.employees emp;
select corr(sysdate - hire_date, salary) as corr_val, corr_s(sysdate - hire_date, salary) as corr_s_val, 
    corr_k(sysdate - hire_date, salary) as corr_k_val from hr.employees emp;
select emp.*, corr(sysdate - hire_date, salary) over(partition by department_id) as corr_val from hr.employees emp;
select emp.*, corr(sysdate - hire_date, salary) over(partition by job_id) as corr_val from hr.employees emp;

-- min(), max(), avg(), median()
select min(salary), max(salary), avg(salary), median(salary) from hr.employees;
select department_id, min(salary), max(salary), avg(salary), median(salary) from hr.employees group by department_id;
select emp.*, min(salary) over(), max(salary) over(), avg(salary) over(), median(salary) over() from hr.employees emp;
select emp.*, min(salary) over(partition by department_id) min_sal, max(salary) over(partition by department_id) max_sal, 
    avg(salary) over(partition by department_id) avg_sal, median(salary) over(partition by department_id) median_sal from hr.employees emp;

-- Oracle 21c window clause
select emp.*, first_value(salary) over w1 dept_lowest, first_value(salary) over w2 dept_highest from hr.employees emp
    window w1 as (partition by department_id order by salary), w2 as (partition by department_id order by salary desc);
select emp.*, first_value(salary) over w1 dept_lowest, first_value(salary) over w2 dept_highest from hr.employees emp
    window w1 as (partition by department_id order by salary), w2 as (partition by department_id order by salary desc);
select emp.*, avg(salary) over w1 avg_rolling, avg(salary) over (w1 rows between unbounded preceding and unbounded following) avg_all 
    from hr.employees emp window w1 as (order by salary);

-- Oracle 21c group clause
drop table t1;
create table t1 (id int, value int);
insert into t1 values (1, 1);
insert into t1 values (2, 2);
insert into t1 values (3, 3);
insert into t1 values (4, 3);
insert into t1 values (5, 4);
insert into t1 values (6, 6);
insert into t1 values (7, 6);
insert into t1 values (8, 7);
insert into t1 values (0, 7);
insert into t1 values (10, 8);
commit;
select row_number() over(order by value) as row_order, value, avg(value) over w1 avg_rows, avg(value) over w2 avg_groups, avg(value) over w3 avg_range from t1
    window w1 as (order by value rows between 1 preceding and current row), 
           w2 as (order by value groups between 1 preceding and current row), 
           w3 as (order by value range between 1 preceding and current row);

-- Oracle 21c exclude clause
select row_number() over w1 as row_order, value, 
    avg(value) over (w1 rows between 1 preceding and 1 following exclude current row) as ex_current_row, 
    avg(value) over (w1 rows between 1 preceding and 1 following exclude group) as ex_group,
    avg(value) over (w1 range between unbounded preceding and current row exclude ties) as ex_ties,
    avg(value) over (w1 range between unbounded preceding and current row exclude no others) as ex_no_others
    from t1 window w1 as (order by value);

-- first --> keep first, last --> keep last
-- first --> lowest --> order list, last --> highest --> order list
-- use with dense_rank()
-- syntax: aggregatefunctionanme() keep (dense_rank first/last order by colname) over(partition by colname)
    -- aggregatefunctionname: min, max, avg, sum -- function name does NOT really matter
select emp.*, min(salary) keep (dense_rank first order by salary) over (partition by department_id) lowest,
    sum(salary) keep (dense_rank last order by salary) over (partition by department_id) highest from hr.employees emp;
select min(first_name) keep (dense_rank first order by salary) min_fname, min(salary), 
    max(first_name) keep (dense_rank last order by salary) max_fname, max(salary) from hr.employees emp;

