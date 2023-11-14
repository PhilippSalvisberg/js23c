-- make script re-runnable
create table if not exists dept (
   deptno number(2, 0) not null constraint dept_pk primary key,
   dname  varchar2(14 char) not null,
   loc    varchar2(13 char) not null
);
