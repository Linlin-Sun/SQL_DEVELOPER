drop table test_table;
create table test_table (id int, name varchar2(20));
--------------------------------------------------------------------------------
-- function with DML
--------------------------------------------------------------------------------
create or replace function test_func return int as
begin
    insert into test_table values (1, 'test1');
    commit;
    return 1;
end;
/
-- ORA-14551: cannot perform a DML operation inside a query
select test_func from dual;  
-- works if function is used in an expression
declare
    lv_result int;
begin
    lv_result := test_func;
    dbms_output.put_line('lv_result = ' || lv_result);
end;
/
select * from test_table;
--------------------------------------------------------------------------------
-- function with DML using pragma autonomous_transaction
--------------------------------------------------------------------------------
create or replace function test_func return int as pragma autonomous_transaction;
begin
    insert into test_table values (1, 'test1');
    commit;
    return 1;
end;
/
-- Using pragma autonomous_transaction on the function will make the select statement successful
select test_func from dual;
select * from test_table;
--------------------------------------------------------------------------------
-- function with DDL 
--------------------------------------------------------------------------------
create or replace function test_func return int as
begin
    truncate table test_table;
    return 1;
end;
/
--------------------------------------------------------------------------------
-- function with DDL using execute immediate
--------------------------------------------------------------------------------
create or replace function test_func return int as
begin
    execute immediate 'truncate table test_table';
    return 1;
end;
/
-- ORA-14552: cannot perform a DDL, commit or rollback inside a query or DML 
select test_func from dual;  
-- works if function is used in an expression
declare
    lv_result int;
begin
    lv_result := test_func;
    dbms_output.put_line('lv_result = ' || lv_result);
end;
/
select * from test_table;
--------------------------------------------------------------------------------
-- function with DDL using execute immediate and pragma autonomous_transaction
--------------------------------------------------------------------------------
create or replace function test_func return int as pragma autonomous_transaction;
begin
    execute immediate 'truncate table test_table';
    return 1;
end;
/
-- Success 
select test_func from dual; 


