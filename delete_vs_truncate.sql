select * from user_tables;

select * from user_segments;

drop table test_table;
create table test_table (id int, name varchar2(30));
insert into test_table select level, 'test_name' from dual connect by level <= 1000000;
commit;
select 'Before delete', utils.get_table_size_mb('test_table') from dual;
delete from test_table;
commit;
select 'After delete', utils.get_table_size_mb('test_table') from dual;

drop table test_table;
create table test_table (id int, name varchar2(30));
insert into test_table select level, 'test_name' from dual connect by level <= 1000000;
commit;
select 'Before truncate', utils.get_table_size_mb('test_table') from dual;
truncate table test_table;
select 'After truncate', utils.get_table_size_mb('test_table') from dual;
