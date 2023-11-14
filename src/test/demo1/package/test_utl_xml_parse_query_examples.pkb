create or replace package body test_utl_xml_parse_query_examples is
   procedure extract_table_name is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act and assert
      open c_actual for
         select id,
                t.statement,
                t.parse_tree.extract('//FROM_ITEM/TABLE[1]/text()').getstringval() as table_name
           from utl_xml_parse_query_examples t;
           
      open c_expected for
         with
            expectations (id, statement, table_name) as (values
               (1, 'select ename, sal from emp where sal >= 3000 order by sal desc', 'EMP'),
               (2, q'[insert into dept(deptno, dname, loc) values (50, 'Oracle Labs', 'Zurich')]', 'DEPT'),
               (3, 'update emp set sal = sal * 2 where sal < 3000', 'EMP'),
               (4, 'delete from dept where deptno = 50', 'DEPT')
            )
         select * from expectations;
      ut.expect(c_actual).to_equal(c_expected).join_by('ID');
   end extract_table_name;
end test_utl_xml_parse_query_examples;
/
