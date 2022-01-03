-- varray. Define, declare, initialize, assign, acces
set serveroutput on
declare
    weekdays sys.odcivarchar2list := sys.odcivarchar2list(NULL, 'Monday');
begin
    weekdays(1) := 'Sunday';
    weekdays.extend(6);
    weekdays(3) := 'Tuesday';
    weekdays(4) := 'Wednesday';
    weekdays(5) := 'Thursday';
    weekdays(6) := 'Friday';
    weekdays(7) := 'Saturday';
    weekdays(8) := 'Noneday';
    dbms_output.put_line('weekdays limit: ' || weekdays.limit);
    dbms_output.put_line('weekdays count: ' || weekdays.count);
    dbms_output.put_line('weekdays first: ' || weekdays.first);
    dbms_output.put_line('weekdays last: ' || weekdays.last);
    dbms_output.put_line('weekdays prior(1): ' || weekdays.prior(1));
    dbms_output.put_line('weekdays prior(2): ' || weekdays.prior(2));
    dbms_output.put_line('weekdays next(3): ' || weekdays.next(3));
    utils.print_varray_varchar2(weekdays);
    weekdays.trim;
    utils.print_varray_varchar2(weekdays, 'After trim');
    weekdays.trim(2);
    utils.print_varray_varchar2(weekdays, 'After trim(2)');
--    weekdays.delete(2); -- Does not apply to varray
    weekdays.delete;
    utils.print_varray_varchar2(weekdays, 'After delete');
end;
/
-- Matrix using varray
declare
    col_count int := 3;
    row_count int := 5;
    start_num int := 1;
    type udt_one_d is varray(3) of int;
    type udt_two_d is varray(5) of udt_one_d;
    one_d udt_one_d := udt_one_d();
    two_d_1 udt_two_d := udt_two_d();
    two_d_2 udt_two_d := udt_two_d();
    two_d_3 udt_two_d := udt_two_d();
    procedure print_two_d(matrix udt_two_d, description varchar2) as
    begin
        dbms_output.put_line('----------' || description || '-------------');
        for i in matrix.first..matrix.last loop
            for j in matrix(i).first..matrix(i).last loop
                dbms_output.put(matrix(i)(j) || '     ');
            end loop;
            dbms_output.put_line('');
        end loop;
        dbms_output.put_line('');
    end;
    function populate_one_d(start_num int, col_count int) return udt_one_d as
        result_val udt_one_d := udt_one_d();
    begin
        result_val.extend(col_count);
        for i in result_val.first..result_val.last loop
            result_val(i) := start_num + i - 1;
        end loop;
        return result_val;
    end;
begin
    two_d_1.extend(row_count);
    for i in two_d_1.first..two_d_1.last loop
        two_d_1(i) := populate_one_d(start_num + col_count*(i-1), col_count);
    end loop;
    print_two_d(two_d_1, 'two_d_1');
    
    two_d_2.extend(row_count);
    for i in two_d_2.first..two_d_2.last loop
        two_d_2(i) := populate_one_d(start_num*10 + col_count*(i-1), col_count);
    end loop;
    print_two_d(two_d_2, 'two_d_2');
    
    two_d_3.extend(row_count);
    dbms_output.put_line('two_d_3.count: ' || two_d_3.count);
    for i in two_d_1.first..two_d_1.last loop
        two_d_3(i) := udt_one_d();
        two_d_3(i).extend(col_count);
        for j in two_d_1(i).first..two_d_1(i).last loop
            two_d_3(i)(j) := two_d_1(i)(j) + two_d_2(i)(j);
        end loop;
    end loop;
    print_two_d(two_d_3, 'two_d_3');
end;
/
-- Nested table. Define, declare, initialize, assign, acces
declare
    weekdays utils.udt_table_varchar2 := utils.udt_table_varchar2(NULL, 'Monday');
begin
    weekdays(1) := 'Sunday';
    weekdays.extend(6);
    weekdays(3) := 'Tuesday';
    weekdays(4) := 'Wednesday';
    weekdays(5) := 'Thursday';
    weekdays(6) := 'Friday';
    weekdays(7) := 'Saturday';
    weekdays(8) := 'Noneday';
    dbms_output.put_line('weekdays limit: ' || weekdays.limit);
    dbms_output.put_line('weekdays count: ' || weekdays.count);
    dbms_output.put_line('weekdays first: ' || weekdays.first);
    dbms_output.put_line('weekdays last: ' || weekdays.last);
    dbms_output.put_line('weekdays prior(1): ' || weekdays.prior(1));
    dbms_output.put_line('weekdays prior(2): ' || weekdays.prior(2));
    dbms_output.put_line('weekdays next(3): ' || weekdays.next(3));
    utils.print_table(weekdays);
    weekdays.trim;
    utils.print_table(weekdays, 'After trim');
    weekdays.trim(2);
    utils.print_table(weekdays, 'After trim(2)');
    weekdays.delete(2);
    utils.print_table(weekdays, 'After delete(2)');
    weekdays.delete(4, 5);
    utils.print_table(weekdays, 'After delete(4, 5)');
    weekdays.delete;
    utils.print_table(weekdays, 'After delete');
end;
/
-- associative array. Define, declare, assign, access. trim(), limit(), extend() does not work on associative array
declare
    weekdays utils.udt_dictionary_varchar2 := utils.udt_dictionary_varchar2();
begin
    weekdays('Sun') := 'Sunday';
    weekdays('Mon') := 'Tuesday';
    weekdays('Tue') := 'Tuesday';
    weekdays('Wed') := 'Wednesday';
    weekdays('Thurs') := 'Thursday';
    weekdays('Fri') := 'Friday';
    weekdays('Sat') := 'Saturday';
    weekdays('Non') := 'Noneday';
    dbms_output.put_line('weekdays count: ' || weekdays.count);
    dbms_output.put_line('weekdays first: ' || weekdays.first);
    dbms_output.put_line('weekdays last: ' || weekdays.last);
    dbms_output.put_line('weekdays prior(1): ' || weekdays.prior('Mon'));
    dbms_output.put_line('weekdays next(3): ' || weekdays.next('Thurs'));
    utils.print_dictionary(weekdays);
    weekdays.delete(2);
    utils.print_dictionary(weekdays, 'After delete(2)');
    weekdays.delete('Non', ');
    utils.print_dictionary(weekdays, 'After delete(Non)');
end;
/
