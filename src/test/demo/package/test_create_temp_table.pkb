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
      -- raises ORA-20501: 'TEST-PLSQL' is not a valid table name
      create_temp_table_plsql('TEST-PLSQL');
   end create_invalid_temp_table_plsql;


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
      -- raises ORA-04161: 'TEST-JS' is not a valid table name
      create_temp_table_js('TEST-JS');
   end create_invalid_temp_table_js;
end test_create_temp_table;
/