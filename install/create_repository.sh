#!/bin/bash
 
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

create_repository() {
    echo 'CREATING REPOSITORY'
    ${FUSION_MIDDLEWARE_HOME}/bin/rcu -silent -createRepository -databaseType ORACLE -connectString ${DB_CONNECTION_STRING} -dbUser ${SYSDBA_USER} -dbRole SYSDBA -schemaPrefix ${SCHEMA_PREFIX} -useSamePasswordForAllSchemaUsers true -component MDS -component IAU  -component IAU_APPEND -component IAU_VIEWER -component OPSS -component WLS -component STB -component UCSUMS -f < ${SCRIPT_PATH}/passwordfile.txt
}
 
create_repository

