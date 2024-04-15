create or replace function to_epoch_js2("in_ts" in timestamp) 
   return number is 
      mle language javascript q'[return in_ts.valueOf();]';
/
