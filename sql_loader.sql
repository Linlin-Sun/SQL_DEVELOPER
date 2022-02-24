-- CLOB 
    -- to load huge content of text info from input files
    -- easy to automate (using scripts)
    -- mainly for text loading (not for xml, csv or json data load)
    -- not for loading binary content (BLOB can be used instead)

create table file_content_tab (
    s_no number,
    file_name varchar2(100), -- stores the file name
    file_data clob -- stores the file content
);

select * from file_content_tab;

git bash window: sqlldr local/local@//localhost:1539/orclpdb.lan control=load_clob.ctl
load_clob.ctl:
load data
infile 'load_clob.txt'
  into table file_content_tab
  fields terminated by '.'
  (s_no,
    file_name char(100),
    file_data LOBFILE(file_name) terminated by EOF)
load_clob.txt:
1.1_load_clob.txt
2.2_load_clob.txt
3.3_load_clob.txt
