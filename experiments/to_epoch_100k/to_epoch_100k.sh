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
