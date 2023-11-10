import { beforeAll, afterAll, describe, it, expect } from "vitest";
import oracledb from "oracledb";
import { create } from "../src/demotab.js";

const timeout = 10000;

beforeAll(async () => {
    const connectString = "192.168.1.8:51007/freepdb1";
    const dbaConfig = {
        user: "sys",
        password: "oracle",
        connectString: connectString,
        privilege: oracledb.SYSDBA
    };
    const dbaSession = await oracledb.getConnection(dbaConfig);
    await dbaSession.execute("drop user if exists demotab cascade");
    await dbaSession.execute(`
        create user demotab identified by demotab
           default tablespace users
           temporary tablespace temp
           quota unlimited on users
    `);
    await dbaSession.execute("grant db_developer_role to demotab");
    await dbaSession.execute("grant execute on javascript to public");
    await dbaSession.execute("grant create public synonym to demotab");
    const config = {
        user: "demotab",
        password: "demotab",
        connectString: connectString
    };
    global.session = await oracledb.getConnection(config);
    await dbaSession.close();
});

describe("invalid input", () => {
    // ORA-04161: Error: Invalid SQL name.
    it("throws error on invalid deptName", () => {
        expect(async () => await create("a-dept-table")).rejects.toThrowError(/invalid/i);
    });
    it("throws error on invalid empName", () => {
        expect(async () => await create("dept", "a-emp-table")).rejects.toThrowError(/invalid/i);
    });
    // ORA-00911: _: invalid character after <identifier>
    it("throws error on quoted deptName", () => {
        expect(async () => await create('"dept"', 'emp')).rejects.toThrowError(/ORA-00911/);
    });
    it("throws error on quoted empName", () => {
        expect(async () => await create("dept", '"emp"')).rejects.toThrowError(/ORA-00911/);
    });
});

describe(
    "valid input",
    () => {
        it("default (dept, emp)", async () => {
            await create();
            const dept = await global.session.execute("select * from dept order by deptno");
            expect(dept.rows).toEqual([
                [10, "ACCOUNTING", "NEW YORK"],
                [20, "RESEARCH", "DALLAS"],
                [30, "SALES", "CHICAGO"],
                [40, "OPERATIONS", "BOSTON"]
            ]);
            oracledb.fetchAsString = [oracledb.DATE];
            const emp = await global.session.execute(`
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
        it("non-default (dept2, emp2)", async () => {
            await create("dept2", "emp2");
            const dept = await global.session.execute("select * from dept minus select * from dept2");
            expect(dept.rows).toEqual([]);
            oracledb.fetchAsString = [oracledb.DATE];
            const emp = await global.session.execute("select * from emp minus select * from emp2");
            expect(emp.rows).toEqual([]);
        });
        it("fix default (dept, emp)", async () => {
            await global.session.execute(`
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
            const dept = await global.session.execute("select * from dept minus select * from dept2");
            expect(dept.rows).toEqual([[50, "utPLSQL", "Winterthur"]]);
            oracledb.fetchAsString = [oracledb.DATE];
            const emp = await global.session.execute(`
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

afterAll(async () => {
    if (global.session) {
        await global.session.close();
    }
});
