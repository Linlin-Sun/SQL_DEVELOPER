
select emp.*, sum(salary) over(order by rowid) sal_accum from hr.employees emp;