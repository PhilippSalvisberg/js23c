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

prompt demo.sql
@src/main/sys/user/demo.sql

prompt
prompt ================================================================================================================
prompt DEMO
prompt ================================================================================================================

prompt alter session set current_schema = demo...
alter session set current_schema = demo;

prompt
prompt ================================================================================================================
prompt DEMO: tables
prompt ================================================================================================================

prompt dept.sql...
@src/main/demo/table/dept.sql

prompt emp.sql...
@src/main/demo/table/emp.sql

prompt exec_log.sql...
@src/main/demo/table/exec_log.sql

prompt
prompt ================================================================================================================
prompt DEMO: initial data load
prompt ================================================================================================================

prompt load_dept.sql...
@src/main/demo/data/load_dept.sql

prompt load_dept.sql...
@src/main/demo/data/load_emp.sql

prompt
prompt ================================================================================================================
prompt DEMO: views (1)
prompt ================================================================================================================

prompt session_metrics.sql...
@src/main/demo/view/session_metrics.sql

prompt
prompt ================================================================================================================
prompt DEMO: Java sources
prompt ================================================================================================================

prompt Util.sql...
@src/main/demo/java/Util.sql

prompt
prompt ================================================================================================================
prompt DEMO: MLE modules
prompt ================================================================================================================

prompt increase_salary_mod.sql
@src/main/demo/mle_module/increase_salary_mod.sql

prompt util_mod.sql
@src/main/demo/mle_module/util_mod.sql

prompt validator_mod.sql
@src/main/demo/mle_module/validator_mod.sql

prompt
prompt ================================================================================================================
prompt DEMO: MLE environments
prompt ================================================================================================================

prompt demo_env.sql
@src/main/demo/mle_env/demo_env.sql

prompt
prompt ================================================================================================================
prompt DEMO: functions
prompt ================================================================================================================

prompt to_epoch_plsql.sql...
@src/main/demo/function/to_epoch_plsql.sql

prompt to_epoch_java.sql...
@src/main/demo/function/to_epoch_java.sql

prompt to_epoch_djs.sql...
@src/main/demo/function/to_epoch_djs.sql

prompt to_epoch_js.sql...
@src/main/demo/function/to_epoch_js.sql

prompt
prompt ================================================================================================================
prompt DEMO: procedures
prompt ================================================================================================================

prompt utl_xml_parse_query.sql...
@src/main/demo/procedure/utl_xml_parse_query.sql

prompt increase_salary_js.sql...
@src/main/demo/procedure/increase_salary_js.sql

prompt increase_salary_dplsql.sql...
@src/main/demo/procedure/increase_salary_dplsql.sql

prompt increase_salary_plsql.sql...
@src/main/demo/procedure/increase_salary_plsql.sql

prompt
prompt ================================================================================================================
prompt DEMO: package specifications
prompt ================================================================================================================

prompt exec_api.pks...
@src/main/demo/package/exec_api.pks

prompt validator_api.pks...
@src/main/demo/package/validator_api.pks

prompt
prompt ================================================================================================================
prompt DEMO: package bodies
prompt ================================================================================================================

prompt exec_api.pkb...
@src/main/demo/package/exec_api.pkb

prompt validator_api.pbs...
@src/main/demo/package/validator_api.pkb

prompt
prompt ================================================================================================================
prompt DEMO: views (2)
prompt ================================================================================================================

prompt utl_xml_parse_query_examples.sql...
@src/main/demo/view/utl_xml_parse_query_examples.sql

prompt
prompt ================================================================================================================
prompt DEMO: test package specifications
prompt ================================================================================================================

prompt test_exec_api.pks...
@src/test/demo/package/test_exec_api.pks

prompt test_increase_salary.pks...
@src/test/demo/package/test_increase_salary.pks

prompt test_to_epoch.pks...
@src/test/demo/package/test_to_epoch.pks

prompt test_utl_xml_parse_query_examples.pks...
@src/test/demo/package/test_utl_xml_parse_query_examples.pks

prompt test_utl_xml_parse_query.pks...
@src/test/demo/package/test_utl_xml_parse_query.pks

prompt test_validator_api.pks...
@src/test/demo/package/test_validator_api.pks

prompt
prompt ================================================================================================================
prompt DEMO: test package bodies
prompt ================================================================================================================

prompt test_exec_api.pkb...
@src/test/demo/package/test_exec_api.pkb

prompt test_increase_salary.pkb...
@src/test/demo/package/test_increase_salary.pkb

prompt test_to_epoch.pkb...
@src/test/demo/package/test_to_epoch.pkb

prompt test_utl_xml_parse_query_examples.pkb...
@src/test/demo/package/test_utl_xml_parse_query_examples.pkb

prompt test_utl_xml_parse_query_examples.pks...
@src/test/demo/package/test_utl_xml_parse_query_examples.pks

prompt test_utl_xml_parse_query.pkb...
@src/test/demo/package/test_utl_xml_parse_query.pkb

prompt test_validator_api.pkb...
@src/test/demo/package/test_validator_api.pkb

prompt
prompt ================================================================================================================
prompt DEMO: run tests
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
      username      => 'DEMO'
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

set spool off
set define on
set feedback on
set verify on
set echo on
