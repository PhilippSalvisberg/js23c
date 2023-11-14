create or replace mle module increase_salary_mod language javascript as
export function increase_salary(deptno, by_percent) {
   session.execute(`
      update emp
         set sal = sal + sal * :by_percent / 100
         where deptno = :deptno`, [by_percent, deptno]);
}
/
