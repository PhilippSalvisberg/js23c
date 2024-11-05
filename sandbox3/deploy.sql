-- registered the mle command in login.sql found in SQLPATH via
-- script https://raw.githubusercontent.com/PhilippSalvisberg/mle-sqlcl/main/mle.js register
mle install sql_assert_mod https://esm.run/sql-assert@1.0.4 1.0.4
mle install demotab_mod ./esm/demotab.js 1.0.0

create or replace mle env demotab_env
   imports('sql-assert' module sql_assert_mod)
   language options 'js.strict=true, js.console=false, js.polyglot-builtin=true';

create or replace package demo authid current_user is
   procedure create_tabs as
   mle module demotab_mod env demotab_env signature 'create()';

   procedure create_tabs(
      in_dept_table_name in varchar2
   ) as mle module demotab_mod env demotab_env signature 'create(string)';

   procedure create_tabs(
      in_dept_table_name in varchar2,
      in_emp_table_name  in varchar2
   ) as mle module demotab_mod env demotab_env signature 'create(string, string)';
end demo;
/

-- required "execute on javascript" was granted to public in test
grant execute on demo to public;
create or replace public synonym demo for demotab.demo;

exit
