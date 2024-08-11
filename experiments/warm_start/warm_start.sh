#!/bin/bash

# Gather metrics for running a single call of to_epoch_[plsql|java|djs|js]
# in a new database session after it has been run in a preceding session.
# Script requires SQLcl to be in the path.

preceding_call() {
    FUNCTION_NAME=${1}
    sql ${DBUSER}/${DBPW}@${DBSERVER}:${DBPORT}/${DBSERVICE} <<EOF
declare
    l_result integer;
begin
    l_result := ${FUNCTION_NAME}(timestamp '2023-11-18 00:00:00');
end;
/
EOF
}

run(){
    SCENARIO=${1}
    RUN=${2}
    FUNCTION_NAME=${3}
    preceding_call "${FUNCTION_NAME}"
    sql ${DBUSER}/${DBPW}@${DBSERVER}:${DBPORT}/${DBSERVICE} <<EOF
begin
   exec_api.exec_stmt(
      in_scenario    => '${SCENARIO}',
      in_run         => '${RUN}',
      in_single_stmt => q'[declare l_result integer; begin l_result := ${FUNCTION_NAME}(timestamp '2023-11-18 00:00:00'); end;]'
   );
end;
/
EOF
}

DBSERVER=192.168.1.8
DBPORT=51008
DBSERVICE=freepdb1
DBUSER=demo1
DBPW=demo1

run "warm_start plsql" 1 "to_epoch_plsql"
run "warm_start plsql" 2 "to_epoch_plsql"
run "warm_start plsql" 3 "to_epoch_plsql"
run "warm_start plsql" 4 "to_epoch_plsql"
run "warm_start plsql" 5 "to_epoch_plsql"

run "warm_start java" 1 "to_epoch_java"
run "warm_start java" 2 "to_epoch_java"
run "warm_start java" 3 "to_epoch_java"
run "warm_start java" 4 "to_epoch_java"
run "warm_start java" 5 "to_epoch_java"

run "warm_start djs" 1 "to_epoch_djs"
run "warm_start djs" 2 "to_epoch_djs"
run "warm_start djs" 3 "to_epoch_djs"
run "warm_start djs" 4 "to_epoch_djs"
run "warm_start djs" 5 "to_epoch_djs"

run "warm_start js" 1 "to_epoch_js"
run "warm_start js" 2 "to_epoch_js"
run "warm_start js" 3 "to_epoch_js"
run "warm_start js" 4 "to_epoch_js"
run "warm_start js" 5 "to_epoch_js"
