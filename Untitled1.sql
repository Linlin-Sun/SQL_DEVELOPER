explain plan for select * from v$session;
select * from table(dbms_xplan.display);