create or replace package body exec_api is
   function get_metrics return session_metrics%rowtype is -- NOSONAR: not deterministic
      r_sm session_metrics%rowtype;
   begin
      select * into r_sm from session_metrics;
      return r_sm;
   exception
      when too_many_rows or no_data_found then
         raise;
   end;

   procedure exec_stmt(
      in_scenario    in varchar2 default 'test',
      in_run         in integer  default 1,
      in_single_stmt in varchar2 default 'begin null; end;',
      in_no_of_calls in integer default 1
   ) is
      pragma autonomous_transaction;
      l_log_id      exec_log.log_id%type;
      l_scenario    exec_log.scenario%type    := in_scenario;
      l_single_stmt exec_log.stmt%type        := in_single_stmt;
      l_stmt        exec_log.stmt%type;
      l_sqlerrm     exec_log.error%type;
      r_sm          session_metrics%rowtype;
      co_nl         constant varchar2(1 byte) := chr(10);
      co_templ      constant clob             := q'[begin
   for i in 1..#no_of_calls#
   loop
      #single_stmt#
   end loop;
end;]';
   begin
      if in_no_of_calls = 1 then
         l_stmt := sys.dbms_assert.noop(l_single_stmt);
      else
         l_stmt := replace(co_templ, '#no_of_calls#', in_no_of_calls);
         l_stmt := replace(l_stmt, '#single_stmt#',
                           replace(sys.dbms_assert.noop(l_single_stmt), co_nl, co_nl || '      '));
      end if;
      r_sm := get_metrics;
      insert into exec_log(
         scenario,
         run,
         no_of_calls,
         stmt,
         start_db_time,
         start_session_uga_memory_max,
         start_session_pga_memory_max,
         start_mle_total_memory_in_use,
         start_java_session_heap_used_size_max
      )
      values (
         l_scenario,
         in_run,
         in_no_of_calls,
         l_stmt,
         r_sm.db_time,
         r_sm.session_uga_memory_max,
         r_sm.session_pga_memory_max,
         r_sm.mle_total_memory_in_use,
         r_sm.java_session_heap_used_size_max
      )
      return log_id into l_log_id;
      commit;
      execute immediate l_stmt;
      r_sm := get_metrics;
      update exec_log
         set end_time = systimestamp,
             end_db_time = r_sm.db_time,
             end_session_uga_memory_max = r_sm.session_uga_memory_max,
             end_session_pga_memory_max = r_sm.session_pga_memory_max,
             end_mle_total_memory_in_use = r_sm.mle_total_memory_in_use,
             end_java_session_heap_used_size_max = r_sm.java_session_heap_used_size_max
       where log_id = l_log_id;
      commit;
   exception
      when others then -- NOSONAR: log all kind of exceptions and re-raise
         l_sqlerrm := sqlerrm;
         update exec_log
            set error = l_sqlerrm
                || chr(10)
                || sys.dbms_utility.format_error_backtrace
          where log_id = l_log_id;
         commit;
         raise;
   end exec_stmt;
end exec_api;
/