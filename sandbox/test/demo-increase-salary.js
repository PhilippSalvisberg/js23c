import { increase_salary } from '../src/increase_salary.js';
import assert from 'assert';

describe('increase_salary', function () {
  it('By 0 percent for dept 10', async function () {
    const affectedRows = await increase_salary(10, 0);
    assert(affectedRows == 3);
  });
});