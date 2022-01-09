drop table test_table;
create table test_table (id int);
insert into test_table select level from dual connect by level <= 1000000;

create or replace function local_get_table_size_mb(tbname varchar2) return number as
    lv_size number;
begin
    select bytes/(1024*1024) into lv_size from user_segments where segment_name = upper(tbname);
    return lv_size;
end;
/
delete from test_table;
commit;
select local_get_table_size_mb('test_table') from dual;
truncate table test_table;
select * from user_objects;
drop function func_test;