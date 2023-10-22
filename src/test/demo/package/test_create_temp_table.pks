create or replace package test_create_temp_table is
   --%suite
   --%suitepath(all)
   
   --%beforeeach
   --%aftereach
   procedure delete_all_temp_tables;
   
   --%context(plsql)

   --%test
   procedure create_valid_temp_table_plsql;

   --%test
   --%throws(-44004)
   procedure create_invalid_temp_table_plsql;

   --%endcontext
   
   --%context(js)

   --%test
   procedure create_valid_temp_table_js;

   --%test
   --%throws(-4161)
   procedure create_invalid_temp_table_js;

   --%endcontext
end test_create_temp_table;
/
