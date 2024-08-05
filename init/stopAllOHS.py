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

admin_server_url = 't3s://' +  admin_server_listen_address + ':' + admin_server_ssl_listen_port;
admin_server_config_file = domain_configuration_home + '/security/.admin_server_config_file.properties';
admin_server_key_file = domain_configuration_home + '/security/.admin_server_key_file.properties';

print 'CONNECT TO ADMIN SERVER';
if os.path.isfile(admin_server_config_file) and os.path.isfile(admin_server_key_file):
    print '- USING CONFIG AND KEY FILE';
    connect(userConfigFile=admin_server_config_file, userKeyFile=admin_server_key_file, url=admin_server_url);
else:
    print '-USING USERNAME AND PASSWORD';
    connect(admin_username, admin_password, admin_server_url);

print 'STOPPING SERVERS';
domainRuntime();
server_lifecycles = cmo.getSystemComponentLifeCycleRuntimes();
shutdown_properties = Properties();
shutdown_properties.setProperty('ComponentType', 'SystemComponent')
shutdown_properties.setProperty('ignoreSessions', 'true');
shutdown_properties.setProperty('force', 'true');
for server_lifecycle in server_lifecycles:
    if (server_lifecycle.getName().startswith('ohs')):
        serverState = server_lifecycle.getState();
        #print 'El server está en estado: ' + serverState;
        if (serverState == 'RUNNING'):
            print 'STOP SERVER ' + server_lifecycle.getName();
            shutdown_properties.setProperty('ComponentName', server_lifecycle.getName());
            #task = server_lifecycle.shutdown(shutdown_properties);
            shutdown(server_lifecycle.getName(),'SystemComponent');
            java.lang.Thread.sleep(1000);
            #print task.getStatus() + ', ' + server_lifecycle.getState();
        else:
            print 'SERVER ' + server_lifecycle.getName() + ' is in ' + serverState + ' state and will not be stopped';

print 'DISCONNECT FROM THE ADMIN SERVER';
disconnect();
exit();

