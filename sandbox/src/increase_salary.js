//import oracledb from "mle-js-oracledb";
import oracledb from "oracledb";
import { simpleSqlName } from "sql-assert";

export async function increase_salary(deptno, by_percent) {
    const config = { user: "demo", password: "demo", connectString: "192.168.1.8:51007/freepdb1" };
    const conn = await oracledb.getConnection(config);
    // Cannot use sql-template-tag since they use either ? or $ as bind variables.
    // Both variants are not supported by oracledb. No plans by Oracle to support them.
    // See https://github.com/oracle/node-oracledb/issues/109
    const stmt = `
        update ${simpleSqlName("emp")}
           set sal = sal + sal * :by_percent / 100
         where deptno = :deptno`;
    const result = await conn.execute(stmt, [by_percent, deptno]);
    return result.rowsAffected;
}