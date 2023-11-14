create or replace procedure increase_salary_jsloop(
   in_deptno     in number,
   in_by_percent in number,
   in_times      in number
) as mle module increase_salary_loop_mod env demo_env signature 'increase_salary_loop(number, number, number)';
/
