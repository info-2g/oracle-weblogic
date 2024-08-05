import os.path;
 
print 'CREATE VARIABLES';
domain_application_home = os.getenv('DOMAIN_APPLICATION_HOME');
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
domain_name = os.getenv('DOMAIN_NAME');
fusion_middleware_home = os.getenv('FUSION_MIDDLEWARE_HOME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MIDDLEWARE_HOME');
node_manager_home = os.getenv('NODE_MANAGER_HOME');
weblogic_home = os.getenv('WEBLOGIC_HOME');
 
admin_server_url = 't3://' + admin_server_listen_address + ':' + admin_server_listen_port;
admin_server_config_file = domain_configuration_home + '/admin_server_config_file.properties';
admin_server_key_file = domain_configuration_home + '/admin_server_key_file.properties';
 
print 'CONNECT TO ADMIN SERVER';
if os.path.isfile(admin_server_config_file) and os.path.isfile(admin_server_key_file):
    print '- USING CONFIG AND KEY FILE';
    connect(userConfigFile=admin_server_config_file, userKeyFile=admin_server_key_file, url=admin_server_url);
else:
    print '-USING USERNAME AND PASSWORD';
    connect(admin_username, admin_password, admin_server_url);
 
servers = cmo.getServers();
edit();
startEdit();
for server in servers:
    if (server.getName() != admin_server_name):
        print 'Desactivando Hostname verification en ' + server.getName();
        cd('/Servers/' + server.getName() + '/SSL/' + server.getName());
        cmo.setHostnameVerificationIgnored(true);
        cmo.setHostnameVerifier(None);
        cmo.setTwoWaySSLEnabled(false);
        cmo.setClientCertificateEnforced(false);
 
activate();
print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
exit();
