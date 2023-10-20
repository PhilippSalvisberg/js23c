create or replace package body test_increase_salary is
   procedure increase_salary_moderate is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      increase_salary(in_deptno => 10, in_by_percent => 5);
      
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
   end increase_salary_moderate;
   
   procedure increase_salary_out_of_scale is
   begin
      -- act
      -- raises ORA-01438: value 100000 greater than specified precision (7, 2) for column 
      increase_salary(in_deptno => 10, in_by_percent => 1900);
   end increase_salary_out_of_scale;
end test_increase_salary;
/
