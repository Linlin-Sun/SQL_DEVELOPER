-- 1. Does creating a “primary key constraint” always create an index automatically? 
    -- If there is a pre existing (unique or non unique)index on the column(s)
        -- Adding a PK constraint will NOT create an index. Oracle will use the existing (unique or non unique) index to enforce uniqueness.
    -- If there is not a pre existing index on the column(s)
        -- Adding a PK constraint will create a unique index on the column(s)
        -- Adding a PK constraint DEFERRABLE NOVALIDATE will create a non unique index on the column(s)
-- 2. Will dropping constraint drop underlying index
    -- If the (unique or non unique) index was pre existing
        -- Dropping the PK constraint will NOT drop the underlying index
        -- Dropping the PK constraint with “drop index” option will drop the underlying index
    -- If the index was not pre existing
        -- If constraint is NOT DEFERRABLE NOVALIDATE, dropping the PK constraint will drop the underlying index
        -- If constraint is DEFERRABLE NOVALIDATE, dropping the PK constraint will NOT drop the underlying non unique index
        -- If constraint is DEFERRABLE NOVALIDATE, dropping the PK constraint with 'drop index' option will drop the underlying index
-- 3. Will dropping tables drop underlying constraints, triggers and index? 
    -- YES
-- 4. Can a primary key create a non-unique index? 
    -- YES. IF THE PK CONSTRAINT IS CREATED “DEFERRABLE NOVALIDATE’
-- 5. What is the difference between 'unique index' and 'unique constraint'? When to use what? 
    -- constraint is for data integrity, index is for performance
    -- unique constraint automatically creates an unique index (but not always)
    -- foreign key can be created over a unique constraint, not over a unique index
-- 6. Can more than one index be created on the same column? 
    -- Multiple indexes are allowed on the same column(s) but only at most one index can be visible (OPTIMIZER_USE_INVISIBLE_INDEXES)
select * from user_tables;
select * from user_tab_cols;
select * from user_objects;
select * from user_constraints;
select * from user_indexes;
select * from user_ind_columns;
select * from user_ind_statistics;
select * from user_ind_expressions;
purge recyclebin;
-- Non pre existing index
    -- Adding a PK constraint will create a unique index on the column(s)
    -- Dropping the PK constraint will drop the non pre existing index
exec utils.drop_objects;
create table test_table (id int, name varchar2(20), constraint pk_tt_id primary key(id));
alter table test_table drop constraint pk_tt_id;
-- Pre existing (unique or non unique )index on the column(s)
    -- Adding a PK constraint will not create an index. Oracle will use the existing (unique or non unique) index to enforce uniqueness.
    -- Dropping the PK constraint will NOT drop the index. 
    -- Dropping the PK constraint with "drop index" option will drop the index
exec utils.drop_objects;
create table test_table (id int, name varchar2(20));
create index idx_tt_id on test_table(id);
alter table test_table add constraint pk_tt_id primary key(id);
alter table test_table drop constraint pk_tt_id;
alter table test_table drop constraint pk_tt_id drop index;
-- Non pre existing index
    -- Adding a PK constraint DEFERRABLE NOVALIDATE will create a NON unique index on the column(s)
    -- Dropping the PK constraint will NOT drop the index
    -- Dropping the PK constraint with "drop index" option will drop the index
exec utils.drop_objects;
create table test_table (id int, name varchar2(20));
alter table test_table add constraint pk_tt_id primary key (id) deferrable novalidate;
alter table test_table drop constraint pk_tt_id;
alter table test_table drop constraint pk_tt_id drop index;
-- Pre existing (unique or non unique )index on the column(s)
    -- Adding a PK constraint DEFERRABLE NOVALIDATE will not create an index. 
    -- Dropping the PK constraint will NOT drop the index. 
    -- Dropping the PK constraint with "drop index" option will drop the index
exec utils.drop_objects;
create table test_table (id int, name varchar2(20));
create index idx_tt_id on test_table(id);
alter table test_table add constraint pk_tt_id primary key(id) deferrable novalidate;
alter table test_table drop constraint pk_tt_id;
alter table test_table drop constraint pk_tt_id drop index;
-- Dropping table will drop the constraints and indexes
exec utils.drop_objects;
create table test_table (id int primary key, name varchar2(20));
create index idx_tt_name on test_table(name);
drop table test_table purge;
-- Only one index is allowed for the same column except invisible index
exec utils.drop_objects;
create table test_table (id int primary key, name varchar2(20));
create index idx_tt_id on test_table(id); -- ORA-01408: such column list already indexed
create index idx_tt_id on test_table(id) invisible;
