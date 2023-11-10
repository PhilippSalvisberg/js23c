import { simpleSqlName } from "sql-assert";

// global variable for default connection in the database
declare const session: any;

/**
 * Creates demo tables with initial data.
 *
 * @param [deptName="dept"] name of the dept table.
 * @param [empName="emp"] name of the emp table.
 * @returns {Promise<void>}.
 * @memberof ProfileService
 */
export async function create(deptName: string = "dept", empName: string = "emp"): Promise<void> {
    const dept = simpleSqlName(deptName);
    const emp = simpleSqlName(empName);
    await session.execute(`
        create table if not exists ${dept} (
           deptno number(2, 0)      not null constraint ${dept}_pk primary key,
           dname  varchar2(14 char) not null,
           loc    varchar2(13 char) not null
        )
    `);
    await session.execute(`
        merge into ${dept} t
        using (values 
                 (10, 'ACCOUNTING', 'NEW YORK'),
                 (20, 'RESEARCH',   'DALLAS'),
                 (30, 'SALES',      'CHICAGO'),
                 (40, 'OPERATIONS', 'BOSTON')
              ) s (deptno, dname, loc)
           on (t.deptno = s.deptno)
         when matched then
              update
                 set t.dname = s.dname,
                     t.loc = s.loc
         when not matched then
              insert (t.deptno, t.dname, t.loc)
              values (s.deptno, s.dname, s.loc)
    `);
    await session.execute(`
        create table if not exists ${emp} (
            empno    number(4, 0)      not null  constraint ${emp}_pk primary key,
            ename    varchar2(10 char) not null,
            job      varchar2(9 char)  not null,
            mgr      number(4, 0)                constraint ${emp}_mgr_fk references ${emp},
            hiredate date              not null,
            sal      number(7, 2),
            comm     number(7, 2),
            deptno   number(2, 0)      not null  constraint ${emp}_deptno_fk references ${dept}
        )
    `);
    await session.execute(`create index if not exists ${emp}_mgr_fk_i on ${emp} (mgr)`);
    await session.execute(`create index if not exists ${emp}_deptno_fk_i on ${emp} (deptno)`);
    await session.execute(`alter table ${emp} disable constraint ${emp}_mgr_fk`);
    await session.execute(`
        merge into ${emp} t
        using (values
                 (7839, 'KING',   'PRESIDENT', null, date '1981-11-17', 5000, null, 10),
                 (7566, 'JONES',  'MANAGER',   7839, date '1981-04-02', 2975, null, 20),
                 (7698, 'BLAKE',  'MANAGER',   7839, date '1981-05-01', 2850, null, 30),
                 (7782, 'CLARK',  'MANAGER',   7839, date '1981-06-09', 2450, null, 10),
                 (7788, 'SCOTT',  'ANALYST',   7566, date '1987-04-19', 3000, null, 20),
                 (7902, 'FORD',   'ANALYST',   7566, date '1981-12-03', 3000, null, 20),
                 (7499, 'ALLEN',  'SALESMAN',  7698, date '1981-02-20', 1600,  300, 30),
                 (7521, 'WARD',   'SALESMAN',  7698, date '1981-02-22', 1250,  500, 30),
                 (7654, 'MARTIN', 'SALESMAN',  7698, date '1981-09-28', 1250, 1400, 30),
                 (7844, 'TURNER', 'SALESMAN',  7698, date '1981-09-08', 1500,    0, 30),
                 (7900, 'JAMES',  'CLERK',     7698, date '1981-12-03',  950, null, 30),
                 (7934, 'MILLER', 'CLERK',     7782, date '1982-01-23', 1300, null, 10),
                 (7369, 'SMITH',  'CLERK',     7902, date '1980-12-17',  800, null, 20),
                 (7876, 'ADAMS',  'CLERK',     7788, date '1987-05-23', 1100, null, 20)                        
              ) s (empno, ename, job, mgr, hiredate, sal, comm, deptno)
           on (t.empno = s.empno)
         when matched then
              update
                 set t.ename = s.ename,
                     t.job = s.job,
                     t.mgr = s.mgr,
                     t.hiredate = s.hiredate,
                     t.sal = s.sal,
                     t.comm = s.comm,
                     t.deptno = s.deptno
         when not matched then
              insert (t.empno, t.ename, t.job, t.mgr, t.hiredate, t.sal, t.comm, t.deptno)
              values (s.empno, s.ename, s.job, s.mgr, s.hiredate, s.sal, s.comm, s.deptno)
    `);
    await session.execute(`alter table ${emp} enable constraint ${emp}_mgr_fk`);
}
