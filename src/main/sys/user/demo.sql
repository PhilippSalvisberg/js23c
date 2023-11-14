-- make the script re-runnable
-- user for demo purposes
create user if not exists demo identified by demo
  default tablespace users
  temporary tablespace temp
  quota unlimited on users;

-- should cover the typical privileges required by a developer
grant db_developer_role to demo;

-- for C shared library example
grant execute on sys.utl_xml_lib to demo;

-- for DBMS_MLE example
grant execute dynamic mle to demo;
grant execute on javascript to demo;

-- for MLE module example
grant create mle to demo;

-- for experiments
grant read on sys.v_$sesstat to demo;
grant read on sys.v_$statname to demo;

-- for create_temp_table_[plsql|js]
grant create table to demo;

-- avoiding ORA-01775: synonym DEMO resolves to itself due to circular translation
drop public synonym if exists demo;
