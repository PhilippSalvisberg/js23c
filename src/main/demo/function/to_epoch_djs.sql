create or replace function to_epoch_djs(in_ts timestamp) return number is
   co_js    constant clob := q'~
      var bindings = require("mle-js-bindings");
      var ts = bindings.importValue("ts");
      bindings.exportValue("millis", ts.valueOf());
   ~';
   l_ctx    dbms_mle.context_handle_t;
   l_millis number;
begin
   l_ctx := dbms_mle.create_context();
   dbms_mle.export_to_mle(l_ctx, 'ts', in_ts);
   dbms_mle.eval(l_ctx, 'JAVASCRIPT', co_js);
   dbms_mle.import_from_mle(l_ctx, 'millis', l_millis);
   dbms_mle.drop_context(l_ctx);
   return l_millis;
end to_epoch_djs;
/
