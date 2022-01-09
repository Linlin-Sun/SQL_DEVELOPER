drop table test_table;
create table test_table as select * from hr.employees;

create index idx_rev_deptid on test_table(department_id) reverse;

-- reverse index is being used with equality predicate
select * from test_table where department_id = 20;
select * from v$sql where sql_text like '%test_table where department_id = 20%';
select sql_id, operation, options, object_name, object_type, cardinality from v$sql_plan where sql_id = 'bx15kuxxt5n8d';

-- -- reverse index is not being used with in-equality predicate
explain plan for select * from test_table where department_id > 20;
select * from table(dbms_xplan.display);
