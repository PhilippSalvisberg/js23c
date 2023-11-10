set define off
script
var url = new java.net.URL("https://esm.run/sql-assert@1.0.3");
var content = new java.lang.String(url.openStream().readAllBytes(),
                java.nio.charset.StandardCharsets.UTF_8);
var script = 'set scan off ' + '\n'
                + 'create or replace mle module sql_assert_mod '
                + 'language javascript as ' + '\n'
                + content + "\n"
                + '/' + "\n";
sqlcl.setStmt(script);
sqlcl.run();
/

script
var path = java.nio.file.Path.of("./esm/demotab.js");
var content = java.nio.file.Files.readString(path);
var script = 'set scan off ' + '\n'
                + 'create or replace mle module demotab_mod '
                + 'language javascript as ' + '\n'
                + content + "\n"
                + '/' + "\n";
sqlcl.setStmt(script);
sqlcl.run();
/

create or replace mle env demotab_env
   imports('sql-assert' module sql_assert_mod)
   language options 'js.strict=true, js.console=false, js.polyglot-builtin=true';

-- default values are not possible, overloading is not possible for standaline procedure
create or replace procedure create_demo_tabs(
  in_dept_table_name in varchar2,
  in_emp_table_name  in varchar2
) authid current_user as mle module demotab_mod env demotab_env signature 'create(string, string)';
/

-- this workaround leads to an ORA-600
create or replace procedure create_demo_tabs_ora600(
    in_dept_table_name in varchar2 default 'dept',
    in_emp_table_name  in varchar2 default 'emp'
) authid current_user is
    procedure create_demo_tabs_internal(
       in_dept_table_name in varchar2,
       in_emp_table_name  in varchar2
    ) as mle module demotab_mod env demotab_env signature 'create(string, string)';
begin
    create_demo_tabs_internal(in_dept_table_name, in_emp_table_name);
end;
/

-- works as expected
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
