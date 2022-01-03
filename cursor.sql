-- dictionary tables for cursor
--select * from v$open_cursor;
--select * from v$parameter where name like '%open_cursors%';

-- implicit cursor and cursor attributes
declare
    emp_row hr.employees%rowtype;
begin
    dbms_output.put_line('Before query -- SQL%rowcount: ' || SQL%rowcount);
    dbms_output.put_line('Before query -- SQL%isopen: ' || utils.get_boolean_str(SQL%isopen)); 
    dbms_output.put_line('Before query -- SQL%found: ' || utils.get_boolean_str(SQL%found)); 
    dbms_output.put_line('Before query -- SQL%notfound: ' || utils.get_boolean_str(SQL%notfound)); 
    select * into emp_row from hr.employees where rownum = 1;
    dbms_output.put_line('After query -- SQL%rowcount: ' || SQL%rowcount); 
    dbms_output.put_line('After query -- SQL%isopen: ' || utils.get_boolean_str(SQL%isopen)); 
    dbms_output.put_line('After query -- SQL%found: ' || utils.get_boolean_str(SQL%found)); 
    dbms_output.put_line('After query -- SQL%notfound: ' || utils.get_boolean_str(SQL%notfound)); 
end;
/

-- explicit cursor and cursor attributes
declare
    cursor csr_emp is select * from hr.employees where department_id = 20;
    emp_row csr_emp%rowtype;
begin
--    dbms_output.put_line('Before open -- csr_emp%rowcount: ' || csr_emp%rowcount); -- ORA-01001: invalid cursor
--    dbms_output.put_line('Before open -- csr_emp%isopen: ' || utils.get_boolean_str(csr_emp%isopen)); -- false
--    dbms_output.put_line('Before open -- csr_emp%found: ' || utils.get_boolean_str(csr_emp%found)); -- ORA-01001: invalid cursor
--    dbms_output.put_line('Before open -- csr_emp%notfound: ' || utils.get_boolean_str(csr_emp%notfound));
    open csr_emp;
    loop
        fetch csr_emp into emp_row;
        exit when csr_emp%notfound;
    end loop;
--    dbms_output.put_line('Before close -- csr_emp%rowcount: ' || csr_emp%rowcount); -- 2
--    dbms_output.put_line('Before close -- csr_emp%isopen: ' || utils.get_boolean_str(csr_emp%isopen));
--    dbms_output.put_line('Before close -- csr_emp%found: ' || utils.get_boolean_str(csr_emp%found));
--    dbms_output.put_line('Before close -- csr_emp%notfound: ' || utils.get_boolean_str(csr_emp%notfound));
    close csr_emp;
--    dbms_output.put_line('After close -- csr_emp%rowcount: ' || csr_emp%rowcount); -- ORA-01001: invalid cursor
--    dbms_output.put_line('After close -- csr_emp%isopen: ' || utils.get_boolean_str(csr_emp%isopen));
--    dbms_output.put_line('After close -- csr_emp%found: ' || utils.get_boolean_str(csr_emp%found));
--    dbms_output.put_line('After close -- csr_emp%notfound: ' || utils.get_boolean_str(csr_emp%notfound));
end;
/

-- Parameterized cursor
declare
    cursor csr_emp(dept_no number) is select first_name from hr.employees where department_id = dept_no;
    fname hr.employees.first_name%type;
begin
    dbms_output.put_line('Department 10');
    open csr_emp(10);
    loop
        fetch csr_emp into fname;
        exit when csr_emp%notfound;
        dbms_output.put_line(chr(9) || fname);
    end loop;
    close csr_emp;
end;
/

-- For cursor
declare
    cursor csr_emp(dept_no hr.employees.first_name%type) is select first_name from hr.employees where department_id = dept_no;
    dept_no_list utils.udt_table_number := utils.udt_table_number();
begin
    -- For cursor non-named
    dbms_output.put('department no 10:' || chr(9));
    for i in (select * from hr.employees where department_id = 10) loop
        dbms_output.put(i.first_name || ' ' || i.last_name || ', ');
    end loop;
    dbms_output.put_line('');
    -- For cursor named
    dbms_output.put('department no 20:' || chr(9));
    for i in csr_emp(20) loop
        dbms_output.put(i.first_name || ', ');
    end loop;
    dbms_output.put_line('');
    -- Loop through a list of department_id to get employee first name for each department
    select department_id bulk collect into dept_no_list from hr.departments;
    utils.print_table_number(dept_no_list, 'department');
    for i in dept_no_List.first..dept_no_list.last loop
        dbms_output.put('department_id ' || dept_no_list(i) || ':' || chr(9));
        for c in csr_emp(dept_no_list(i)) loop
            dbms_output.put(c.first_name || ', ');
        end loop;
        dbms_output.put_line('');
    end loop;
end;
/

-- one ref cursor variable used for different select statements (weakly typed)
declare
    type ref_csr_type is ref cursor;
    ref_csr ref_csr_type;
    v_emp_row hr.employees%rowtype;
    v_dept_row hr.departments%rowtype;
begin
    open ref_csr for select * from hr.employees where department_id = 20;
    dbms_output.put('department 20 first_name:' || chr(9));
    loop
        fetch ref_csr into v_emp_row;
        exit when ref_csr%notfound;
        dbms_output.put(v_emp_row.first_name || ', ');
    end loop;
    dbms_output.put_line('');
    dbms_output.put_line('ref_csr%rowcount:' || chr(9) || ref_csr%rowcount);
    open ref_csr for select * from hr.departments;
    dbms_output.put('department:' || chr(9));
    loop
        fetch ref_csr into v_dept_row;
        exit when ref_csr%notfound;
        dbms_output.put(v_dept_row.department_id || ', ');
    end loop;
    dbms_output.put_line('');
    dbms_output.put_line('ref_csr%rowcount:' || chr(9) || ref_csr%rowcount);
    close ref_csr;
end;
/

-- passing query result using ref cursor
create or replace function get_emp_info (p_dept_no number) 
return sys_refcursor as
    emp_info_list sys_refcursor;
begin
    open emp_info_list for select first_name from hr.employees where department_id = p_dept_no;
    return emp_info_list;
end;
/

declare
    lv_fname hr.employees.first_name%type;
    lv_refcursor sys_refcursor;
begin
    lv_refcursor := get_emp_info(20);
    loop
        fetch lv_refcursor into lv_fname;
        exit when lv_refcursor%notfound;
        dbms_output.put(lv_fname || ', ');
    end loop;
    dbms_output.put_line('');
    close lv_refcursor;
end;
/

-- normal cursor can be defined in a package
create or replace package test_package_1 as
    cursor csr_p1 is select * from hr.employees;
end test_package_1;
/

-- ref cursor can NOT be global or defined outside of pl/sql subprogram
create or replace package test_package_2 as
    ref_csr sys_refcursor;
end test_package_2;
/
-- PLS-00994: Cursor Variables cannot be declared as part of a package

create or replace package test_package_3 as
    type udt_ref_csr is REF CURSOR;
    ref_csr udt_ref_csr;
end test_package_3;
/
-- PLS-00994: Cursor Variables cannot be declared as part of a package


-- strongly typed cursor with return type
type ref_csr_type is ref cursor return hr.employees%rowtype;
ref_csr ref_csr_type;

-- weakly typed cursor using user defined type
type ref_csr_type is ref cursor;
ref_csr ref_csr_type;
-- weakly typed cursor using sys_refcursor
ref_csr sys_refcursor;
