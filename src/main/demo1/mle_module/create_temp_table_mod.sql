-- based on https://docs.oracle.com/en/database/oracle/oracle-database/23/mlejs/mle-security.html#GUID-EF41B6A3-1984-44CE-8D5C-D70B5CEA7275__GUID-2460F806-0860-4FA4-951B-3B403FB805EC
-- changed module name from dbms_assert_module to create_temp_table_mod
create or replace mle module create_temp_table_mod language javascript as

import { simpleSqlName } from "sql-assert";

export function createTempTable(tableName) {
  // may throw a "ORA-04161: Database Error" without reference to this module (bad)
  const result = session.execute(
    `select dbms_assert.simple_sql_name(:tableName) as tab`, 
    [tableName]
  );

  session.execute(
    `create private temporary table ora\$ptt_${result.rows[0].TAB} (id number)`
  );
}

export function createTempTable2(tableName) {
  // may throw a "ORA-44003: invalid SQL name" with reference to this module (good)
  const result = session.execute(
    `begin
      :tab := dbms_assert.simple_sql_name(:tableName);
     end;`,
    {tab: {dir: oracledb.BIND_OUT}, tableName}
  );

  session.execute(
    `create private temporary table ora\$ptt_${result.outBinds.tab} (id number)`
  );
}

export function createTempTable3(tableName) {
  // may throw a "ORA-04161: Error: Invalid SQL name." without reference to this module, but to sql-assert
  session.execute(
    `create private temporary table ora\$ptt_${simpleSqlName(tableName)} (id number)`
  );
}
/
