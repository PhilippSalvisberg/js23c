create or replace mle module util_mod language javascript as   
export function toEpoch(ts) {
   return ts.valueOf();
}
/
