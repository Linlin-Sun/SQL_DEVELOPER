--------------------------- profiler setup ---------------------------------
drop table plsql_profiler_data cascade constraints;
drop table plsql_profiler_units cascade constraints;
drop table plsql_profiler_runs cascade constraints;

drop sequence plsql_profiler_runnumber;

create table plsql_profiler_runs
(
  runid           number primary key,  -- unique run identifier,
                                       -- from plsql_profiler_runnumber
  related_run     number,              -- runid of related run (for client/
                                       --     server correlation)
  run_owner       varchar2(128),       -- user who started run
  run_date        date,                -- start time of run
  run_comment     varchar2(2047),      -- user provided comment for this run
  run_total_time  number,              -- elapsed time for this run
  run_system_info varchar2(2047),      -- currently unused
  run_comment1    varchar2(2047),      -- additional comment
  spare1          varchar2(256)        -- unused
);

comment on table plsql_profiler_runs is
        'Run-specific information for the PL/SQL profiler';

create table plsql_profiler_units
(
  runid              number references plsql_profiler_runs,
  unit_number        number,           -- internally generated library unit #
  unit_type          varchar2(128),    -- library unit type
  unit_owner         varchar2(128),    -- library unit owner name
  unit_name          varchar2(128),    -- library unit name
  -- timestamp on library unit, can be used to detect changes to
  -- unit between runs
  unit_timestamp     date,
  total_time         number DEFAULT 0 NOT NULL,
  spare1             number,           -- unused
  spare2             number,           -- unused
  --  
  primary key (runid, unit_number)
);

comment on table plsql_profiler_units is 
        'Information about each library unit in a run';

create table plsql_profiler_data
(
  runid           number,           -- unique (generated) run identifier
  unit_number     number,           -- internally generated library unit #
  line#           number not null,  -- line number in unit
  total_occur     number,           -- number of times line was executed
  total_time      number,           -- total time spent executing line
  min_time        number,           -- minimum execution time for this line
  max_time        number,           -- maximum execution time for this line
  spare1          number,           -- unused
  spare2          number,           -- unused
  spare3          number,           -- unused
  spare4          number,           -- unused
  --
  primary key (runid, unit_number, line#),
  foreign key (runid, unit_number) references plsql_profiler_units
);

comment on table plsql_profiler_data is 
        'Accumulated data from all profiler runs';

create sequence plsql_profiler_runnumber start with 1 nocache;

------------------------------------------------------------------------------------

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
