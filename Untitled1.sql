declare
    type varchar2_varray is varray(10) of varchar2(20);
    weekdays varchar2_varray := varchar2_varray();
begin
    weekdays.extend(7);
    weekdays(1) := 'Monday';
    weekdays(2) := 'Tuesday';
    dbms_output.put_line(weekdays.count);
    for i in weekdays.first..weekdays.last loop
        dbms_output.put_line('weekdays(' || i || '): ' || weekdays(i));
    end loop;
end;
/