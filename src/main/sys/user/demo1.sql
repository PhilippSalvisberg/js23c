-- make the script re-runnable
create user if not exists demo1 identified by demo1
  default tablespace users
  temporary tablespace temp
  quota 5m on users;

-- should cover the typical privileges required by a developer
grant db_developer_role to demo1;

-- for C shared library example
grant execute on sys.utl_xml_lib to demo1;

-- for DBMS_MLE example
grant execute dynamic mle to demo1;
grant execute on javascript to demo1;

-- for MLE module example
grant create mle to demo1;

-- for experiments
grant read on sys.v_$sesstat to demo1;
grant read on sys.v_$statname to demo1;

-- for create_temp_table_[plsql|js]
grant create table to demo1;
