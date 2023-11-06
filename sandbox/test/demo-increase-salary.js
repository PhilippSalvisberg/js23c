import { increase_salary } from '../src/increase_salary.js';
import assert from 'assert';
import oracledb from 'oracledb';

before(async () => {  
  const config = { user: "demo", password: "demo", connectString: "192.168.1.8:51007/freepdb1" };
  global.session = await oracledb.getConnection(config);
})

describe('increase_salary', function () {
  it('By 0 percent for dept 10', async function () {
    const affectedRows = await increase_salary(10, 0);
    assert(affectedRows == 3);
  });
});

after(async () => {  
  await session.close();
})
