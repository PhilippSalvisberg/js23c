-- translation of create_temp_table_mod from JS to PL/SQL with same behavior
create or replace procedure create_temp_table_plsql(in_table_name in varchar2) is
   co_templ constant varchar2(1000 char) :=
      'create private temporary table ora$ptt_#valid_table_name# (id number)';
begin
   execute immediate replace(co_templ, '#valid_table_name#', dbms_assert.simple_sql_name(in_table_name));
end;
/
