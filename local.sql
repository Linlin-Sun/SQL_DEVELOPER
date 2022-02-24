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
