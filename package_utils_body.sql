create or replace package body utils as 
    procedure drop_objects is
        lv_mview_cnt int;
    begin
        for i in (select object_name, object_type from user_objects) loop
            lv_mview_cnt := 0;
            if i.object_type in ('VIEW', 'TABLE', 'MATERIALIZED VIEW') then
                dbms_output.put_line('drop ' || i.object_type || ' ' || i.object_name);
                if i.object_type = 'TABLE' then
                    select count(1) into lv_mview_cnt from user_objects where object_name = i.object_name and object_type = 'MATERIALIZED VIEW';
                end if;
                dbms_output.put_line(lv_mview_cnt);
                if lv_mview_cnt = 0 then
                    dbms_output.put_line('drop ' || i.object_type || ' ' || i.object_name);
                    execute immediate 'drop ' || i.object_type || ' ' || i.object_name;
                end if;
            end if;
        end loop;
    end;
    
    function get_table_size_mb(tbname varchar2) return number is
        lv_size number;
    begin
        select bytes/power(1024, 2) into lv_size 
        from user_segments where segment_name = upper(tbname);
        return lv_size;
    end get_table_size_mb;

    procedure print_varray(collection udt_varray_varchar2, description varchar2 := '') as
    begin
        dbms_output.put_line('-----' || upper(description) || '----------------------------------------');
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
    
    procedure print_table(collection udt_table_varchar2, description varchar2 := '') as
    begin
        dbms_output.put_line('-----' || upper(description) || '----------------------------------------');
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
        dbms_output.put_line('-----' || upper(description) || '----------------------------------------');
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
        dbms_output.put(rpad(description, 35));
        if collection.count > 0 then
            for i in collection.first..collection.last loop
                dbms_output.put(collection(i) || ' ');
            end loop;
            dbms_output.put_line('');
        end if;
    end;
end utils;
/