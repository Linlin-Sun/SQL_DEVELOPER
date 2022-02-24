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
declare
    type varchar2_tab_type is table of varchar2(100);
    lv_list varchar2_tab_type := varchar2_tab_type();
    cursor csr_emp is select first_name from hr.employees;
begin
    open csr_emp;
        fetch csr_emp bulk collect into lv_list;
    close csr_emp;
    for i in lv_list.first..lv_list.last loop
        dbms_output.put_line(i || chr(9) || lv_list(i));
    end loop;
end;
/
-- LIMIT works with FETCH INTO only. It does NOT work with SELECT INTO
-- FETCH <cursor_name> BULK COLLECT INTO <plsql_collection> LIMIT number;
declare
    type varchar2_tab_type is table of varchar2(100);
    lv_list varchar2_tab_type := varchar2_tab_type();
    lv_n int := 10;
    cursor csr_emp is select first_name from hr.employees;
begin
    open csr_emp;
    loop
        fetch csr_emp bulk collect into lv_list limit lv_n;
        for i in lv_list.first..lv_list.last loop
            dbms_output.put_line(i || chr(9) || lv_list(i));
        end loop;
        exit when lv_list.count < lv_n;
    end loop;
    close csr_emp;
end;
/
-- FORALL with BULK COLLECT INTO
-- FORALL <i> IN ... <DML> RETURNING <colname> BULK COLLECT INTO <collection> 
drop table test_table;
create table test_table (name varchar2(5) NOT NULL);
declare
    type table_type is table of varchar2(5);
    lv_in table_type := table_type('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
    lv_out table_type := table_type();
begin
    forall i in lv_in.first..lv_in.last
        insert into test_table values (lv_in(i)) returning name bulk collect into lv_out;
    for i in lv_out.first..lv_out.last loop
        dbms_output.put_line(lv_out(i));
    end loop;
end;
/