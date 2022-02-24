load data
infile 'load_clob.txt'
  into table file_content_tab
  fields terminated by '.'
  (s_no,
    file_name char(100),
    file_data LOBFILE(file_name) terminated by EOF)