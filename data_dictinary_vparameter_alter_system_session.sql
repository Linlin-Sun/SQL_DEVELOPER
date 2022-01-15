select * from v$version;
select * from v$database;
select * from v$containers;
select * from v$pdbs;
select * from v$parameter where name='service_names';
select * from v$open_cursor;
select * from v$parameter where name like '%open_cursors%';
select * from v$parameter where name like '%max_string_size%';

-- controls the length of table name from 30 to 128 long >=12.2
select * from v$parameter where name like '%compatible%';
desc user_tables;

-- DDL logging
-- C:\21c\diag\rdbms\orcl\orcl\log\ddl\*.xml
-- C:\21c\diag\rdbms\orcl\orcl\log\*.log
alter system set enable_ddl_logging=true;
alter session set enable_ddl_logging=true;

create sequence test_seq;
drop sequence test_seq;
