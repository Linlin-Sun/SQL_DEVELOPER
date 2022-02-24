-- Set operators
-- UNION(ALL), INTERSECT(ALL), MINUS(ALL)
-- EXCEPT(ALL) -- new for oracle 21 c, works the same as MINUS(ALL)
-- MINUS and EXCEPT create distinct values then do the operation
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

-- Multiset operators
-- MULTISET UNION(ALL), MULTISET INTERSECT(ALL), MULTISET EXCEPT(ALL)
-- MINUS and EXCEPT create distinct values then do the operation

declare
    nt_1 utils.udt_table_number := utils.udt_table_number(1, 1, 2, 2, 3, 4, 5, 8, 9, 9);
    nt_2 utils.udt_table_number := utils.udt_table_number(9, 1, 1, 2, 2, 6, 7);
    nt_3 utils.udt_table_number := utils.udt_table_number();
begin
    utils.print_table_number(nt_1, 'nt_1');
    utils.print_table_number(nt_2, 'nt_2');
    
    nt_3 := nt_1 multiset union nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset union');
    nt_3 := nt_1 multiset union all nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset union all');
    nt_3 := nt_1 multiset union distinct nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset union distinct');
    
    nt_3 := nt_1 multiset intersect nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset intersect');
    nt_3 := nt_1 multiset intersect all nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset intersect all');
    nt_3 := nt_1 multiset intersect distinct nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset intersect distinct');
    
    nt_3 := nt_1 multiset except nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset except');
    nt_3 := nt_1 multiset except all nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset except all');
    nt_3 := nt_1 multiset except distinct nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset except distinct');
end;
/

declare
    nt_1 utils.udt_table_varchar2 := utils.udt_table_varchar2('A', 'B', 'C', 'C', 'D', 'E', 'E', 'F');
    nt_2 utils.udt_table_varchar2 := utils.udt_table_varchar2('A', 'B', 'C', 'D', 'D', 'E', 'E', 'G');
    nt_3 utils.udt_table_varchar2 := utils.udt_table_varchar2();
begin
    utils.print_table_varchar2(nt_1, 'nt_1');
    utils.print_table_varchar2(nt_2, 'nt_2');
    
    nt_3 := nt_1 multiset union nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset union');
    nt_3 := nt_1 multiset union all nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset union all');
    nt_3 := nt_1 multiset union distinct nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset union distinct');
    
    nt_3 := nt_1 multiset intersect nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset intersect');
    nt_3 := nt_1 multiset intersect all nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset intersect all');
    nt_3 := nt_1 multiset intersect distinct nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset intersect distinct');
    
    nt_3 := nt_1 multiset except nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset except');
    nt_3 := nt_1 multiset except all nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset except all');
    nt_3 := nt_1 multiset except distinct nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset except distinct');
end;
/
