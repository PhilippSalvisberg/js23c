import { simpleSqlName } from "sql-assert";

export async function increase_salary(deptno, by_percent) {
    // Cannot use sql-template-tag since they use either ? or $ as bind variables.
    // Both variants are not supported by oracledb. No plans by Oracle to support them.
    // See https://github.com/oracle/node-oracledb/issues/109
    const stmt = `
        update ${simpleSqlName("emp")}
           set sal = sal + sal * :by_percent / 100
         where deptno = :deptno`;
    const result = await session.execute(stmt, [by_percent, deptno]);
    return result.rowsAffected;
}
