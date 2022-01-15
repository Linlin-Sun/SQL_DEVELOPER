select json_object('ENAME' value first_name) from hr.employees;

select json_objectagg('ENAME' value first_name) from hr.employees;

select djson_array(first_name) from hr.employees;

select json_arrayagg(first_name) from hr.employees;

select json_objectagg(to_char(department_id) value json_arrayagg(first_name)) 
    from hr.employees where department_id is not null group by department_id;

select to_char(department_id) value, json_array(json_object('ENAME' value first_name))
    from hr.employees where department_id is not null;
    
select json_object(to_char(department_id) value json_arrayagg(json_object('ENAME' value first_name)))
    from hr.employees where department_id is not null group by department_id;
    
select json_objectagg(to_char(department_id) value json_arrayagg(json_object('ENAME' value first_name)))
    from hr.employees where department_id is not null group by department_id;