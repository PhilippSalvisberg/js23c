import sql from "sql-template-tag";
import assert from 'assert';

describe('sql-template-tag', function () {
  it('show binds', function () {
    const v1 = 'Value 1';
    const v2 = 'Value 2';
    const query = sql`select * from t1 where c1 = ${v1} and c2 = ${v2}`;
    assert(query.sql == "select * from t1 where c1 = ? and c2 = ?");
    assert(query.text == "select * from t1 where c1 = $1 and c2 = $2");
    assert(query.values.toString() == ['Value 1', 'Value 2'].toString());
    assert(query.strings.toString() == ['select * from t1 where c1 = ', ' and c2 = ', ''].toString());
  });
});