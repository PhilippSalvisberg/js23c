create or replace package body validator_api is
   function is_email_djs(
      in_email   in varchar2,
      in_options in json default null
   ) return boolean is
      co_js    constant clob := q'~
         (async () => {
            const bindings = await import("mle-js-bindings");
            const email = bindings.importValue("email");
            const options = bindings.importValue("options");
            const validator = await import("validator");
            const result = validator.default.isEmail(email, options);
            bindings.exportValue("result", result);
         })();
      ~';
      l_ctx    dbms_mle.context_handle_t;
      l_options json;
      l_result boolean;
   begin
      l_options := coalesce(in_options, JSON('{}'));
      l_ctx := dbms_mle.create_context(environment => 'DEMO_ENV');
      dbms_mle.export_to_mle(l_ctx, 'email', in_email);
      dbms_mle.export_to_mle(l_ctx, 'options', l_options);
      dbms_mle.eval(l_ctx, 'JAVASCRIPT', co_js);
      dbms_mle.import_from_mle(l_ctx, 'result', l_result);
      dbms_mle.drop_context(l_ctx);
      return l_result;
   end is_email_djs;
end validator_api;
/
