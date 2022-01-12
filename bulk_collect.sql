-- SELECT <column_names> BULK COLLECT INTO <plsql_collection>;
declare
    type varchar2_tab_type is table of varchar2(100);
    lv_list varchar2_tab_type := varchar2_tab_type();
begin
    select first_name bulk collect into lv_list from hr.employees;
    for i in lv_list.first..lv_list.last loop
        dbms_output.put_line(i || chr(9) || lv_list(i));
    end loop;
end;
/
-- FETCH <cursor_name> BULK COLLECT INTO <plsql_collection>;
-- FETCH <cursor_name> BULK COLLECT INTO <plsql_collection> LIMIT number;
declare
    type varchar2_tab_type is table of varchar2(100);
    lv_list varchar2_tab_type := varchar2_tab_type();
    cursor csr_emp is select first_name from hr.employees;
begin
    open csr_emp;
--        fetch csr_emp bulk collect into lv_list;
        fetch csr_emp bulk collect into lv_list limit 10;
    close csr_emp;
    for i in lv_list.first..lv_list.last loop
        dbms_output.put_line(i || chr(9) || lv_list(i));
    end loop;
end;
/



