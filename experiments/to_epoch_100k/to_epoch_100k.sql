with --@formatter:off
   function get_time(in_start in timestamp, in_end in timestamp) return number is
      l_interval interval day (1) to second (6);
   begin
   
      l_interval := in_end - in_start;
      return extract(second from l_interval)
         + extract(minute from l_interval) * 60
         + extract(hour from l_interval) * 60 * 60
         + extract(day from l_interval) * 60 * 60 * 24; --@formatter:on
   end get_time;
   logs as (
      select scenario,
             run,
             get_time(start_time, end_time) as runtime,
             min(get_time(start_time, end_time)) over (partition by scenario) as fastest_runtime,
             end_db_time - start_db_time as db_time,
             end_session_uga_memory_max as uga_mem,
             end_session_pga_memory_max as pga_mem,
             end_mle_total_memory_in_use as mle_mem,
             end_java_session_heap_used_size_max as java_mem
        from exec_log
       where scenario like 'to_epoch_100k%'
   )
select substr(scenario, 15) as scenario,
       round(runtime, 3) as runtime,
       db_time,
       uga_mem,
       pga_mem,
       mle_mem,
       java_mem,
       uga_mem + pga_mem + mle_mem + java_mem as mem_tot
  from logs
 where runtime = fastest_runtime;
 