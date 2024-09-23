-- Example of MLE post-execution debugging
-- see https://docs.oracle.com/en/database/oracle/oracle-database/23/mlejs/post-execution-debugging.html#GUID-0BEAABB3-5700-44BE-B9D3-28E7EA2E24EC
set serveroutput on size unlimited
declare
   co_breakpoints constant json := json(q'~
{
  "version": "1.0",
  "debugpoints": [
    {
      "at": {"name": "CREATE_TEMP_TABLE_MOD", "line": 5},
      "actions": [{"type": "watch", "id": "tableName"}],
      "condition": "tableName.includes('-')"
    },
    {
      "at": {"name": "CREATE_TEMP_TABLE_MOD", "line": 10},
      "actions": [{"type": "snapshot"}]
    }
  ]
}
~');
   l_sink         blob;
   l_output       json;
begin
   sys.dbms_lob.createtemporary(lob_loc => l_sink, cache => false, dur => sys.dbms_lob.call);
   sys.dbms_mle.enable_debugging(debugspec => co_breakpoints, sink => l_sink);
   ut.run('DEMO:all.test_create_temp_table.nested_context_#2'); -- js context
   l_output := sys.dbms_mle.parse_debug_output(l_sink);
   sys.dbms_output.put_line('MLE debug output: '
      || chr(10)
      || json_serialize(l_output returning clob pretty));
   sys.dbms_mle.disable_debugging();
end;
/
