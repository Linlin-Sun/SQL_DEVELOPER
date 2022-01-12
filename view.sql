-------------------- prepare work --------------------
drop view test_view;
drop view fview;
drop materialized view mview;
drop table employees;
create table employees as select * from hr.employees;

-------------------- dictionary tables for views --------------------
select * from user_views;
select * from user_objects; -- object_name, object_type, data_object_id, status
select * from user_tables;
select * from user_dependencies where type like '%VIEW';
select * from user_tab_columns;
select * from user_constraints;

-- Creating view, invaliddate view, compile view
-- compile view: alter view viewname compile, select * from viewname, recreate view
create or replace view test_view as select * from employees where department_id = 30;
select * from test_view;
alter table employees drop (job_id);
alter table employees add (job_id int);
alter view test_view compile;

-------------------- force view
create or replace force view fview as select * from non_exist_table;
create table non_exist_table as select * from hr.employees;
alter view fview compile;

-- materialized view
create materialized view mview as select * from employees where department_id <= 30;
select * from mview;
delete from employees where department_id = 20;
exec dbms_mview.refresh('MVIEW');
alter table employees drop (job_id);
alter table employees add (job_id int);
alter materialized view mview compile;

-- view "with read only" constraint 
create or replace view test_view as select * from employees where department_id = 30 with read only;

-- view "with check option" constraint
create or replace view test_view as select * from employees where department_id = 30 with check option;

-- create a view for every table in a schema
set serveroutput on
begin
    for i in (select table_name from user_tables) loop
        dbms_output.put_line(i.table_name);
        execute immediate 'create or replace view ' || i.table_name || '_V as select * from ' || i.table_name;
    end loop;
end;
/











