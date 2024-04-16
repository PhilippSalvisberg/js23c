set echo off
set define off
set sqlblanklines on
set verify off
set feedback off
whenever sqlerror exit failure
set serveroutput on size unlimited
spool install.log

prompt
prompt ================================================================================================================
prompt Start of install.sql
prompt ================================================================================================================

prompt
prompt ================================================================================================================
prompt SYS
prompt ================================================================================================================

prompt alter session set current_schema = sys...
alter session set current_schema = sys;

prompt
prompt ================================================================================================================
prompt SYS: users
prompt ================================================================================================================

prompt demo1.sql
@src/main/sys/user/demo1.sql

prompt
prompt ================================================================================================================
prompt DEMO1
prompt ================================================================================================================

prompt alter session set current_schema = demo1...
alter session set current_schema = demo1;

prompt
prompt ================================================================================================================
prompt DEMO1: tables
prompt ================================================================================================================

prompt dept.sql...
@src/main/demo1/table/dept.sql

prompt emp.sql...
@src/main/demo1/table/emp.sql

prompt exec_log.sql...
@src/main/demo1/table/exec_log.sql

prompt
prompt ================================================================================================================
prompt DEMO1: initial data load
prompt ================================================================================================================

prompt load_dept.sql...
@src/main/demo1/data/load_dept.sql

prompt load_dept.sql...
@src/main/demo1/data/load_emp.sql

prompt
prompt ================================================================================================================
prompt DEMO1: views (1)
prompt ================================================================================================================

prompt session_metrics.sql...
@src/main/demo1/view/session_metrics.sql

prompt
prompt ================================================================================================================
prompt DEMO1: Java sources
prompt ================================================================================================================

prompt Util.sql...
@src/main/demo1/java/Util.sql

prompt
prompt ================================================================================================================
prompt DEMO1: MLE modules
prompt ================================================================================================================

prompt create_temp_table_mod.sql
@src/main/demo1/mle_module/create_temp_table_mod.sql

prompt increase_salary_loop_mod.sql
@src/main/demo1/mle_module/increase_salary_loop_mod.sql

prompt increase_salary_mod.sql
@src/main/demo1/mle_module/increase_salary_mod.sql

prompt sql_assert_mod.sql
@src/main/demo1/mle_module/sql_assert_mod.sql

prompt util_mod.sql
@src/main/demo1/mle_module/util_mod.sql

prompt validator_mod.sql
@src/main/demo1/mle_module/validator_mod.sql

prompt
prompt ================================================================================================================
prompt DEMO1: MLE environments
prompt ================================================================================================================

prompt demo_env.sql
@src/main/demo1/mle_env/demo_env.sql

prompt
prompt ================================================================================================================
prompt DEMO1: functions
prompt ================================================================================================================

prompt to_epoch_plsql.sql...
@src/main/demo1/function/to_epoch_plsql.sql

prompt to_epoch_java.sql...
@src/main/demo1/function/to_epoch_java.sql

prompt to_epoch_djs.sql...
@src/main/demo1/function/to_epoch_djs.sql

prompt to_epoch_djs2.sql...
@src/main/demo1/function/to_epoch_djs2.sql

prompt to_epoch_js.sql...
@src/main/demo1/function/to_epoch_js.sql

prompt to_epoch_js2.sql...
@src/main/demo1/function/to_epoch_js2.sql

prompt
prompt ================================================================================================================
prompt DEMO1: procedures
prompt ================================================================================================================

prompt create_temp_table_js.sql...
@src/main/demo1/procedure/create_temp_table_js.sql

prompt create_temp_table_plsql.sql...
@src/main/demo1/procedure/create_temp_table_plsql.sql

prompt increase_salary_dplsql.sql...
@src/main/demo1/procedure/increase_salary_dplsql.sql

prompt increase_salary_js.sql...
@src/main/demo1/procedure/increase_salary_js.sql

prompt increase_salary_jsloop.sql...
@src/main/demo1/procedure/increase_salary_jsloop.sql

prompt increase_salary_plsql.sql...
@src/main/demo1/procedure/increase_salary_plsql.sql

prompt utl_xml_parse_query.sql...
@src/main/demo1/procedure/utl_xml_parse_query.sql

prompt
prompt ================================================================================================================
prompt DEMO1: package specifications
prompt ================================================================================================================

prompt exec_api.pks...
@src/main/demo1/package/exec_api.pks

prompt validator_api.pks...
@src/main/demo1/package/validator_api.pks

prompt
prompt ================================================================================================================
prompt DEMO1: package bodies
prompt ================================================================================================================

prompt exec_api.pkb...
@src/main/demo1/package/exec_api.pkb

prompt validator_api.pbs...
@src/main/demo1/package/validator_api.pkb

prompt
prompt ================================================================================================================
prompt DEMO1: views (2)
prompt ================================================================================================================

prompt utl_xml_parse_query_examples.sql...
@src/main/demo1/view/utl_xml_parse_query_examples.sql

prompt
prompt ================================================================================================================
prompt DEMO1: test package specifications
prompt ================================================================================================================

prompt test_create_temp_table.pks...
@src/test/demo1/package/test_create_temp_table.pks

prompt test_exec_api.pks...
@src/test/demo1/package/test_exec_api.pks

prompt test_increase_salary.pks...
@src/test/demo1/package/test_increase_salary.pks

prompt test_to_epoch.pks...
@src/test/demo1/package/test_to_epoch.pks

prompt test_utl_xml_parse_query_examples.pks...
@src/test/demo1/package/test_utl_xml_parse_query_examples.pks

prompt test_utl_xml_parse_query.pks...
@src/test/demo1/package/test_utl_xml_parse_query.pks

prompt test_validator_api.pks...
@src/test/demo1/package/test_validator_api.pks

prompt
prompt ================================================================================================================
prompt DEMO1: test package bodies
prompt ================================================================================================================

prompt test_create_temp_table.pkb...
@src/test/demo1/package/test_create_temp_table.pkb

prompt test_exec_api.pkb...
@src/test/demo1/package/test_exec_api.pkb

prompt test_increase_salary.pkb...
@src/test/demo1/package/test_increase_salary.pkb

prompt test_to_epoch.pkb...
@src/test/demo1/package/test_to_epoch.pkb

prompt test_utl_xml_parse_query_examples.pkb...
@src/test/demo1/package/test_utl_xml_parse_query_examples.pkb

prompt test_utl_xml_parse_query_examples.pks...
@src/test/demo1/package/test_utl_xml_parse_query_examples.pks

prompt test_utl_xml_parse_query.pkb...
@src/test/demo1/package/test_utl_xml_parse_query.pkb

prompt test_validator_api.pkb...
@src/test/demo1/package/test_validator_api.pkb

prompt
prompt ================================================================================================================
prompt DEMO1: run tests
prompt ================================================================================================================

prompt running utPLSQL tests...

declare
   l_handle integer;
   l_result integer;
   l_userid integer;
begin
   l_handle := sys.dbms_sys_sql.open_cursor;
   sys.dbms_sys_sql.parse_as_user(
      c             => l_handle,
      statement     => 'begin ut.run; end;',
      language_flag => dbms_sql.native,
      username      => 'DEMO1'
   );
   l_result := sys.dbms_sys_sql.execute(l_handle);
   sys.dbms_sys_sql.close_cursor(l_handle);
end;
/

prompt
prompt ================================================================================================================
prompt End of install.sql
prompt ================================================================================================================

prompt done.

spool off
set define on
set feedback on
set verify on
set echo on
