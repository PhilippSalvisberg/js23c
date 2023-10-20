create or replace procedure increase_salary(
   in_deptno     in number,
   in_by_percent in number
) is
begin
   update emp
      set sal = sal + sal * in_by_percent / 100
    where deptno = in_deptno;
end;
/
