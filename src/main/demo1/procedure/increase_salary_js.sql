create or replace procedure increase_salary_js(
   in_deptno     in number,
   in_by_percent in number
) as mle module increase_salary_mod signature 'increase_salary(number, number)';
/
