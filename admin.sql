----------------------------- for sys ---------------------------------------
show parameter max_string_size;
show parameter db_multi_block_read_count;
select * from v$parameter where name like '%multi*read_count%';

create user c##common identified by common;
grant unlimited tablespace to c##common;
grant resource, connect, dba to c##common;

-- show which database we are in<
show con_name;
-- show what pdbs we have
show pdbs;
select name, open_mode from v$pdbs;
-- move into pdb which needs to be read and write
alter session set container=orclpdb;
show con_name;
alter pluggable database open;
create user local identified by local;
grant all privileges to local;
grant select_catalog_role to local;
grant select on v_$sql to local;
grant select on v_$parameter to local;
grant select on v_$sql_plan to local;
connect local/local@orclpdb

--alter pluggable database orclpdb open;
alter user hr identified by hr account unlock;
select username from dba_users where username = 'HR';

select * from v$sql where sql_text like '%test_table where id = 1';

select * from dba_object_usage;

-------------------------------- for local ----------------------------------------------
select * from v$version;
select * from user_tables;
select * from user_objects;
select * from user_tab_privs;
select * from user_role_privs;
select * from user_sys_privs;

set autotrace on explain

show parameter max_string_size;

set serveroutput on;
exec utils.drop_objects;
