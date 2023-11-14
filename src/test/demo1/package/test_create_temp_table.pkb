create or replace package body test_create_temp_table is
   procedure delete_all_temp_tables is
   begin
      for r in (select table_name from user_private_temp_tables)
      loop
         execute immediate 'drop table ' || r.table_name;
      end loop;
   end;

   procedure create_valid_temp_table_plsql is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      create_temp_table_plsql('TEST_PLSQL');
      
      -- assert
      open c_actual for
         select table_name from user_private_temp_tables;
      open c_expected for
         select 'ORA$PTT_TEST_PLSQL' as table_name;
      ut.expect(c_actual).to_equal(c_expected);
   end create_valid_temp_table_plsql;
   
   procedure create_invalid_temp_table_plsql is
   begin
      -- act
      -- ORA-44003: invalid SQL name, ORA-06512: at "SYS.DBMS_ASSERT", line 192
      create_temp_table_plsql('TEST-PLSQL');
   end create_invalid_temp_table_plsql;

   procedure create_enquoted_temp_table_plsql is
   begin
      -- act
      -- ORA-00903: invalid table name, ORA-06512: at "DEMO.CREATE_TEMP_TABLE_PLSQL", line 7
      create_temp_table_plsql('"TEST-PLSQL"');
   end create_enquoted_temp_table_plsql;

   procedure create_valid_temp_table_js is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      create_temp_table_js('TEST_JS');
      
      -- assert
      open c_actual for
         select table_name from user_private_temp_tables;
      open c_expected for
         select 'ORA$PTT_TEST_JS' as table_name;
      ut.expect(c_actual).to_equal(c_expected);
   end create_valid_temp_table_js;

   procedure create_invalid_temp_table_js is
   begin
      -- act
      -- raises ORA-04161: Database Error, ORA-44003: invalid SQL name, ORA-06512: at "SYS.DBMS_ASSERT", line 192
      create_temp_table_js('TEST-JS');
   end create_invalid_temp_table_js;

   procedure create_enquoted_temp_table_js is
   begin
      -- act
      -- raises ORA-00903: invalid table name, ORA-04171: at createTempTable (DEMO.CREATE_TEMP_TABLE_MOD:12:3)
      create_temp_table_js('"TEST-JS"');
   end create_enquoted_temp_table_js;

end test_create_temp_table;
/
