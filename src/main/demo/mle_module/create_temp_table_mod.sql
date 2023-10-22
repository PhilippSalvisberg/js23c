-- based on https://docs.oracle.com/en/database/oracle/oracle-database/23/mlejs/mle-security.html#GUID-EF41B6A3-1984-44CE-8D5C-D70B5CEA7275__GUID-2460F806-0860-4FA4-951B-3B403FB805EC
-- changed module name from dbms_assert_module to create_temp_table_mod
create or replace mle module create_temp_table_mod language javascript as

import oracledb from "mle-js-oracledb";

export function createTempTable(tableName) {
  const conn = oracledb.defaultConnection();
  let result; 
  let validTableName; 

  result = conn.execute(
    `select dbms_assert.qualified_sql_name(:tableName) as tab`, 
    [tableName]
  );
  validTableName = result.rows[0].TAB;

  conn.execute(
    `create private temporary table ora\$ptt_${validTableName} (id number)`
  );
}
/
