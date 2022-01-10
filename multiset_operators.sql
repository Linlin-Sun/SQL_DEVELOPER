declare
    nt_1 utils.udt_table_number := utils.udt_table_number(1, 1, 2, 2, 3, 4, 5, 8, 9, 9);
    nt_2 utils.udt_table_number := utils.udt_table_number(9, 1, 1, 2, 2, 6, 7);
    nt_3 utils.udt_table_number := utils.udt_table_number();
begin
    utils.print_table_number(nt_1, 'nt_1');
    utils.print_table_number(nt_2, 'nt_2');
    
    nt_3 := nt_1 multiset union nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset union');
    nt_3 := nt_1 multiset union all nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset union all');
    nt_3 := nt_1 multiset union distinct nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset union distinct');
    
    nt_3 := nt_1 multiset intersect nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset intersect');
    nt_3 := nt_1 multiset intersect all nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset intersect all');
    nt_3 := nt_1 multiset intersect distinct nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset intersect distinct');
    
    nt_3 := nt_1 multiset except nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset except');
    nt_3 := nt_1 multiset except all nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset except all');
    nt_3 := nt_1 multiset except distinct nt_2;
    utils.print_table_number(nt_3, 'nt_1 multiset except distinct');
end;
/

declare
    nt_1 utils.udt_table_varchar2 := utils.udt_table_varchar2('A', 'B', 'C', 'C', 'D', 'E', 'E', 'F');
    nt_2 utils.udt_table_varchar2 := utils.udt_table_varchar2('A', 'B', 'C', 'D', 'D', 'E', 'E', 'G');
    nt_3 utils.udt_table_varchar2 := utils.udt_table_varchar2();
begin
    utils.print_table_varchar2(nt_1, 'nt_1');
    utils.print_table_varchar2(nt_2, 'nt_2');
    
    nt_3 := nt_1 multiset union nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset union');
    nt_3 := nt_1 multiset union all nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset union all');
    nt_3 := nt_1 multiset union distinct nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset union distinct');
    
    nt_3 := nt_1 multiset intersect nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset intersect');
    nt_3 := nt_1 multiset intersect all nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset intersect all');
    nt_3 := nt_1 multiset intersect distinct nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset intersect distinct');
    
    nt_3 := nt_1 multiset except nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset except');
    nt_3 := nt_1 multiset except all nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset except all');
    nt_3 := nt_1 multiset except distinct nt_2;
    utils.print_table_varchar2(nt_3, 'nt_1 multiset except distinct');
end;
/