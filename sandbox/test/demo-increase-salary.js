import { increase_salary } from '../src/increase_salary.js';
import assert from 'assert';
import oracledb from 'oracledb';

const config = { user: "demo", password: "demo", connectString: "192.168.1.8:51007/freepdb1" };

describe('increase_salary', function () {
  it('By 0 percent for dept 10', async function () {
    global.session = await oracledb.getConnection(config);
    const affectedRows = await increase_salary(10, 0);
    assert(affectedRows == 3);
    session.close();
  });
});