create or replace package utils as
    type udt_table_varchar2 is table of varchar2(30);
    type udt_dictionary_varchar2 is table of varchar2(30) index by varchar2(30);
    
    type udt_table_number is table of number;
    
    function get_table_size_mb(tbname varchar2) return number;
    function get_boolean_str(bool_var boolean) return varchar2;
    
    procedure drop_objects;
    
    procedure print_varray_varchar2(collection sys.odcivarchar2list, description varchar2 := '');
    procedure print_table_varchar2(collection udt_table_varchar2, description varchar2 := '');
    procedure print_dictionary(collection udt_dictionary_varchar2, description varchar2 := '');
    
    procedure print_table_number(collection udt_table_number, description varchar2 := '');
    
    scope_test_var varchar2(50) := 'OUTERBLOCK';
    procedure scope_test_1;
    procedure scope_test_2;
end utils;
/