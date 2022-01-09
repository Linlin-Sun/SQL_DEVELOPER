-- heap organized (normal) table
-- 1. Primary key is NOT requried. Physical rowid. 
-- 2. Insert where it can fit. The physical location of a row does not change usually in a regular relational table. 
-- 3. TWO segements are being created: one for table, one for index
-- 4. explain plan has 2 I/O since key and rowid is stored in index segment and other data are in table segment
drop table hot;
create table hot (id int primary key, name varchar2(10));
insert into hot values (2, 'row 2');
insert into hot values (3, 'row 3');
insert into hot values (1, 'row 1');
commit;

select * from hot;
select table_name, iot_type, iot_name from user_tables where table_name = 'HOT';
select * from user_segments where segment_name = 'HOT';
select index_name, index_type, table_name from user_indexes where table_name = 'HOT';
select * from user_segments where segment_name = 'SYS_C008348';
explain plan for select * from hot where id = 1;
select * from table(dbms_xplan.display);

-- index organized table (IOT) -- Variation of b-tree index structure
-- 1. Primary key is requried.  Logical rowid. 
-- 2. Data is stored ordered by the primary key so swapping is possible during insertion.
-- 3. ONE segement is being created for index
-- 4. explain plan has 1 I/O since data is stored in the leaf block. 
-- 5. Pros
    -- Faster data retrieval via primary key.
    -- Optimized data storage. 
    -- Can use data compression since table is sorted by PK. 
    -- High availability (logical rowid is used, so index do not become unusable if data is reorganized) 
-- 7. Cons
    -- Alter index not allowed. Use alter table. 
    -- Can not use in cluster
drop table iot_1;
create table iot_1 (id int primary key, name varchar2(10)) organization index;
insert into iot_1 values (2, 'row 2');
insert into iot_1 values (3, 'row 3');
insert into iot_1 values (1, 'row 1');
commit;

select * from iot_1;
select table_name, iot_type, iot_name from user_tables where table_name = 'IOT_1';
select * from user_segments where segment_name = 'IOT_1';
select index_name, index_type, table_name from user_indexes where table_name = 'IOT_1';
select * from user_segments where segment_name = 'SYS_IOT_TOP_76450';
explain plan for select * from iot_1 where id = 1;
select * from table(dbms_xplan.display);

-- index organized table with overflow. Store columns not frequently used in a different segment
-- 1. Primary key is requried. Data is stored ordered by the primary key so swapping is possible. 
-- 2. 2 segements are being created, one for index, one for overflow
-- 3. explain plan has 1 I/O
drop table iot_2 purge;
create table iot_2 (id int primary key, name varchar2(10), salary int) organization index including name overflow;
insert into iot_2 values (2, 'row 2', 100);
insert into iot_2 values (3, 'row 3', 200);
insert into iot_2 values (1, 'row 1', 300);
commit;

select * from iot_2;
select table_name, iot_type, iot_name from user_tables where table_name = 'IOT_2';
select * from user_segments where segment_name = 'IOT_2';
select index_name, index_type, table_name from user_indexes where table_name = 'IOT_2';
select * from user_segments where segment_name = 'SYS_IOT_TOP_76452';
select table_name, iot_type, iot_name from user_tables where iot_name = 'IOT_2';
explain plan for select * from iot_2 where id = 1;
select * from table(dbms_xplan.display);