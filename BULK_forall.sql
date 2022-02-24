drop table test_table;
create table test_table (name varchar2(5) NOT NULL);
select count(*) from test_table;
-- FORALL is for bulk processing in-bind bulk binding type for DML (insert, update, delete and merge)
-- Three types of bind clause
    -- FORALL <i> IN <lowerbound_index>..<upperbound_index> -- dense collection
    -- FORALL <i> IN INDICES OF <collection> -- sparse nested table
    -- FORALL <i> IN VALUES OF <associative_array> -- associated array contains the indexes to be used from a collection with the value to be in DML
-- Performance comparision between FOR loop and FORALL statement
-- FORALL <i> IN <lowerbound_index>..<upperbound_index> -- dense collection
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
-- In this example with lower bound and upper bound of the index of a associative array with dense collection
declare
    type dict_type is table of varchar2(100) index by pls_integer;
    lv_dict dict_type := dict_type();
begin 
    for i in 1..10 loop
        lv_dict(i) := 'T' || i;
    end loop;
    forall i in lv_dict.first..lv_dict.last
        insert into test_table values (lv_dict(i));
end;
/
-- FORALL with SAVE EXCEPTIONS
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
-- FORALL <i> IN INDICES OF <collection> -- sparse nested table
declare
    lv_table utils.udt_table_varchar2 := utils.udt_table_varchar2('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
begin 
    lv_table.delete(3, 6);
--    for i in lv_table.first..lv_table.last loop
--        if lv_table.exists(i) then
--            dbms_output.put_line(lv_list(i));
--        else
--            dbms_output.put_line('No value for index ' || i);
--        end if;
--    end loop;
    forall i in indices of lv_table
        insert into test_table values (lv_table(i));
end;
/
select * from test_table;
-- FORALL <i> IN VALUES OF <associative_array> 
-- One source collection to store the data to be used for DML. 
-- One associative array to store the indexes for the collection to do selective DML. dict_type is normally table pls_interger index by pls_integer
declare
    lv_table utils.udt_table_varchar2 := utils.udt_table_varchar2('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J');
    type dict_type is table of pls_integer index by pls_integer;
    lv_dict dict_type;
begin
    lv_dict(2) := 3;
    lv_dict(5) := 7;
    lv_dict(11) := 8;
    forall i in values of lv_dict
        insert into test_table values(lv_table(i));
end;
/