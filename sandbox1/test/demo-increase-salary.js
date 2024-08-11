import { increase_salary } from '../src/increase_salary.js';
import assert from 'assert';
import oracledb from 'oracledb';

before(async () => {
  const config = { user: "demo1", password: "demo1", connectString: "192.168.1.8:51008/freepdb1" };
  global.session = await oracledb.getConnection(config);
})

describe('increase_salary', function () {
  it('should affect 3 rows when increasing salary of emps in deptno 10', async function () {
    const affectedRows = await increase_salary(10, 0);
    assert(affectedRows == 3);
  });
});

after(async () => {
  await session.close();
})
