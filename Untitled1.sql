declare
    type test_rec is record(id hr.employees.employee_id%type, name hr.employees.first_name%type);
    test test_rec;
begin
    select employee_id, first_name into test from hr.employees where rownum = 1;
    dbms_output.put_line(test.id || ' ' || test.name);
end;
/