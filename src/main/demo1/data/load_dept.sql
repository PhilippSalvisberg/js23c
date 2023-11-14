-- make script re-runnable
merge into dept t
using (values 
         (10, 'ACCOUNTING', 'NEW YORK'),
         (20, 'RESEARCH', 'DALLAS'),
         (30, 'SALES', 'CHICAGO'),
         (40, 'OPERATIONS', 'BOSTON')
      ) s (deptno, dname, loc)
   on (t.deptno = s.deptno)
 when matched then
      update
         set t.dname = s.dname,
             t.loc = s.loc
 when not matched then
      insert (t.deptno, t.dname, t.loc)
      values (s.deptno, s.dname, s.loc);
commit;

begin
   sys.dbms_stats.gather_table_stats(ownname => 'demo1', tabname => 'dept');
end;
/
