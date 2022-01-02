select * from v$version;
select * from v$database;
select * from v$containers;
select * from v$pdbs;
select * from v$parameter where name='service_names';

create user c##common identified by common;
grant unlimited tablespace to c##common;
grant resource, connect, dba to c##common;

-- show which database we are in<
show con_name;
-- show what pdbs we have
show pdbs;
-- move into pdb which needs to be read and write
alter session set container=orclpdb;
show con_name;
create user local identified by local;
grant all privileges to local;
connect local/local@orclpdb

--alter pluggable database orclpdb open;
alter user hr identified by hr account unlock;
select username from dba_users where username = 'HR'



----------------------- hr_main.sql ----------------------

