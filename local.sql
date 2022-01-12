select * from v$version;
select * from user_tables;
select * from user_objects;
select * from user_tab_privs;
select * from user_role_privs;
select * from user_sys_privs;

set autotrace on explain

show parameter max_string_size;

exec utils.drop_objects;

set serveroutput on;



