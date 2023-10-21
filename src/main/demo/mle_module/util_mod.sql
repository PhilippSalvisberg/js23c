create or replace mle module util language javascript as   
   export function toEpoch(ts) {
      return ts.valueOf();
   }
/
