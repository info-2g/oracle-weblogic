import os.path;

print 'CREATE VARIABLES';
domain_application_home = os.getenv('DOMAIN_APPLICATION_HOME');
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
domain_mserver_home = os.getenv('DOMAIN_MSERVER_HOME');
domain_name = os.getenv('DOMAIN_NAME');
fusion_middleware_home = os.getenv('FUSION_MIDDLEWARE_HOME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MIDDLEWARE_HOME');
node_manager_home = os.getenv('NODE_MANAGER_HOME');
weblogic_home = os.getenv('WEBLOGIC_HOME');
jks_file=os.getenv('JKS_FILE');

admin_server_url = 't3s://' + admin_server_listen_address + ':' + admin_server_ssl_listen_port;
admin_server_config_file = domain_configuration_home + '/security/.admin_server_config_file.properties';
admin_server_key_file = domain_configuration_home + '/security/.admin_server_key_file.properties';

print 'CONNECT TO ADMIN SERVER';
if os.path.isfile(admin_server_config_file) and os.path.isfile(admin_server_key_file):
    print '- USING CONFIG AND KEY FILE';
    connect(userConfigFile=admin_server_config_file, userKeyFile=admin_server_key_file, url=admin_server_url);
else:
    print '-USING USERNAME AND PASSWORD';
    connect(admin_username, admin_password, admin_server_url);

cd('/');
#server_lifecycles = cmo.getServerLifeCycleRuntimes();
server_lifecycles = cmo.getServers();
edit();
startEdit();
#domainRuntime();

for server_lifecycle in server_lifecycles:
    if (server_lifecycle.getName() != admin_server_name):
        print 'Configurando SSL en ' + server_lifecycle.getName();
        cd('/Servers/' + server_lifecycle.getName());
        cmo.setKeyStores('CustomIdentityAndJavaStandardTrust');
        cmo.setCustomIdentityKeyStoreFileName(domain_mserver_home +  '/security/' + jks_file);
        cmo.setCustomIdentityKeyStoreType('JKS');
        cmo.setCustomIdentityKeyStorePassPhrase(jks_password);
        cd('/Servers/' + server_lifecycle.getName() + '/SSL/' + server_lifecycle.getName());
        cmo.setServerPrivateKeyAlias(jks_alias);
        cmo.setServerPrivateKeyPassPhrase(jks_password);
activate();
print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
exit();
