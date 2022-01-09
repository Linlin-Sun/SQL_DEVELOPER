select * from hr.employees;
select * from hr.employees offset 1 rows;
select * from hr.employees fetch first 1 rows only;
select * from hr.employees offset 1 rows fetch first 1 rows only;
select * from hr.employees offset 1 rows fetch next 1 rows only;
select * from hr.employees fetch first 5 percent rows only;