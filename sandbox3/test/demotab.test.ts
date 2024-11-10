import { beforeAll, beforeEach, afterAll, describe, it, expect } from "vitest";
import oracledb from "oracledb";
import { createSessions, closeSessions, demotabSession } from "./dbconfig";
import { create } from "../src/demotab";

describe("TypeScript outside of the database", () => {
    const timeout = 10000;

    const expectedDeptTableContent = [
        [10, "ACCOUNTING", "NEW YORK"],
        [20, "RESEARCH", "DALLAS"],
        [30, "SALES", "CHICAGO"],
        [40, "OPERATIONS", "BOSTON"]
    ];

    const expectedEmpTableContent = [
        [7369, "SMITH", "CLERK", 7902, "1980-12-17", 800, null, 20],
        [7499, "ALLEN", "SALESMAN", 7698, "1981-02-20", 1600, 300, 30],
        [7521, "WARD", "SALESMAN", 7698, "1981-02-22", 1250, 500, 30],
        [7566, "JONES", "MANAGER", 7839, "1981-04-02", 2975, null, 20],
        [7654, "MARTIN", "SALESMAN", 7698, "1981-09-28", 1250, 1400, 30],
        [7698, "BLAKE", "MANAGER", 7839, "1981-05-01", 2850, null, 30],
        [7782, "CLARK", "MANAGER", 7839, "1981-06-09", 2450, null, 10],
        [7788, "SCOTT", "ANALYST", 7566, "1987-04-19", 3000, null, 20],
        [7839, "KING", "PRESIDENT", null, "1981-11-17", 5000, null, 10],
        [7844, "TURNER", "SALESMAN", 7698, "1981-09-08", 1500, 0, 30],
        [7876, "ADAMS", "CLERK", 7788, "1987-05-23", 1100, null, 20],
        [7900, "JAMES", "CLERK", 7698, "1981-12-03", 950, null, 30],
        [7902, "FORD", "ANALYST", 7566, "1981-12-03", 3000, null, 20],
        [7934, "MILLER", "CLERK", 7782, "1982-01-23", 1300, null, 10]
    ];

    async function userTables(): Promise<oracledb.Result<unknown>> {
        return await demotabSession.execute(`
            with
               function num_rows(in_table_name in varchar2) return integer is
                  l_rows integer;
               begin
                  execute immediate 'select count(*) from ' || in_table_name
                     into l_rows;
                  return l_rows;
               end;
            select table_name, num_rows(table_name) as num_rows
              from user_tables
             order by table_name
        `);
    }

    beforeAll(async () => {
        await createSessions();
        global.session = demotabSession;
    });

    beforeEach(async () => {
        await demotabSession.execute(`
            begin
               for r in (select table_name from user_tables) loop
                  execute immediate 'drop table '
                     || r.table_name
                     || ' cascade constraints purge';
               end loop;
            end;
        `);
    });

    afterAll(async () => {
        await closeSessions();
    });

    describe("call to 'create' is idempotent", () => {
        it("should not throw an error when called twice and produce tables DEPT and EMP", async () => {
            await create();
            await create();
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 14]
            ]);
        });
    });

    describe("data correspond to SCOTT schema", () => {
        it("should produce DEPT with 4 rows and EMP with 14 rows", async () => {
            await create();
            const dept = await demotabSession.execute("select * from dept order by deptno");
            expect(dept.rows).toEqual(expectedDeptTableContent);
            const emp = await demotabSession.execute(`
                select empno, ename, job, mgr, to_char(hiredate,'YYYY-MM-DD'), sal, comm, deptno
                 from emp
                order by empno
            `);
            expect(emp.rows).toEqual(expectedEmpTableContent);
        });
    });

    describe("can pass an alternative table names", () => {
        it("should produce table D and EMP", async () => {
            await create("d");
            expect((await userTables()).rows).toEqual([
                ["D", 4],
                ["EMP", 14]
            ]);
        });
        it("should produce table DEPT and E", async () => {
            await create(undefined, "e");
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["E", 14]
            ]);
        });
        it("should produce table D and E", async () => {
            await create("d", "e");
            expect((await userTables()).rows).toEqual([
                ["D", 4],
                ["E", 14]
            ]);
        });
    });

    describe("error when using invalid SQL names (avoid SQL injection)", () => {
        it("should throw an error for invalid dept name", async () => {
            expect(async () => await create("a-dept-table")).rejects.toThrowError(/invalid sql/i);
        });
        it("should throw an error for invalid emp name", async () => {
            expect(async () => await create(undefined, "a-emp-table")).rejects.toThrowError(/invalid sql/i);
        });
    });

    describe("error when using quoted names", () => {
        it("should throw an error for quoted dept name", async () => {
            expect(async () => await create('"dept"')).rejects.toThrowError(/ORA-00911.+invalid/);
        });
        it("should throw an error for quoted emp name", async () => {
            expect(async () => await create(undefined, '"emp"')).rejects.toThrowError(/ORA-00911.+invalid/);
        });
    });

    describe("create referential integrity constraints'", () => {
        it("should produce referential integrity constraints", async () => {
            await create();
            const ri = await demotabSession.execute(`
                select a.constraint_type, a.table_name, b.table_name
                  from user_constraints a
                  left join user_constraints b
                    on b.constraint_name = a.r_constraint_name
                 where a.constraint_type in ('P', 'R')
                 order by a.constraint_type, a.table_name, b.table_name
            `);
            expect(ri.rows).toEqual([
                ["P", "DEPT", null],
                ["P", "EMP", null],
                ["R", "EMP", "DEPT"],
                ["R", "EMP", "EMP"]
            ]);
        });
    });

    describe("add missing rows", () => {
        it("should add deleted rows in DEPT table", async () => {
            await create();
            await demotabSession.execute("delete from dept where deptno = 40");
            expect((await userTables()).rows).toEqual([
                ["DEPT", 3],
                ["EMP", 14]
            ]);
            await create();
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 14]
            ]);
        });
        it("should add deleted rows in EMP table", async () => {
            await create();
            await demotabSession.execute("delete from emp where ename in ('SCOTT', 'ADAMS')");
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 12]
            ]);
            await create();
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 14]
            ]);
        });
    });

    describe("reset changed rows", () => {
        it("should reset changed rows in DEPT table", async () => {
            await create();
            await demotabSession.execute(`
                update dept
                   set deptno = case deptno when 10 then 20 when 20 then 10 else deptno end,
                       dname = initcap(dname),
                       loc = loc || 'x'
            `);
            await create();
            const dept = await demotabSession.execute("select * from dept order by deptno");
            expect(dept.rows).toEqual(expectedDeptTableContent);
        });
        it("should reset changed rows in EMP table", async () => {
            await create();
            await demotabSession.execute(`
                update emp
                   set empno = case empno when 7369 then 7499 when 7499 then 7369 else empno end,
                       ename = initcap(ename),
                       job = initcap(job),
                       mgr = 7839,
                       hiredate = hiredate-1,
                       sal = sal * 2,
                       comm = sal / 3,
                       deptno = 40
            `);
            await create();
            const emp = await demotabSession.execute(`
                select empno, ename, job, mgr, to_char(hiredate,'YYYY-MM-DD'), sal, comm, deptno
                 from emp
                order by empno
            `);
            expect(emp.rows).toEqual(expectedEmpTableContent);
        });
    });

    describe("keep rows with unknown primary key", () => {
        it("should keep new rows in DEPT table", async () => {
            await create();
            await demotabSession.execute("insert into dept (deptno, dname, loc) values (50, 'Test', 'Nürnberg')");
            expect((await userTables()).rows).toEqual([
                ["DEPT", 5],
                ["EMP", 14]
            ]);
            await create();
            expect((await userTables()).rows).toEqual([
                ["DEPT", 5],
                ["EMP", 14]
            ]);
        });
        it("should add deleted rows in EMP table", async () => {
            await create();
            await demotabSession.execute(`
                insert into emp (empno, ename, job, mgr, hiredate, sal, comm, deptno)
                values (1, 'MEYER', 'CLERK', 7839, DATE '2024-11-19', 4500, 250, 40)
            `);
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 15]
            ]);
            await create();
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 15]
            ]);
        });
    });
});
