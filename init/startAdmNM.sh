SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)
 
. ${SCRIPT_PATH}/SetEnvironmentVariables.sh
ulimit -n 32768
ulimit -u 32768
nohup $DOMAIN_CONFIGURATION_HOME/bin/startNodeManager.sh &

