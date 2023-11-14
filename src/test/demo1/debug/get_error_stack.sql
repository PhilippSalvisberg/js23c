exec create_temp_table_js('test a');

set serveroutput on size unlimited
declare
   t_frames dbms_mle.error_frames_t;
begin
   t_frames := dbms_mle.get_error_stack(
                  module_name => 'CREATE_TEMP_TABLE_MOD',
                  env_name    => 'DEMO_ENV'
               );
   for i in t_frames.count
   loop
      dbms_output.put_line(
         'ORA-04171: at '
         || t_frames(i).func
         || ' ('
         || t_frames(i).source
         || ':'
         || t_frames(i).line
         || ':'
         || t_frames(i).col
         || ')'
      );
   end loop;
end;
/
