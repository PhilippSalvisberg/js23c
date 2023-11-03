create or replace function to_epoch_js(in_ts in timestamp) 
   return number is 
      mle module util_mod 
      signature 'toEpoch(Date)'; -- conversion to OracleTimestamp is also possible
/
