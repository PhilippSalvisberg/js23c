create or replace package test_exec_api is
   --%suite
   --%suitepath(all)
   
   --%beforeall
   procedure create_log_entry;

   --%beforeeach
   procedure set_last_log_id;

   --%test
   procedure exec_default;
   
   --%test
   procedure exec_invalid;

   --%test
   procedure exec_with_loop;
end test_exec_api;
/
