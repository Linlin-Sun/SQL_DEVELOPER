-- table function
create or replace type udt_list as table of varchar2(100);
/
create or replace function table_func return udt_list as
    lv_list udt_list := udt_list();
    t1 timestamp; 
    t2 timestamp;
begin
    t1 := systimestamp; 
    for i in (select first_name from hr.employees) loop
        lv_list.extend;
        lv_list(lv_list.last) := i.first_name;
        t2 := systimestamp;
        dbms_output.put_line('Elapsed Seconds: '||TO_CHAR(t2-t1, 'SSSS.FF')); 
    end loop;
    return lv_list;
end;
/
select * from table_func() offset 40 rows fetch next 20 rows only;
select * from table(table_func());


-- pipeline function

create or replace type udt_list as table of varchar2(100);
/
create or replace function pipelined_func return udt_list pipelined as
    lv_list udt_list := udt_list();
    t1 timestamp; 
    t2 timestamp; 
begin
    t1 := systimestamp; 
    for i in (select first_name from hr.employees) loop
        pipe row(i.first_name);
        t2 := systimestamp;
        dbms_output.put_line('Elapsed Seconds: '||TO_CHAR(t2-t1, 'SSSS.FF')); 
    end loop;
    return;
end;
/
select * from pipelined_func() offset 40 rows fetch next 20 rows only;
select * from table(pipelined_func());
