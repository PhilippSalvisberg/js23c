#!/bin/bash

# Gather metrics for running 100'000 calls of increase_salary_[dpsql|plsql|js] in a new database session.
# Before starting measuring, a call is issued as session initialization.
# Script requires SQLcl to be in the path.

run(){
    SCENARIO=${1}
    RUN=${2}
    PROCEDURE_NAME=${3}
    sleep 5 # give the DB a bit time
    sql ${DBUSER}/${DBPW}@${DBSERVER}:${DBPORT}/${DBSERVICE} <<EOF
begin
    -- init call, since the very first call in a session takes longer
    ${PROCEDURE_NAME}(in_deptno => 10, in_by_percent => 0);
    commit;
end;
/
begin
   -- now start measuring
   exec_api.exec_stmt(
      in_scenario    => '${SCENARIO}',
      in_run         => '${RUN}',
      in_single_stmt => q'[begin ${PROCEDURE_NAME}(in_deptno => 10, in_by_percent => 0); end;]',
      in_no_of_calls => 100000
   );
   commit;
end;
/
EOF
}

run_jsloop(){
    RUN=${1}
    sleep 5 # give the DB a bit time
    sql ${DBUSER}/${DBPW}@${DBSERVER}:${DBPORT}/${DBSERVICE} <<EOF
begin
    -- init call, since the very first call in a session takes longer
    increase_salary_jsloop(in_deptno => 10, in_by_percent => 0, in_times => 1);
    commit;
end;
/
begin
   -- now start measuring
   exec_api.exec_stmt(
      in_scenario    => 'increase_salary_100k jsloop',
      in_run         => '${RUN}',
      in_single_stmt => q'[begin increase_salary_jsloop(in_deptno => 10, in_by_percent => 0, in_times => 100000); end;]',
      in_no_of_calls => 1
   );
   commit;
end;
/
EOF
}

DBSERVER=192.168.1.8
DBPORT=51008
DBSERVICE=freepdb1
DBUSER=demo1
DBPW=demo1

run "increase_salary_100k dplsql" 1 "increase_salary_dplsql"
run "increase_salary_100k dplsql" 2 "increase_salary_dplsql"
run "increase_salary_100k dplsql" 3 "increase_salary_dplsql"
run "increase_salary_100k dplsql" 4 "increase_salary_dplsql"
run "increase_salary_100k dplsql" 5 "increase_salary_dplsql"

run "increase_salary_100k plsql" 1 "increase_salary_plsql"
run "increase_salary_100k plsql" 2 "increase_salary_plsql"
run "increase_salary_100k plsql" 3 "increase_salary_plsql"
run "increase_salary_100k plsql" 4 "increase_salary_plsql"
run "increase_salary_100k plsql" 5 "increase_salary_plsql"

run "increase_salary_100k js" 1 "increase_salary_js"
run "increase_salary_100k js" 2 "increase_salary_js"
run "increase_salary_100k js" 3 "increase_salary_js"
run "increase_salary_100k js" 4 "increase_salary_js"
run "increase_salary_100k js" 5 "increase_salary_js"

run_jsloop 1
run_jsloop 2
run_jsloop 3
run_jsloop 4
run_jsloop 5
