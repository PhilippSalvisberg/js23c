create or replace mle module util_loop_mod language javascript as
import {toEpoch} from "util";
export function toEpochLoop(ts, times) {
   var result;
   for (let i=0; i<times; i++) {
      result = ts.valueOf();
   }
   return result;
}
/
