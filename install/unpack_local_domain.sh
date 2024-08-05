#!/bin/sh
 
SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
 
. ${SCRIPT_PATH}/SetEnvironmentVariables.sh
 
unpack_domain() {
    ${RUNTIME_HOME}/oracle_common/common/bin/unpack.sh -domain=${DOMAIN_MSERVER_HOME} -overwrite_domain=true -app_dir=${DOMAIN_APPLICATION_HOME} -nodemanager_type=PerDomainNodeManager -template=${TEMPORARY_DIRECTORY}/templates/${DOMAIN_NAME}.jar
    cp $DOMAIN_CONFIGURATION_HOME/security/${JKS_FILE} ${DOMAIN_MSERVER_HOME}/security
    cp $DOMAIN_CONFIGURATION_HOME/security/.nm_server*.properties $DOMAIN_MSERVER_HOME/security
}
 
change_domain() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/unpack_local_domain.py
}
 
change_memory_settings() {
    echo 'CHANGE DERBY FLAG'
    sed -i -e '/DERBY_FLAG="true"/ s:DERBY_FLAG="true":DERBY_FLAG="false":' ${DOMAIN_MSERVER_HOME}/bin/setDomainEnv.sh
 
    echo 'CHANGE MEMORY SETTINGS'

    ADMIN_SERVER_HEAP_SIZE=3072m
    ADMIN_SERVER_PERM_SIZE=1024m
    WSM_SERVER_HEAP_SIZE=1024m
    WSM_SERVER_PERM_SIZE=512m
    MANAGED_SERVER_HEAP_SIZE=8192m
    MANAGED_SERVER_PERM_SIZE=2048m
    COHERENCE_SERVER_HEAP_SIZE=1024m
    COHERENCE_SERVER_PERM_SIZE=512m
 
    touch ${DOMAIN_MSERVER_HOME}/bin/setUserOverrides.sh
    chmod u+x ${DOMAIN_MSERVER_HOME}/bin/setUserOverrides.sh
 
    echo '#!/bin/sh
 
ADMIN_SERVER_MEM_ARGS="-Xms'${ADMIN_SERVER_HEAP_SIZE}' -Xmx'${ADMIN_SERVER_HEAP_SIZE}' -XX:PermSize='${ADMIN_SERVER_PERM_SIZE}' -XX:MaxPermSize='${ADMIN_SERVER_PERM_SIZE}'"
SERVER_MEM_ARGS="-Xms'${MANAGED_SERVER_HEAP_SIZE}' -Xmx'${MANAGED_SERVER_HEAP_SIZE}' -XX:PermSize='${MANAGED_SERVER_PERM_SIZE}' -XX:MaxPermSize='${MANAGED_SERVER_PERM_SIZE}'"
WSM_MEM_ARGS="-Xms'${WSM_SERVER_HEAP_SIZE}' -Xmx'${WSM_SERVER_HEAP_SIZE}' -XX:PermSize='${WSM_SERVER_PERM_SIZE}' -XX:MaxPermSize='${WSM_SERVER_PERM_SIZE}'"
COHERENCE_SERVER_MEM_ARGS="-Xms'${COHERENCE_SERVER_HEAP_SIZE}' -Xmx'${COHERENCE_SERVER_HEAP_SIZE}' -XX:PermSize='${COHERENCE_SERVER_PERM_SIZE}' -XX:MaxPermSize='${COHERENCE_SERVER_PERM_SIZE}'"
MONITORING_ARGS="-XX:+UnlockCommercialFeatures -XX:+FlightRecorder"
COHERENCE_MONITORING_ARGS="-Dtangosol.coherence.management=all -Dtangosol.coherence.management.remote=true"
GARBAGE_COLLECTOR_ARGS="-XX:NewRatio=3 -XX:SurvivorRatio=128 -XX:MaxTenuringThreshold=0 -XX:+UseParallelGC -XX:MaxGCPauseMillis=200 -XX:GCTimeRatio=19 -XX:+UseParallelOldGC -XX:+UseTLAB"
LARGE_PAGES_ARGS="-XX:LargePageSizeInBytes=2048k -XX:+UseLargePages"
LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH

 
if [ "${ADMIN_URL}" = "" ] ; then
    USER_MEM_ARGS="${ADMIN_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS}"
else
    case ${SERVER_NAME} in
        WLS_OSB*)
            USER_MEM_ARGS="${SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${MONITORING_ARGS}"
        ;;
        WLS_WSM*)
            USER_MEM_ARGS="${WSM_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${MONITORING_ARGS}"
        ;;
        coherence_server_1)
            USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${MONITORING_ARGS} ${COHERENCE_MONITORING_ARGS}"
        ;;
        coherence_server_*)
            USER_MEM_ARGS="${COHERENCE_SERVER_MEM_ARGS} ${GARBAGE_COLLECTOR_ARGS} ${MONITORING_ARGS}"
        ;;
    esac
fi
export USER_MEM_ARGS
 
#if [ "${WEBLOGIC_EXTENSION_DIRS}" != "" ] ; then
# WEBLOGIC_EXTENSION_DIRS="${WEBLOGIC_EXTENSION_DIRS}${CLASSPATHSEP}${DOMAIN_HOME}/lib"
#else
# WEBLOGIC_EXTENSION_DIRS="${DOMAIN_HOME}/lib"
#fi
#export WEBLOGIC_EXTENSION_DIRS' > ${DOMAIN_MSERVER_HOME}/bin/setUserOverrides.sh
}
 
unpack_domain
 
change_domain
 
change_memory_settings

