-- Remove leading and trailing spaces by default if character is not specified
select trim(' ttest '), length(trim(' test ')) from dual;
select trim('t' from 'ttest') from dual;

-- Remove character from leading/trailing/both side
select trim(leading from ' ttest '), length(trim(leading from ' test ')) from dual;
select trim(leading 't' from 'ttest') from dual;
select trim(trailing 't' from 'ttest') from dual;
select trim(both 't' from 'ttest') from dual;

-- Remove 0 from a DATE column
select hire_date, trim(0 from hire_date) from hr.employees;
