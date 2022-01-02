-------------------- TYPE, %rowtype
set serveroutput on
-- define record using type
declare
    type emp_rec is record (emp_id hr.employees.employee_id%type, fname hr.employees.first_name%type);
    emp emp_rec;
begin
    select employee_id, first_name into emp from hr.employees where department_id = 20 and rownum = 1;
    dbms_output.put_line('emp.emp_id = ' || emp.emp_id);
    dbms_output.put_line('emp.fname = ' || emp.fname);
end;
/

-- define record with %rowtype
declare
    emp hr.employees%rowtype;
begin
    select * into emp from hr.employees where department_id = 20 and rownum = 1;
    dbms_output.put_line('emp.employee_id = ' || emp.employee_id);
    dbms_output.put_line('emp.first_name = ' || emp.first_name);
end;
/
