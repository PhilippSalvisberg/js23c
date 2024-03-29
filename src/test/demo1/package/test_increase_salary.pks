create or replace package test_increase_salary is
   --%suite
   --%suitepath(all)
   
   --%context(plsql)

   --%test
   procedure increase_salary_plsql_moderate;

   --%test
   --%throws(-1438)
   procedure increase_salary_plsql_out_of_scale;
   
   --%endcontext
   
   --%context(dplsql)

   --%test
   procedure increase_salary_dplsql_moderate;

   --%test
   --%throws(-1438)
   procedure increase_salary_dplsql_out_of_scale;
   
   --%endcontext

   --%context(js)

   --%test
   procedure increase_salary_js_moderate;

   --%test
   --%throws(-1438)
   procedure increase_salary_js_out_of_scale;
   
   --%endcontext

   --%context(jsloop)

   --%test
   procedure increase_salary_jsloop_moderate;

   --%test
   --%throws(-1438)
   procedure increase_salary_jsloop_out_of_scale;
   
   --%endcontext
end test_increase_salary;
/
