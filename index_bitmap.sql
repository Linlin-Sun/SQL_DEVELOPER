drop table test_table;
create table test_table (id int, name varchar2(20), gender varchar2(10));
create bitmap index idx_bmap_tt_gender on test_table(gender);
select * from user_indexes;

select count(*) from test_table where gender = 'P';
select * from v$sql where sql_text like '%where gender =%';
-- bitmap index fast full scan
select sql_id, operation, options, object_name, object_type, cardinality from v$sql_plan where sql_id = 'fv63y09460ufh';

-- function based index can be either b-tree or bitmap
create index idx_bmap_tt_gname on test_table(upper(gender));
create bitmap index idx_bmap_tt_gname on test_table(upper(gender));