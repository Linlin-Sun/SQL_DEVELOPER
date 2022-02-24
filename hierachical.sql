-- connect by, start with, order siblings by
-- Pseudo columns: level, connect_by_isleaf, connect_by_

select * from hr.employees;
select level, connect_by_isleaf, connect_by_iscycle from dual connect by nocycle level < 3;
select first_name, employee_id, manager_id, connect_by_isleaf,  connect_by_iscycle, level, 
    lpad(' ', 2*level-1) || sys_connect_by_path(first_name, ',') from hr.employees 
--    start with first_name = 'Neena' 
    connect by nocycle prior employee_id = manager_id;
select first_name, employee_id, manager_id, level, 
--    lpad(' ', 2*level-1) || 
    sys_connect_by_path(first_name, ',') from hr.employees 
--    start with manager_id is null 
--    connect by prior employee_id = manager_id;
--    connect by manager_id = prior employee_id;
    connect by prior manager_id = employee_id;
--------------------------------------------------------------------------------
drop table employees;
create table employees as select * from hr.employees;
update employees set manager_id = 145 where employee_id = 100;
select emp.*, connect_by_isleaf, connect_by_iscycle from employees emp
--where level <- 3 and department_id = 80
start with last_name = 'King'
connect by nocycle prior employee_id = manager_id;
    
    
    
    
    
    
    
    
    
    
    
    
    
    