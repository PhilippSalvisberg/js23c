create or replace package body test_increase_salary is
   procedure increase_salary_plsql_moderate is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      increase_salary_plsql(in_deptno => 10, in_by_percent => 5);
      
      -- assert
      open c_actual for
         select empno, ename, sal
           from emp
          where deptno = 10;
      open c_expected for
         with
            original (empno, ename, sal) as (values
               (7839, 'KING', 5000),
               (7782, 'CLARK', 2450),
               (7934, 'MILLER', 1300)
            )
         select empno, ename, sal*1.05 as sal
           from original;
      ut.expect(c_actual).to_equal(c_expected);
   end increase_salary_plsql_moderate;
   
   procedure increase_salary_plsql_out_of_scale is
   begin
      -- act
      -- raises ORA-01438: value 100000 greater than specified precision (7, 2) for column 
      increase_salary_plsql(in_deptno => 10, in_by_percent => 1900);
   end increase_salary_plsql_out_of_scale;

   procedure increase_salary_dplsql_moderate is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      increase_salary_dplsql(in_deptno => 10, in_by_percent => 7);
      
      -- assert
      open c_actual for
         select empno, ename, sal
           from emp
          where deptno = 10;
      open c_expected for
         with
            original (empno, ename, sal) as (values
               (7839, 'KING', 5000),
               (7782, 'CLARK', 2450),
               (7934, 'MILLER', 1300)
            )
         select empno, ename, sal*1.07 as sal
           from original;
      ut.expect(c_actual).to_equal(c_expected);
   end increase_salary_dplsql_moderate;
   
   procedure increase_salary_dplsql_out_of_scale is
   begin
      -- act
      -- raises ORA-01438: value 100150 greater than specified precision (7, 2) for column
      increase_salary_dplsql(in_deptno => 10, in_by_percent => 1903);
   end increase_salary_dplsql_out_of_scale;

   procedure increase_salary_js_moderate is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      increase_salary_js(in_deptno => 10, in_by_percent => 6);
      
      -- assert
      open c_actual for
         select empno, ename, sal
           from emp
          where deptno = 10;
      open c_expected for
         with
            original (empno, ename, sal) as (values
               (7839, 'KING', 5000),
               (7782, 'CLARK', 2450),
               (7934, 'MILLER', 1300)
            )
         select empno, ename, sal*1.06 as sal
           from original;
      ut.expect(c_actual).to_equal(c_expected);
   end increase_salary_js_moderate;

   procedure increase_salary_js_out_of_scale is
   begin
      -- act
      -- raises ORA-01438: value 100050 greater than specified precision (7, 2) for column 
      increase_salary_js(in_deptno => 10, in_by_percent => 1901);
   end increase_salary_js_out_of_scale;
end test_increase_salary;
/
