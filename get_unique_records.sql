select unique first_name from hr.employees;
select distinct first_name from hr.employees;
select first_name from hr.employees group by first_name;
select first_name from hr.employees union select first_name from hr.employees;
select first_name from hr.employees union select null from dual where 1=2;
select first_name from hr.employees intersect select first_name from hr.employees;
select first_name from hr.employees minus select null from dual where 1=2;
select first_name from hr.employees except select null from dual where 1=2;
select first_name from hr.employees where rowid in (select min(rowid) from hr.employees group by first_name);
select first_name from hr.employees A where 1 = (select count(1) from hr.employees B where A.first_name = B.first_name and A.rowid <= B.rowid);
select first_name from (select first_name, row_number() over(partition by first_name order by first_name) rn from hr.employees) where rn = 1;
select first_name from (select first_name, rank() over(partition by first_name order by rownum) rn from hr.employees) where rn = 1;

