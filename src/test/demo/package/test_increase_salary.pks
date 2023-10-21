create or replace package test_increase_salary is
   --%suite
   --%suitepath(all)

   --%test
   procedure increase_salary_plsql_moderate;

   --%test
   --%throws(-1438)
   procedure increase_salary_plsql_out_of_scale;
end test_increase_salary;
/
