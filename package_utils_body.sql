create or replace package body utils as 
    procedure drop_objects is
        lv_mview_cnt int;
        lv_drop_flag boolean := FALSE;
    begin
        dbms_output.put_line('START PROCEDURE UTILS.DROP_OBJECTS');
        for i in (select object_name, object_type from user_objects) loop
            lv_mview_cnt := 0;
            lv_drop_flag := FALSE;
            if i.object_type in ('VIEW', 'TABLE', 'MATERIALIZED VIEW', 'FUNCTION', 'PROCEDURE') then
                if i.object_type in ('FUNCTION', 'PROCEDURE') then
                    lv_drop_flag := TRUE;
                elsif i.object_name like 'PLSQL_PROFILER_%' then
                    lv_drop_flag := FALSE;
                elsif i.object_name not like 'SYS_%' and i.object_type = 'TABLE' then
                    select count(1) into lv_mview_cnt from user_objects where object_name = i.object_name and object_type = 'MATERIALIZED VIEW';
                    if lv_mview_cnt = 0 then
                        lv_drop_flag := TRUE;
                    end if;
                end if;
            end if;
            if lv_drop_flag then
                dbms_output.put_line('drop ' || i.object_type || ' ' || i.object_name);
                execute immediate 'drop ' || i.object_type || ' ' || i.object_name;
            end if;
        end loop;
        execute immediate 'purge recyclebin';
        dbms_output.put_line('END PROCEDURE UTILS.DROP_OBJECTS');
    end;
    
    function get_table_size_mb(tbname varchar2) return number is
        lv_size number;
    begin
        select bytes/power(1024, 2) into lv_size 
        from user_segments where segment_name = upper(tbname);
        return lv_size;
    end get_table_size_mb;
    
    function get_boolean_str(bool_var boolean) return varchar2 is
        lv_bool_str varchar2(10);
    begin
        lv_bool_str := case bool_var when true then 'true' else 'false' end;
        return lv_bool_str;
    end;

    procedure print_varray_varchar2(collection sys.odcivarchar2list, description varchar2 := '') as
    begin
        dbms_output.put_line(upper(description) || ':' || chr(9));
        if collection.count > 0 then
            for i in collection.first..collection.last loop
                if collection.exists(i) then
                    dbms_output.put(i || ' ' || collection(i) || '; ');
                end if;
            end loop;
        else
            dbms_output.put_line('Empty collection');
        end if;
        dbms_output.put_line('');
    end;
    
    procedure print_table_varchar2(collection udt_table_varchar2, description varchar2 := '') as
    begin
        dbms_output.put_line(upper(description) || ':' || chr(9));
        if collection.count > 0 then
            for i in collection.first..collection.last loop
                if collection.exists(i) then
                    dbms_output.put(i || ' ' || collection(i) || '; ');
                end if;
            end loop;
        else
            dbms_output.put_line('Empty collection');
        end if;
        dbms_output.put_line('');
    end;
    
    procedure print_dictionary(collection udt_dictionary_varchar2, description varchar2 := '') as
        key_name varchar2(20);
    begin
        dbms_output.put_line(upper(description) || ':' || chr(9));
        if collection.count > 0 then
            key_name := collection.first;
            while key_name is not null loop
                dbms_output.put(key_name || ' ' || collection(key_name) || '; ');
                key_name := collection.next(key_name);
            end loop;
        else
            dbms_output.put_line('Empty collection');
        end if;
        dbms_output.put_line('');
    end;
    procedure print_table_number(collection udt_table_number, description varchar2) as
    begin
        dbms_output.put(upper(description) || ':' || chr(9));
        if collection.count > 0 then
            for i in collection.first..collection.last loop
                dbms_output.put(collection(i) || ' ');
            end loop;
            dbms_output.put_line('');
        end if;
    end;
end utils;
/