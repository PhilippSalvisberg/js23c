create or replace view session_metrics as
with
   stats as (
      select n.name, s.value
        from v$statname n
        join v$sesstat s
          on s.statistic# = n.statistic#
       where n.name in (
                'DB time', 'session uga memory max', 'session pga memory max',
                'java session heap used size max', 'MLE total memory in use'
             )
         and s.sid = sys_context('userenv', 'sid')   
   )
select *
  from stats
       pivot (
          sum(value)
          for name in (
             'DB time' as db_time,
             'session uga memory max' as session_uga_memory_max,
             'session pga memory max' as session_pga_memory_max, 
             'MLE total memory in use' as mle_total_memory_in_use,
             'java session heap used size max' as java_session_heap_used_size_max
          )
       );
