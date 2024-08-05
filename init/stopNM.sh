SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

$DOMAIN_MSERVER_HOME/bin/stopNodeManager.sh

