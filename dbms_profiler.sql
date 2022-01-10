create or replace procedure proc_a as
    lv_count number;
begin
    select count(*) into lv_count from user_tables, all_objects;
    for i in 1..50 loop
        proc_b;
    end loop;
end;
/
create or replace procedure proc_b as
    lv_date date;
begin
    for i in 1..50 loop
        proc_c;
        select sysdate into lv_date from dual;
    end loop;
end;
/
create or replace procedure proc_c as
    lv_avg_sal number;
begin
    for i in 1..50 loop
        select avg(salary) into lv_avg_sal from hr.employees;
    end loop;
end;
/
--truncate table plsql_profiler_data;
--delete from plsql_profiler_units;
--delete from plsql_profiler_runs;
exec dbms_profiler.start_profiler('Test_Run1');
exec proc_a;
exec dbms_profiler.stop_profiler();

select * from plsql_profiler_runs;
select * from plsql_profiler_units;
select * from plsql_profiler_data;

select plsql_profiler_runs.run_date, plsql_profiler_runs.run_comment, 
    plsql_profiler_units.unit_type, plsql_profiler_units.unit_name,
    plsql_profiler_data.line#, plsql_profiler_data.total_occur,
    plsql_profiler_data.total_time, plsql_profiler_data.min_time, 
    plsql_profiler_data.max_time, round(plsql_profiler_data.total_time/1000000000) total_time_in_sec,
    trunc((plsql_profiler_data.total_time/(sum(plsql_profiler_data.total_time) over()))*100, 2) pct_of_time_taken
from plsql_profiler_data, plsql_profiler_runs, plsql_profiler_units
where plsql_profiler_data.total_time > 0
and plsql_profiler_data.runid = plsql_profiler_runs.runid
and plsql_profiler_units.unit_number = plsql_profiler_data.unit_number
and plsql_profiler_units.runid = plsql_profiler_runs.runid
order by plsql_profiler_data.total_time desc;
