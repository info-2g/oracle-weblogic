#!/bin/bash
 
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

drop_repository() {
    echo 'DROPPING REPOSITORY'
    ${FUSION_MIDDLEWARE_HOME}/bin/rcu -silent -dropRepository -databaseType ORACLE -connectString ${DB_CONNECTION_STRING} -dbUser ${SYSDBA_USER} -dbRole SYSDBA -schemaPrefix ${SCHEMA_PREFIX} -component MDS -component IAU  -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component STB -component UCSUMS -f < ${SCRIPT_PATH}/passwordfile.txt
}
 
 
drop_repository

