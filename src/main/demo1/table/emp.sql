-- make script re-runnable
create table if not exists emp (
   empno    number(4, 0)       not null  constraint emp_pk primary key,
   ename    varchar2(10 char)  not null,
   job      varchar2(9 char)   not null,
   mgr      number(4, 0)                 constraint emp_emp_mgr_fk references emp,
   hiredate date               not null,
   sal      number(7, 2),
   comm     number(7, 2),
   deptno   number(2, 0)       not null  constraint emp_dept_deptno_fk references dept
);

create index if not exists emp_emp_mgr_fk_i on emp (mgr);

create index if not exists emp_dept_deptno_fk_i on emp (deptno);
