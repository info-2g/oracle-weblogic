SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh
. ${SCRIPT_PATH}/environment.properties
export ADMIN_URL=t3s://$admin_server_listen_address:$admin_server_ssl_listen_port
$DOMAIN_CONFIGURATION_HOME/bin/stopWebLogic.sh
