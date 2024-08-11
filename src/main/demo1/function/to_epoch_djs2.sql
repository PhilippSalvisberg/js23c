create or replace function to_epoch_djs2(
   in_ctx in dbms_mle.context_handle_t,
   in_ts  in timestamp
) return number is
   -- In OracleDB 23.5.0 we must use "var" instead of "const" in co_js to avoid
   -- ORA-04160: SyntaxError: Variable "bindings" has already been declared
   -- when called more than once for a given in_ctx
   co_js    constant clob := q'~
      var bindings = require("mle-js-bindings");
      var ts = bindings.importValue("ts");
      bindings.exportValue("millis", ts.valueOf());
   ~';
   l_millis number;
begin
   dbms_mle.export_to_mle(in_ctx, 'ts', in_ts);
   dbms_mle.eval(in_ctx, 'JAVASCRIPT', co_js);
   dbms_mle.import_from_mle(in_ctx, 'millis', l_millis);
   return l_millis;
end to_epoch_djs2;
/
