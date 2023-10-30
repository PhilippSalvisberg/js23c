-- based on https://docs.oracle.com/en/database/oracle/oracle-database/23/mlejs/mle-security.html#GUID-EF41B6A3-1984-44CE-8D5C-D70B5CEA7275__GUID-2460F806-0860-4FA4-951B-3B403FB805EC
-- changed module name from dbms_assert_module to create_temp_table_mod
create or replace mle module create_temp_table_mod language javascript as

import oracledb from "mle-js-oracledb";

export function createTempTable(tableName) {
  const conn = oracledb.defaultConnection();

  // may throw a "ORA-04161: Database Error" without reference to this module (bad)
  const result = conn.execute(
    `select dbms_assert.simple_sql_name(:tableName) as tab`, 
    [tableName]
  );

  conn.execute(
    `create private temporary table ora\$ptt_${result.rows[0].TAB} (id number)`
  );
}

export function createTempTable2(tableName) {
  const conn = oracledb.defaultConnection();

  // may throw a "ORA-44003: invalid SQL name" with reference to this module (good)
  const result = conn.execute(
    `begin
      :tab := dbms_assert.simple_sql_name(:tableName);
     end;`,
    {tab: {dir: oracledb.BIND_OUT}, tableName}
  );

  conn.execute(
    `create private temporary table ora\$ptt_${result.outBinds.tab} (id number)`
  );
}
/
