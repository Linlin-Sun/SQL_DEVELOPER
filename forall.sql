drop table test_table;
create table test_table (name varchar2(5) NOT NULL);
select count(*) from test_table;
-- Performance comparision between FOR loop and FORALL statement
-- FORALL is used for in-bind bulk binding type in this example
declare
    lv_table utils.udt_table_varchar2 := utils.udt_table_varchar2();
    lv_record_cnt int := 1000000;
    start_date date;
    end_date date; 
begin
    for i in 1..lv_record_cnt loop
        lv_table.extend;
        lv_table(i) := 'TEST';
    end loop;
    start_date := sysdate;
    for i in lv_table.first..lv_table.last loop
        insert into test_table values (lv_table(i));
    end loop;
    dbms_output.put_line('Seconds taken by for loop: ' || round((sysdate - start_date)*24*60*60));
    
    start_date := sysdate;
    forall i in lv_table.first..lv_table.last
        insert into test_table values (lv_table(i));
    dbms_output.put_line('Seconds taken by forall: ' || round((sysdate - start_date)*24*60*60));
end;
/
-- SAVE EXCEPTIONS
declare
    lv_table utils.udt_table_varchar2 := utils.udt_table_varchar2();
begin
    lv_table.extend(5);
    for i in lv_table.first..lv_table.last loop
        lv_table(i) := 'TEST';
    end loop;
    lv_table(2) := 'TEST123';
    lv_table(4) := NULL;
    FORALL i in lv_table.first..lv_table.last save exceptions
        insert into test_table values(lv_table(i));
exception when others then
    dbms_output.put_line('Number of error occurred: ' || SQL%BULK_EXCEPTIONS.COUNT);
    for i in 1..SQL%BULK_EXCEPTIONS.COUNT loop
        dbms_output.put_line('Index: '|| SQL%BULK_EXCEPTIONS(i).error_index 
            || ', Value: ' || lv_table(SQL%BULK_EXCEPTIONS(i).error_index)
            || ', ErrorCode: ' || sqlerrm(-SQL%BULK_EXCEPTIONS(i).error_code));
    end loop;
end;
/
truncate table test_table;
select * from test_table;
