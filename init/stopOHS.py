import socket;
node_manager_listen_address = socket.gethostname();
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
domain_mserver_home = os.getenv('DOMAIN_MSERVER_HOME');
domain_name = os.getenv('DOMAIN_NAME');
nm_server_config_file = domain_configuration_home + '/security/.nm_server_config_file.properties';
nm_admin_server_key_file = domain_configuration_home + '/security/.nm_server_key_file.properties';

print 'CONNECT TO NODE MANAGER';
if os.path.isfile(nm_server_config_file) and os.path.isfile(nm_admin_server_key_file):
        print 'Conectando con config y keyfile'
        nmConnect(userConfigFile=nm_server_config_file,userKeyFile=nm_admin_server_key_file,host=node_manager_listen_address,port=node_manager_listen_port_local,domainName=domain_name,domainDir=domain_mserver_home,nmType=node_manager_mode);

readDomain(domain_configuration_home);
servers=cmo.getSystemComponents();
for sm in servers:
    if (sm.getComponentType() == 'OHS'):
        #Solo debe bajar si corresponde al NM actual
        if (socket.gethostbyname(sm.getMachine().getNodeManager().listenAddress) == socket.gethostbyname(node_manager_listen_address)):
            if (nmServerStatus(serverName=sm.getName(), serverType=sm.getComponentType()) == 'RUNNING'):
                print 'START SERVER ' + sm.getName();
                nmKill(serverName=sm.getName(),serverType='OHS');
exit();
