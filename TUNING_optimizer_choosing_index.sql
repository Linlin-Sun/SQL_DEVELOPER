-- Cost for index range scan of an index with access predicates: 
--      blevel + (cardinality/#rows) X leaf blocks
-- Cost for index range scan of an index with filter predicates: (NDV Number of Distinct Values)
--      blevel + (1/NDV of columns X leaf blocks)
drop table my_sales;
-- If with column "comment" which is a key word, double quotes are required
-- Create table my_sales (cust_id int, prod_id int, COMMENT varchar2(100), price NUMBER);
--create table my_sales (cust_id int, prod_id int, "COMMENT" varchar2(100), price NUMBER);
create table my_sales (cust_id int, prod_id int, comments varchar2(100), price NUMBER);
select count(1) from my_sales s where s.prod_id = 9;

drop index prod_cust_id;
drop index prod_cust_com_id;
create index prod_cust_ind on my_sales(prod_id, cust_id);
create index prod_cust_com_ind on my_sales(prod_id, comments, cust_id);

delete from my_sales;
insert into my_sales 
    select floor(dbms_random.value()*10000), floor(dbms_random.value()*1000), 'comment '|| dbms_random.random(), level*2 from dual 
    connect by level <= 1000000;
commit;
exec dbms_stats.gather_table_stats('LOCAL', 'MY_SALES');
--select count(distinct(prod_id)) from my_sales;
select count(1) from my_sales where prod_id = 9;
explain plan for select comments from my_sales s where prod_id = 9 and cust_id < 938;
explain plan for select /*+ INDEX (my_sales PROD_CUST_IND)*/comments from my_sales s where prod_id = 9 and cust_id < 938;
explain plan for select /*+ INDEX(PROD_CUST_COM_IND) */ comments from my_sales s where prod_id = 9 and cust_id < 938;
select * from table(dbms_xplan.display);
select index_name, leaf_blocks, blevel from user_indexes where table_name = 'MY_SALES';
select 2+(1/100)*7826, 2+(1/100)*15074 from dual;

select comments from my_sales s where prod_id = 9 and cust_id < 938;
select /*+ INDEX(PROD_CUST_COM_IND) */ comments from my_sales where prod_id = 9 and cust_id < 938;
select sql_text, sql_id from v$sql where sql_text like '%s.cust_id < 10938';
select sql_id, operation, options, object_name, object_type, cost, cardinality from v$sql_plan where sql_id = '2kqcvnt0qg0x3';
--------------------------------------------------------------------------------
-- What do we know about the table
--------------------------------------------------------------------------------
select count(1) from my_sales;
select table_name, partitioned from user_tables where table_name = 'MY_SALES';
select table_name, last_analyzed, stale_stats from user_tab_statistics where table_name = 'My_SALES';
select index_name, stale_stats, leaf_blocks, distinct_keys, sample_size, last_analyzed from user_ind_statistics where table_name = 'MY_SALES';
select index_name, leaf_blocks, blevel from user_indexes where table_name = 'MY_SALES';
select * from user_indexes where table_name = 'MY_SALES';

