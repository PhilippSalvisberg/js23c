create or replace function to_epoch_js(in_ts timestamp) 
   return number is 
      mle module util 
      signature 'toEpoch(Date)'; -- conversion to OracleTimestamp is also possible
/
