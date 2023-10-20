create or replace function to_epoch_java(in_ts timestamp) 
   return number is language java name 
      'Util.toEpoch(java.sql.Timestamp) return java.lang.long';
/
