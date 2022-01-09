select * from user_indexes;
select * from user_ind_columns;
select * from user_ind_expressions;
select * from user_ind_statistics;
select table_name, column_name, data_default, hidden_column, virtual_column from user_tab_cols;

drop table test_table;
create table test_table (id int, name varchar2(20));

create index idx_func_tt_name on test_table(upper(name));

explain plan for select * from test_table where upper(name) = 'A';
select * from table(dbms_xplan.display);

explain plan for update test_table set name = 'B' where upper(name) = 'A';
select * from table(dbms_xplan.display);
