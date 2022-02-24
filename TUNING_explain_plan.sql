select * from V$SESSION_LONGOPS;

explain plan for select comments from my_sales s where prod_id = 9 and cust_id < 938;
select * from table(dbms_xplan.display);

select comments from my_sales where prod_id = 9 and cust_id < 938;
select * from v$sql_plan where sql_id ='2sc6rd97jmf5g';

select /*+ gather_plan_statistics */ comments from my_sales where prod_id = 9 and cust_id < 938;
select * from v$sql where sql_text like '%prod_id = 9 and cust_id < 938' and sql_text not like '%explain%' and sql_text not like '%count%';
select sql_id, operation, options, object_name, object_type, cardinality, optimizer, access_predicates, filter_predicates 
    from v$sql_plan where sql_id = '3s1zabfb1wy7x';
select * from dbms_xplan.display_cursor(sql_id => '3s1zabfb1wy7x', format=>'ALLSTATS BASIC');

exec dbms_stats.gather_table_stats('LOCAL', 'MY_SALES');

select table_name, last_analyzed, stale_stats from user_tab_statistics where table_name = 'My_SALES';
select index_name, stale_stats, leaf_blocks, distinct_keys, sample_size, last_analyzed from user_ind_statistics where table_name = 'MY_SALES';
select index_name, leaf_blocks, blevel from user_indexes where table_name = 'MY_SALES';
select 2+(1/1000)*7178, 2+(1/1000)*14024 from dual;

select count(1) from my_sales where prod_id = 9 and cust_id < 938;
select count(1) from my_sales where prod_id = 9;
select count(distinct(prod_id)) from my_sales;
