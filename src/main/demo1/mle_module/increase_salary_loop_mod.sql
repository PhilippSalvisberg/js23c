create or replace mle module increase_salary_loop_mod language javascript as   
import {increase_salary} from "increase_salary";
export function increase_salary_loop(deptno, by_percent, times) {
   for (let i=0; i<times; i++) {
      increase_salary(deptno, by_percent);
   }
}
/
