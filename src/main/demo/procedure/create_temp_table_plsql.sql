-- translation of create_temp_table_mod from JS to PL/SQL with same behavior
-- In a real project I would remove the annonmyous PL/SQL block which catches
-- every exception just to produce an own error message.
create or replace procedure create_temp_table_plsql(in_table_name in varchar2) is
   co_templ           constant varchar2(1000 char) :=
      'create private temporary table ora$ptt_#valid_table_name# (id number)';
   l_valid_table_name user_tables.table_name%type;
begin
   begin
      l_valid_table_name := dbms_assert.qualified_sql_name(in_table_name);
   exception
      when others then
         raise_application_error(-20501, ''''
            || in_table_name
            || ''' is not a valid table name');
   end;
   execute immediate replace(co_templ, '#valid_table_name#', l_valid_table_name);
end;
/