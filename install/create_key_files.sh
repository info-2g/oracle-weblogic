SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh
$MIDDLEWARE_HOME/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties <<EOF
import socket;

domain_application_home = os.getenv('DOMAIN_APPLICATION_HOME');
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
domain_name = os.getenv('DOMAIN_NAME');
fusion_middleware_home = os.getenv('FUSION_MIDDLEWARE_HOME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MIDDLEWARE_HOME');
node_manager_home = os.getenv('NODE_MANAGER_HOME');
weblogic_home = os.getenv('WEBLOGIC_HOME');

admin_server_url = 't3s://' +  admin_server_listen_address + ':' + admin_server_ssl_listen_port;
admin_server_config_file = domain_configuration_home + '/security/.admin_server_config_file.properties';
admin_server_key_file = domain_configuration_home + '/security/.admin_server_key_file.properties';


node_manager_listen_address = admin_server_listen_address
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
nm_server_config_file = domain_configuration_home + '/security/.nm_server_config_file.properties';
nm_admin_server_key_file = domain_configuration_home + '/security/.nm_server_key_file.properties';

nmConnect(node_manager_username,node_manager_password,node_manager_listen_address,node_manager_listen_port,'${DOMAIN_NAME}','${DOMAIN_CONFIGURATION_HOME}',node_manager_mode)
storeUserConfig(userConfigFile=nm_server_config_file,userKeyFile=nm_admin_server_key_file,nm='true')
print 'BORRAR node_manager_username Y node_manager_password'
exit()
EOF

