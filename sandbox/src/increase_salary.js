//import oracledb from 'mle-js-oracledb';
import oracledb from 'oracledb';

export async function increase_salary(deptno, by_percent) {
    let config = {user: "demo", password: "demo", connectString: "192.168.1.8:51007/freepdb1"};
    let conn = await oracledb.getConnection(config);
    let result = await conn.execute(`
        update emp
        set sal = sal + sal * :by_percent / 100
        where deptno = :deptno`, 
        [by_percent, deptno]
    );
    return result.rowsAffected;
}