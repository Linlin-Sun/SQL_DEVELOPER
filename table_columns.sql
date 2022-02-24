-- Pseudo columns
-- Not defined as part of the table
-- Pseudo columns can NOT be updated/deleted by users
select rownum, rowid from hr.employees;

select * from all_objects where object_type = 'SEQUENCE' and owner = 'HR';
select hr.employees_seq.currval from dual;
select hr.employees_seq.nextval from dual;

select column_value from XMLTABLE('<a>123</a>');
select column_value from table(sys.odcinumberlist(1, 2));

-- A system change number (SCN) is a logical, internal time stamp used by Oracle Database
create table test_table (a number, b number, c as (a+b), d as (a-b));
insert into test_table columns (a, b) values(1, 2);
select ora_rowscn, employee_id from hr.employees;
select max(ora_rowscn), scn_to_timestamp(max(ora_rowscn)) from test_table;

select level, connect_by_isleaf, connect_by_iscycle from dual connect by nocycle level < 3;
-- Virtual columns
create table test_table (a number, b number, c as (a+b), d as (a-b));
insert into test_table columns (a, b) values(1, 2);
desc test_table;
select * from test_table;
select * from user_tab_cols where table_name = 'TEST_TABLE';
-- Invisible columns
create table test_table (a number, b number, c number invisible);
select * from user_tab_cols where table_name = 'TEST_TABLE';
insert into test_table values (1, 2);
insert into test_table (a, b, c) values (1, 2, 3);
select * from test_table;
select a, b, c from test_table;
set colinvisible on; -- show invisible column when using desc table_name
set colinvisible off;
desc test_table;
alter table test_table modify c visible;
-- Unused columns
create table test_table (a number, b number, c number);
alter table test_table set unused (c);
select * from user_tab_cols where table_name = 'TEST_TABLE';
select * from test_table;
alter table test_table drop unused columns;
