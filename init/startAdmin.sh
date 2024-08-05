SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh
$MIDDLEWARE_HOME/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/environment.properties <<EOF
import socket;
node_manager_listen_address = admin_server_listen_address
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
nm_server_config_file = domain_configuration_home + '/security/.nm_server_config_file.properties';
nm_admin_server_key_file = domain_configuration_home + '/security/.nm_server_key_file.properties';

print 'CONNECT TO NODE MANAGER';
if os.path.isfile(nm_server_config_file) and os.path.isfile(nm_admin_server_key_file):
	print 'Conectando con config y keyfile'
	nmConnect(userConfigFile=nm_server_config_file,userKeyFile=nm_admin_server_key_file,host=node_manager_listen_address,port=node_manager_listen_port,domainName='${DOMAIN_NAME}',domainDir='${DOMAIN_CONFIGURATION_HOME}',nmType=node_manager_mode)
else:
	nmConnect(node_manager_username,node_manager_password,node_manager_listen_address,node_manager_listen_port,'${DOMAIN_NAME}','${DOMAIN_CONFIGURATION_HOME}',node_manager_mode)

nmStart('AdminServer')
exit()
EOF
