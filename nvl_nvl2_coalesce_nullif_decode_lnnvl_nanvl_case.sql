select nvl('R1', 'R2'), nvl(null, 'R2'), nvl(null, null) from dual;

select nvl2('P1', 'P2', 'P3'), nvl2(NULL, 'P2', 'P3'), nvl2(NULL, NULL, 'P3'), nvl2(NULL, NULL, NULL) from dual;

select coalesce('P1', 'P2', 'P3'), coalesce(NULL, 'P2', 'P3'), coalesce(NULL, NULL, 'P3'), coalesce(NULL, NULL, NULL) from dual;

select nullif('A1', 'A1'), nullif('A1', 'A2') from dual;
select nullif(1, '1') from dual; -- ORA-00932: inconsistent datatypes: expected NUMBER got CHAR
select nullif(NULL, 'P2') from dual; -- ORA-00932: inconsistent datatypes: expected - got CHAR
select nullif(NULL, NULL) from dual; -- ORA-00932: inconsistent datatypes: expected - got CHAR

select count(*) as cnt_total from hr.employees; -- 107
select count(*) as cnt_not_null from hr.employees where commission_pct is not null; -- 35
select count(*) as cnt_null from hr.employees where commission_pct is null; -- 72
select count(*) as cnt_less_than from hr.employees where commission_pct < .2; -- 11
select count(*) as cnt_not_less_than from hr.employees where lnnvl(commission_pct < .2); -- 96
select count(*) as cnt_greater_than from hr.employees where commission_pct >= .2; -- 24
select count(*) as cnt_not_greater_than from hr.employees where lnnvl(commission_pct >= .2); -- 83

select nanvl(2, 1), nanvl(BINARY_FLOAT_NAN, 1) from dual;

------------------------- decode vs case --------------------------
-- decode is less strict with datatype, case is more strict
select decode(2, '1', 'One', '2', 'Two', '3', 'Three', 'None') from dual;
select decode('2', '1', 'One', '2', 'Two', '3', 'Three', 'None') from dual; 
select decode('2', '1', 'One', 2, 'Two', '3', 'Three', 'None') from dual; 

select case '2' when '1' then 'One' when '2' then 'Two' when 3 then 'Three' else 'None' end as result from dual; 
select case 2 when '1' then 'One' when '2' then 'Two' when '3' then 'Three' else 'None' end as result from dual; 
select case '2' when '1' then 'One' when '2' then 'Two' when '3' then 'Three' else 'None' end as result from dual;

-- decode can only be used in a select statement. case can be used in select statement, expression or stand alone block
set serveroutput on
declare
    lv_result varchar2(100);
    lv_input varchar(1) := 'P';
begin
--     select decode(lv_input, 'P', 'PASS', 'F', 'FAIL', 'INPUT IS NOT IN P or F') into lv_result from dual;
--     select case lv_input when 'P' then 'PASS' when 'F' then 'FAIL' else 'INPUT IS NOT IN P or F' end case into lv_result from dual;
--     lv_result := case lv_input when 'P' then 'PASS' when 'F' then 'FAIL' else 'INPUT IS NOT IN P or F' end;
     lv_result := decode(lv_input, 'P', 'PASS', 'F', 'FAIL', 'INPUT IS NOT IN P or F');
--    case lv_input
--        when 'P' then lv_result := 'PASS';
--        when 'F' then lv_result := 'FAIL';
--        else lv_result := 'INPUT IS NOT IN P or F';
--    end case;
    dbms_output.put_line(lv_result);
end;
/

