#!/bin/bash

# Gather metrics for running 100'000 calls of to_epoch_[plsql|java|djs|js] in a new database session. 
# Before starting measuring, a call is issued as session initialization.
# Script requires SQLcl to be in the path.

run(){
    SCENARIO=${1}
    RUN=${2}
    FUNCTION_NAME=${3}
    sql ${DBUSER}/${DBPW}@${DBSERVER}:${DBPORT}/${DBSERVICE} <<EOF
declare
    l_result integer;
begin
    -- init call, since the very first call in a session takes longer
    l_result := ${FUNCTION_NAME}(timestamp '2023-11-18 00:00:00');
end;
/  
begin
   -- now start measuring
   exec_api.exec_stmt(
      in_scenario    => '${SCENARIO}',
      in_run         => '${RUN}',
      in_single_stmt => q'[declare l_result integer; begin l_result := ${FUNCTION_NAME}(timestamp '2023-11-18 00:00:00'); end;]',
      in_no_of_calls => 100000
   );
end;
/
EOF
}

run_djs2(){
    SCENARIO=${1}
    RUN=${2}
    sql ${DBUSER}/${DBPW}@${DBSERVER}:${DBPORT}/${DBSERVICE} <<EOF
create or replace procedure doit(in_no_of_calls in integer := 1) is
   l_ctx    dbms_mle.context_handle_t;
   l_result integer;
begin
   -- Must use stored procedure, throws the following in anonymous PL/SQL block:
   --    ORA-04108: Effective userid, roles, or container changed since context creation.
   --    ORA-06512: at "SYS.DBMS_MLE", line 732
   l_ctx := dbms_mle.create_context();
   for i in 1..in_no_of_calls
   loop
      l_result := demo.to_epoch_djs2(
                     in_ctx => l_ctx,
                     in_ts  => timestamp '2023-11-18 00:00:00'
                  );
   end loop;
   dbms_mle.drop_context(l_ctx);
end;
/
begin
    -- init call, since the very first call in a session takes longer
    doit(1);
end;
/  
begin
   -- now start measuring
   exec_api.exec_stmt(
      in_scenario    => '${SCENARIO}',
      in_run         => '${RUN}',
      in_single_stmt => q'[begin doit(100000); end;]',
      in_no_of_calls => 1
   );
end;
/
drop procedure doit;
EOF
}

DBSERVER=192.168.1.8
DBPORT=51007
DBSERVICE=freepdb1
DBUSER=demo
DBPW=demo

run "to_epoch_100k plsql" 1 "to_epoch_plsql"
run "to_epoch_100k plsql" 2 "to_epoch_plsql"
run "to_epoch_100k plsql" 3 "to_epoch_plsql"

run "to_epoch_100k java" 1 "to_epoch_java"
run "to_epoch_100k java" 2 "to_epoch_java"
run "to_epoch_100k java" 3 "to_epoch_java"

run "to_epoch_100k djs" 1 "to_epoch_djs"
run "to_epoch_100k djs" 2 "to_epoch_djs"
run "to_epoch_100k djs" 3 "to_epoch_djs"

run "to_epoch_100k js" 1 "to_epoch_js"
run "to_epoch_100k js" 2 "to_epoch_js"
run "to_epoch_100k js" 3 "to_epoch_js"

run_djs2 "to_epoch_100k djs2" 1
run_djs2 "to_epoch_100k djs2" 2
run_djs2 "to_epoch_100k djs2" 3
