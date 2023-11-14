create or replace function to_epoch_plsql(in_ts in timestamp) return number is
   co_epoch_date constant timestamp with time zone := timestamp '1970-01-01 00:00:00 UTC';
   l_interval    interval day(9) to second (3);
begin
   l_interval := in_ts - co_epoch_date;
   return 1000 * (extract(second from l_interval)
         + extract(minute from l_interval) * 60
         + extract(hour from l_interval) * 60 * 60
         + extract(day from l_interval) * 60 * 60 * 24);
end;
/
