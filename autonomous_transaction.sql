-- autonomous transaction to make the error logging in an independent transaction
drop table test_table;
drop table error_log;
create table test_table (id int);
create table error_log(code int, msg varchar2(100));
insert into test_table select level from dual connect by level <= 4;
--truncate table error_log;
--select * from test_table;
--select * from error_log;
create or replace procedure app_log(p_error_code int, p_error_msg varchar2) as pragma autonomous_transaction;
begin
    insert into error_log values (p_error_code, p_error_msg);
    commit;
end;
/
begin
    insert into test_table values (5);
    insert into test_table values ('a');
    commit;
exception
    when others then
        app_log(p_error_code => sqlcode, p_error_msg => sqlerrm);
        rollback;
end;
/
-- autonomous transaction on trigger
drop table test_table;
create table test_table (id int);
create or replace trigger bf_ins_trig_tt before insert on test_table for each row
declare
    pragma autonomous_transaction; -- without this, ORA-04092: cannot COMMIT in a trigger
begin
    commit;
end;
/
insert into test_table values (1);
-- autonomous transation for a function so that it can be invoked in a select stmt
drop table test_table;
create table test_table (id int);
create or replace function func_test return number as
    pragma autonomous_transaction; -- without this, ORA-14551: cannot perform a DML operation inside a query 
begin
    insert into test_table values (1);
    commit;
    return 3;
end;
/
select func_test from dual;
