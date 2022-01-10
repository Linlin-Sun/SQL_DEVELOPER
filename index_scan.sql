select * from all_indexes where owner = 'HR' and table_name = 'EMPLOYEES';
select * from all_ind_columns where table_owner = 'HR' and table_name = 'EMPLOYEES';
select * from all_constraints where owner = 'HR' and table_name = 'EMPLOYEES';
-- Index unique scan (equality check or IN for unique columns)
explain plan for select * from hr.employees where employee_id = 101;;
select * from table(dbms_xplan.display);
select * from hr.employees where employee_id = 101;
select * from v$sql where sql_text like '%hr.employees where employee_id = 101%';
select sql_id, operation, options, object_name, object_type, cardinality, optimizer from v$sql_plan where sql_id = '82mnzcywm53rs';
-- Index range scan (equality check on non-unique indexed column OR inequality check for unique or non-unique indexed columns)
explain plan for select * from hr.employees where employee_id <= 101;
select * from table(dbms_xplan.display);
select * from hr.employees where employee_id <= 101;
select * from v$sql where sql_text like '%hr.employees where employee_id <= 101%';
select sql_id, operation, options, object_name, object_type, cardinality, optimizer from v$sql_plan where sql_id = '62mm5x2jmrutd';
-- Index full scan (functions on indexed columns)
explain plan for select upper(email) from hr.employees;
select * from table(dbms_xplan.display);
select upper(email) from hr.employees;
select * from v$sql where sql_text like '%upper(email) from hr.employees%';
select sql_id, operation, options, object_name, object_type, cardinality, optimizer from v$sql_plan where sql_id = '3j8a29jgczbc9';
-- Index full scan min/max (min/max function on indexed columns)
explain plan for select max(department_id) from hr.employees;
select * from table(dbms_xplan.display);
select min(department_id) from hr.employees;
select * from v$sql where sql_text like '%min(department_id) from hr.employees%';
select sql_id, operation, options, object_name, object_type, cardinality, optimizer from v$sql_plan where sql_id = '12zn3vncjz0wu';
-- Index fast full scan (works when both columns are NOT NULL, does not work for three columns)
explain plan for select employee_id, last_name from hr.employees;
select * from table(dbms_xplan.display);
select employee_id, last_name from hr.employees;
select * from v$sql where sql_text like '%employee_id, last_name from hr.employees%';
select sql_id, operation, options, object_name, object_type, cardinality, optimizer from v$sql_plan where sql_id = 'gf5hktbggf0h4';
-- Index skip scan (first column on composite index being skipped)
drop table test_objects;
create table test_objects as select * from all_objects;
create index test_objects_idx on test_objects (owner, object_name, subobject_name);
exec dbms_stats.gather_table_stats(user, 'TEST_OBJECTS', cascade => TRUE);
explain plan for select owner, object_name from test_objects where object_name = 'DBMS_OUTPUT';
select * from table(dbms_xplan.display);
