create or replace package body test_exec_api is
   g_last_log_id exec_log.log_id%type;

   procedure create_log_entry is
   begin
      exec_api.exec_stmt;
   end;

   procedure set_last_log_id is
   begin
      select max(log_id)
        into g_last_log_id
        from exec_log;
   end set_last_log_id;

   procedure exec_default is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      exec_api.exec_stmt;
      
      -- assert
      open c_actual for
         select scenario,
                run,
                no_of_calls,
                cast(stmt as varchar2(100 char)) as stmt,
                cast(error as varchar2(4000 byte)) as error
           from exec_log
          where log_id = g_last_log_id + 1;
      open c_expected for
         select 'test' as scenario,
                1 as run,
                1 as no_of_calls,
                'begin null; end;' as stmt,
                null as error;
      ut.expect(c_actual).to_equal(c_expected);
   end exec_default;

   procedure exec_invalid is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      <<trap>>
      begin
         exec_api.exec_stmt(in_single_stmt => 'begin no_semi end;');
         ut.fail('Syntax error, but no exception thrown.');
      exception
         when others then -- NOSONAR
            null; -- ignore, we want to check if error column is populated
      end trap;

      -- assert
      open c_actual for
         select case
                   when error is null then
                      '0'
                   else
                      '1'
                end as has_error
           from exec_log
          where log_id = g_last_log_id + 1;
      open c_expected for
         select '1' as has_error;
      ut.expect(c_actual).to_equal(c_expected);
   end exec_invalid;

   procedure exec_with_loop is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      exec_api.exec_stmt(
         in_no_of_calls => 10,
         in_single_stmt => 'begin 
   if 1=1 then
      null;
   end if;
end;'
      );
      -- assert
      open c_actual for
         select cast(stmt as varchar2(1000 byte)) as stmt
           from exec_log
          where log_id = g_last_log_id + 1;
      open c_expected for
         select 'begin
   for i in 1..10
   loop
      begin 
         if 1=1 then
            null;
         end if;
      end;
   end loop;
end;' as stmt;
      ut.expect(c_actual).to_equal(c_expected);
   end exec_with_loop;
end test_exec_api;
/