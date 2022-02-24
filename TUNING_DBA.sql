select * from V$SESSION_LONGOPS;
-- What are the queries that are running? 
select ss.sid, ss.username, optimizer_mode, hash_value, address, cpu_time, elapsed_time, sql_text
from v$sqlarea sa, v$session ss
where ss.sql_hash_value = sa.hash_value and ss.sql_address = sa.address and ss.username is not null;

-- Get the rows fetched, if there is difference it means processing is happening
select sid, sn.name, ss.value from v$sesstat ss, v$statname sn
where ss.statistic# = sn.statistic# and sid = &sid and ss.value != 0 and sn.name like '%row%';


-- 1. Analyse the statistics
exec fnd_stats.gather_schema_statistics('ALL');

-- 2. Gather the dictionary stats
exec dbms_stats.gather_dictionary_stats;
exec dbms_stats.gather_fixed_objects_stats;
exec dbms_stats.gather_schema_stats('SYS', method_opt=>'for all columns size 1', degree=>30, estimate_percent=>100, cascade=>true);
exec dbms_stats.gather_system_stats('NOWORKLOAD');
-- 3. Table move and table shrink
-- 4. Rebuild index
-- 5. Profiling



