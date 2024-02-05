import { beforeAll, afterAll, describe, it, expect } from "vitest";
import { createSessions, closeSessions, demotabSession } from "./dbconfig";
import { create } from "../src/demotab";
import sql from "sql-template-tag";

describe("TypeScript outside of the database", () => {
    const timeout = 10000;

    beforeAll(async () => {
        await createSessions();
        global.session = demotabSession;
    });

    describe("invalid input causing 'Invalid SQL name.'", () => {
        // error is thrown in JavaScript (no ORA-04161 outside of the database)
        it("should throw an error with invalid deptName", () => {
            expect(async () => await create("a-dept-table")).rejects.toThrowError(/invalid sql/i);
        });
        it("should throw an error with invalid empName", () => {
            expect(async () => await create("dept", "a-emp-table")).rejects.toThrowError(/invalid sql/i);
        });
    });

    describe("invalid input causing 'ORA-00911: _: invalid character after <identifier>'", () => {
        // error is thrown by the Oracle Database while trying to execute a SQL statement
        it("should throw an error with quoted deptName", () => {
            expect(async () => await create('"dept"')).rejects.toThrowError(/ORA-00911.+invalid/);
        });
        it("should throw an error with quoted empName", () => {
            expect(async () => await create("dept", '"emp"')).rejects.toThrowError(/ORA-00911.+invalid/);
        });
    });

    describe(
        "valid input",
        () => {
            it("should create 'dept' and 'emp' without parameters)", async () => {
                await create();
                const dept = await demotabSession.execute("select * from dept order by deptno");
                expect(dept.rows).toEqual([
                    [10, "ACCOUNTING", "NEW YORK"],
                    [20, "RESEARCH", "DALLAS"],
                    [30, "SALES", "CHICAGO"],
                    [40, "OPERATIONS", "BOSTON"]
                ]);
                const emp = await demotabSession.execute(`
                    select empno, ename, job, mgr, to_char(hiredate,'YYYY-MM-DD'), sal, comm, deptno
                    from emp
                    order by empno
                `);
                expect(emp.rows).toEqual([
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
                ]);
            });
            it("should create 'dept2' and 'emp2' with both parameters)", async () => {
                await create("dept2", "emp2");
                const dept = await demotabSession.execute("select * from dept minus select * from dept2");
                expect(dept.rows).toEqual([]);
                const emp = await demotabSession.execute("select * from emp minus select * from emp2");
                expect(emp.rows).toEqual([]);
            });
            it("should fix data in 'dept' and 'emp' after changing data and using default parameters", async () => {
                await demotabSession.execute(`
                    begin
                        delete dept where deptno = 40;
                        update dept set loc = initcap(loc);
                        insert into dept(deptno, dname, loc) values(50, 'utPLSQL', 'Winterthur');
                        delete emp where empno = 7876;
                        update emp set sal = sal * 2;
                        insert into emp(empno, ename, job, hiredate, sal, deptno)
                        values (4242, 'Salvisberg', 'Tester', date '2000-01-01', 9999, '50');
                    end;
                `);
                await create();
                const dept = await demotabSession.execute("select * from dept minus select * from dept2");
                expect(dept.rows).toEqual([[50, "utPLSQL", "Winterthur"]]);
                const emp = await demotabSession.execute(`
                    select empno, ename, job, mgr, to_char(hiredate,'YYYY-MM-DD'), sal, comm, deptno
                    from emp
                    minus
                    select empno, ename, job, mgr, to_char(hiredate,'YYYY-MM-DD'), sal, comm, deptno
                    from emp2
                `);
                expect(emp.rows).toEqual([[4242, "Salvisberg", "Tester", null, "2000-01-01", 9999, null, 50]]);
            });
        },
        timeout
    );

    describe("run SQL-template-tag", () => {
        it("should read emp of deptno 10 passed as bind", async () => {
            await create();
            const deptno: number = 10;
            const query = sql`select * from emp where deptno = ${deptno} order by sal desc`;
            const result = await demotabSession.execute(query.statement, query.values);
            // possibility that this alternative will work with oracledb driver version 6.4, see https://github.com/oracle/node-oracledb/issues/1629
            // @<disabled>ts-expect-error patch does not include the correct definitionin @types/oracledb/index.d.ts
            // const result = await demotabSession.execute(sql`select * from emp where deptno = ${deptno} order by sal desc`);
            expect(result.rows?.length).toEqual(3);
        });
    });

    afterAll(async () => {
        await closeSessions();
    });
});
