create or replace procedure create_temp_table_js(in_table_name in varchar2) 
as mle module create_temp_table_mod signature 'createTempTable(string)';
/
