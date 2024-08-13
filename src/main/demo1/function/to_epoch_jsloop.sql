create or replace function to_epoch_jsloop(
   in_ts    in timestamp,
   in_times in number
) return number as mle module util_loop_mod env demo_env signature 'toEpochLoop(Date, number)';
/
