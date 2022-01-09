drop table test_table;
create table test_table (id int);
select count(*) from test_table;
-- using for loop takes longer time
declare
    type udt_int_table is table of int;
    int_table udt_int_table := udt_int_table();
    start_date date;
    end_date date;
begin
    start_date := sysdate;
    for i in 1..1000000 loop
        int_table.extend;
        int_table(i) := i;
    end loop;
    for i in int_table.first..int_table.last loop
        insert into test_table values (int_table(i) + 1);
    end loop;
    dbms_output.put_line((sysdate - start_date)*24*60*60);
end;
/
-- using forall takes shorter time
declare
    type udt_int_table is table of int;
    int_table udt_int_table := udt_int_table();
    start_date date;
    end_date date;
begin
    start_date := sysdate;
    for i in 1..1000000 loop
        int_table.extend;
        int_table(i) := i;
    end loop;
    forall i in int_table.first..int_table.last
        insert into test_table values (int_table(i) + 1);
    dbms_output.put_line((sysdate - start_date)*24*60*60);
end;
/

