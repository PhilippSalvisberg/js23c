#!/bin/bash

# Gather metrics for running a single call of to_epoch_[plsql|java|djs|js] after a database restart.
# Script must run on the database server.

restart_database() {
    sqlplus / as sysdba <<EOF
shutdown immediate
startup
EOF
}

run(){
    SCENARIO=${1}
    RUN=${2}
    FUNCTION_NAME=${3}
    restart_database
    #sleep 5 # give the database a bit time before executing the first command
    sqlplus demo1/demo1@freepdb1 <<EOF
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

run "cold_start plsql" 1 "to_epoch_plsql"
run "cold_start plsql" 2 "to_epoch_plsql"
run "cold_start plsql" 3 "to_epoch_plsql"

run "cold_start java" 1 "to_epoch_java"
run "cold_start java" 2 "to_epoch_java"
run "cold_start java" 3 "to_epoch_java"

run "cold_start djs" 1 "to_epoch_djs"
run "cold_start djs" 2 "to_epoch_djs"
run "cold_start djs" 3 "to_epoch_djs"

run "cold_start js" 1 "to_epoch_js"
run "cold_start js" 2 "to_epoch_js"
run "cold_start js" 3 "to_epoch_js"
