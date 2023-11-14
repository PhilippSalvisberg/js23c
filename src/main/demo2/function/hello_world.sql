create or replace function hello_world return varchar2 is
   co_js    constant clob := q'~
      const bindings = require("mle-js-bindings");
      bindings.exportValue("result", "Hello World");
   ~';
   l_ctx    dbms_mle.context_handle_t;
   l_result varchar2(50 char);
begin
   l_ctx := dbms_mle.create_context();
   dbms_mle.eval(l_ctx, 'JAVASCRIPT', co_js);
   dbms_mle.import_from_mle(l_ctx, 'result', l_result);
   dbms_mle.drop_context(l_ctx);
   return l_result;
end;
/

select hello_world;

/* Causes the following error:

ORA-01031: insufficient privileges
ORA-06512: at "SYS.DBMS_MLE", line 418
ORA-06512: at "DEMO2.HELLO_WORLD", line 9

Grants required:

grant execute dynamic mle to demo2;
*/

