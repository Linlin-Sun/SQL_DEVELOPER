select * from user_indexes;
select * from user_ind_columns;
select * from user_ind_statistics;
select * from user_ind_expressions; -- for function based indexes
select * from user_tab_cols; 
alter index ... monitoring usage;
run query
alter index ... nomonitoring usage;
select * from user_object_usage;

drop table test_table;
create table test_table (id int, age int not null, sal float, name varchar2(30), gender varchar2(1), score int);

create unique index idx_btree_tt_id on test_table(id); 
create index idx_btree_tt_age on test_table(age); 
create index idx_btree_sal_age on test_table(sal desc); -- descending key
create bitmap index idx_bmap_tt_gender on test_table(gender); -- only available for enterprise edition
create index index_btree_tt_score on test_table(score) reverse; -- reverse key index
create index idx_func_tt_name on test_table(upper(name)); -- function based index
create index idx_comp_tt_name_gender on test_table(name, gender); -- composite index

-- Use explain plan check if index is being used by a query
explain plan for select * from test_table where id = 1;
select * from table(dbms_xplan.display);
-- Use v$sql_plan to check if index is being used by a query
select * from test_table where id = 2;
select * from v$sql where sql_text like '%test_table where id = 2';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '31z4fva7d1rbu';
-- index unique scan with a unique index above

-- index range scan with a non-unique index
explain plan for select * from test_table where id > 1;
select * from table(dbms_xplan.display);
select * from test_table where id > 1;
select * from v$sql where sql_text like '%test_table where id > 1';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '1cm65ffbfp7rn';

-- index range scan with a non-unique index
explain plan for select * from test_table where age = 1;
select * from table(dbms_xplan.display);
select * from v$sql where sql_text like '%test_table where age = 2';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '1cm65ffbfp7rn';
alter index idx_btree_tt_age monitoring usage;
select * from test_table where age = 2;
alter index idx_btree_tt_age nomonitoring usage;
select * from user_object_usage;

-- index full scan 
explain plan for select sum(age) from test_table;
select * from table(dbms_xplan.display);
select sum(age) from test_table;
select * from v$sql where sql_text like '%select sum(age) from test_table%';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '5dva8pqbjja0u';

-- index full scan min/max
explain plan for select min(age) from test_table;
select * from table(dbms_xplan.display);
select min(age) from test_table;
select * from v$sql where sql_text like '%select min(age) from test_table%';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = 'cw8gc6j125w01';

-- index fast full scan on multiple non unique indexed columns which are not null 
explain plan for select /*+ Index_FFS(test_table) */id, age from test_table;
select * from table(dbms_xplan.display);
select /*+ Index_FFS(test_table) */ id, age from test_table;
select * from v$sql where sql_text like '%id, age from test_table%';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '6a042x2xsdaas';


select * from test_table where upper(name) = 'A';
select * from v$sql where sql_text like '% where upper(name) =%';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '30bc50ms35da4';