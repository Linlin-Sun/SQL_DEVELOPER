desc sys.dual;
select * from dual;
select sqrt(100) from dual;
select user from dual;
select substr('welcome', 1, 2) from dual;
select * from all_sequences;
select mdsys.SAMPLE_SEQ.nextval from dual;
select mdsys.SAMPLE_SEQ.currval from dual;
-- use decode(), connect by with dual table
select rownum || ' * 5 = ' || rownum*5 from dual connect by level <= 5;
select rownum, substr('WELCOME', 1, rownum), substr('WELCOME', rownum) from dual connect by level <= length('WELCOME')
