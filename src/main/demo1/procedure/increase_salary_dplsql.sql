create or replace procedure increase_salary_dplsql(
   in_deptno     in number,
   in_by_percent in number
) is
begin
   execute immediate '
      update emp
         set sal = sal + sal * :by_percent / 100
      where deptno = :deptno' using in_by_percent, in_deptno;
end increase_salary_dplsql;
/
