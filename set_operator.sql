-- UNION(ALL), INTERSECT(ALL), MINUS(ALL), EXCEPT(ALL)
drop table t1;
drop table t2;
create table t1 (item varchar2(1));
create table t2 (item varchar2(1));

insert into t1 values('A');
insert into t1 values('B');
insert into t1 values('C');
insert into t1 values('C');
insert into t1 values('D');
insert into t1 values('E');
insert into t1 values('E');
insert into t1 values('F');

insert into t2 values('A');
insert into t2 values('B');
insert into t2 values('C');
insert into t2 values('D');
insert into t2 values('D');
insert into t2 values('E');
insert into t2 values('E');
insert into t2 values('G');

select * from t1 union all select * from t2;
select * from t1 union select * from t2;
select * from t1 intersect all select * from t2;
select * from t1 intersect select * from t2;
select * from t1 minus all select * from t2;
select * from t1 minus select * from t2;
select * from t1 except all select * from t2;
select * from t1 except select * from t2;

