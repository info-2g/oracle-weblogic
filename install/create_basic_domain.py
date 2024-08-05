import socket;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;

def createFile(directory_name, file_name, content):
    dedirectory = java.io.File(directory_name);
    defile = java.io.File(directory_name + '/' + file_name);

    writer = None;
    try:
        dedirectory.mkdirs();
        defile.createNewFile();
        writer = java.io.FileWriter(defile);
        writer.write(content);
    finally:
        try:
            print 'WRITING FILE ' + file_name;
            if writer != None:
                writer.flush();
                writer.close();
        except java.io.IOException, e:
            e.printStackTrace();

def createMachine(machineName):
    cd('/')
    print('Creando máquina: ' + machineName)
    machine = create(machineName, 'UnixMachine');
    machine.setPostBindUIDEnabled(java.lang.Boolean('true'));
    machine.setPostBindUID(machine_user_id);
    machine.setPostBindGIDEnabled(java.lang.Boolean('true'));
    machine.setPostBindGID(machine_group_id);


def createManagedServer(serverName, machineName, laddr, lport, is_forms):
    cd('/')
    print('Creando servidor manejado: ' + serverName)
    create(serverName,'Server')
    cd('/Servers/' + serverName)
    set('ListenAddress', laddr)
    set('ListenPort', int(lport))
    set('Machine', machineName)
    if is_forms:
        set('Cluster','cluster_forms')
        setServerGroups(serverName,server_groups_forms)
        create(serverName,'SSL');
        cd('SSL/' + serverName);
        set('ListenPort', int(p_forms_port) + 1);
        set('Enabled', 'true');
    else:
        set('Cluster','cluster_reports')
        setServerGroups(serverName,server_groups_reports)
        create(serverName,'SSL');
        cd('SSL/' + serverName);
        set('ListenPort', int(p_reports_port) + 1);
        set('Enabled', 'true');

print 'SETTING PARAMETERS';
#data_source_url=
#data_source_driver='oracle.jdbc.OracleDriver';
#data_source_user_prefix='OHS';
#data_source_password='oracle12c';
#data_source_test='SQL SELECT 1 FROM DUAL';

print 'CREATE VARIABLES';
domain_application_home = os.getenv('DOMAIN_APPLICATION_HOME');
domain_mserver_home = os.getenv('DOMAIN_MSERVER_HOME');
domain_configuration_home = os.getenv('DOMAIN_CONFIGURATION_HOME');
domain_name = os.getenv('DOMAIN_NAME');
fusion_middleware_home = os.getenv('FUSION_MIDDLEWARE_HOME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MIDDLEWARE_HOME');
node_manager_home = os.getenv('NODE_MANAGER_HOME');
weblogic_home = os.getenv('WEBLOGIC_HOME');
jks_file=os.getenv('JKS_FILE');
data_source_user_prefix=os.getenv('SCHEMA_PREFIX');
server_groups_forms=['FORMS-MAN-SVR'];
server_groups_reports=['REPORTS-APP-SERVERS'];
config_type='CustomIdentityAndJavaStandardTrust';
store_type='JKS';
key_store_file_name = domain_configuration_home + '/security/' + jks_file;
trust_store_file_name = 'cacerts';
trust_store_pass_phrase = 'changeit';


node_manager_listen_address = admin_server_listen_address

print 'CREATE TEMPLATE PATHS';
weblogic_template=weblogic_home + '/common/templates/wls/wls.jar';
forms_template=middleware_home + '/forms/common/templates/wls/forms_template.jar';
reports_template=middleware_home + '/reports/common/templates/wls/oracle.reports_app_template.jar';
em_template=middleware_home + '/em/common/templates/wls/oracle.em_wls_template.jar';
ohs_template=middleware_home + '/ohs/common/templates/wls/ohs_managed_template.jar';
reports_tools_template=middleware_home + '/ReportsToolsComponent/common/templates/wls/oracle.reports_tools_template.jar';
reports_server_component_template=middleware_home + '/ReportsServerComponent/common/templates/wls/oracle.reports_server_template.jar';
wlm_template=fusion_middleware_home + '/common/templates/wls/oracle.wsmpm_template.jar';
jrf_template=fusion_middleware_home + '/common/templates/wls/oracle.jrf_template.jar';
coherence_template=weblogic_home + '/common/templates/wls/wls_coherence_template.jar';


print 'CREATE DOMAIN';
readTemplate(weblogic_template);
setOption('DomainName', domain_name);
setOption('OverwriteDomain', 'true');
setOption('JavaHome', java_home);
setOption('ServerStartMode', 'prod');
#setOption('NodeManagerType', 'CustomLocationNodeManager');
setOption('NodeManagerHome', node_manager_home);
machine = create('machine_AdminServer', 'UnixMachine');
machine.setPostBindUIDEnabled(java.lang.Boolean('true'));
machine.setPostBindUID(machine_user_id);
machine.setPostBindGIDEnabled(java.lang.Boolean('true'));
machine.setPostBindGID(machine_group_id);
#machine.getNodeManager().setListenAddress(admin_server_listen_address);
#machine.getNodeManager().setNMType(node_manager_mode);

cd('/Servers/AdminServer');
cmo.setMachine(machine);
set('ListenAddress',admin_server_listen_address);
set('ListenPort', int(admin_server_listen_port));
set('ListenPortEnabled',true);

cd('/Security/base_domain/User/weblogic');
cmo.setName(admin_username);
cmo.setUserPassword(admin_password);

cd('/');

print "SAVE DOMAIN";
writeDomain(domain_configuration_home);
closeTemplate();

print 'READ DOMAIN';
readDomain(domain_configuration_home);

cd('/');
print 'ADD TEMPLATES';
print 'add ';
#addTemplate(weblogic_template);
print 'add forms';
addTemplate(forms_template);
print 'add reports';
addTemplate(reports_template);
#addTemplate(em_template);
print 'add ohs';
addTemplate(ohs_template);
#addTemplate(reports_tools_template);
print 'add reports_server_comp';
addTemplate(reports_server_component_template);
#print 'add wlm';
#addTemplate(wlm_template);
#addTemplate(jrf_template);
#addTemplate(coherence_template);

setOption('AppDir', domain_application_home);

print 'ADJUST DATA SOURCE SETTINGS';
print 'URL: ' + data_source_url;
jdbcsystemresources = cmo.getJDBCSystemResources();
for jdbcsystemresource in jdbcsystemresources:
    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCConnectionPoolParams/NO_NAME_0');
    cmo.setInitialCapacity(1);
    cmo.setMaxCapacity(15);
    cmo.setMinCapacity(1);
#    cmo.setStatementCacheSize(0);
    cmo.setTestConnectionsOnReserve(java.lang.Boolean('false'));
#    cmo.setTestTableName(data_source_test);
#    cmo.setConnectionCreationRetryFrequencySeconds(30);
    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCDriverParams/NO_NAME_0');
    cmo.setUrl(data_source_url);
    cmo.setPasswordEncrypted(data_source_password);
#    if cmo.getDriverName() == 'oracle.jdbc.xa.client.OracleXADataSource':
#     print '- CHANGING DRIVER FOR ' + jdbcsystemresource.getName();
#     cmo.setDriverName(data_source_driver);
#     cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCDataSourceParams/NO_NAME_0');
#     cmo.setGlobalTransactionsProtocol('LoggingLastResource');
    cd ('/JDBCSystemResource/' + jdbcsystemresource.getName() + '/JdbcResource/' + jdbcsystemresource.getName() + '/JDBCDriverParams/NO_NAME_0/Properties/NO_NAME_0/Property/user');
    cmo.setValue(cmo.getValue().replace('DEV',data_source_user_prefix));
    cd('/');

managed_servers = p_servers.split(',');

for i, managed_server in enumerate(managed_servers):
    createMachine('machine_' + managed_server);
    cd('/Machines/machine_' + managed_server);
    create('machine_' + managed_server,'NodeManager');
    cd('NodeManager/machine_' + managed_server);
    set('ListenAddress', managed_server);
    cd('/');
    createManagedServer('WLS_FORMS' + str(i+1), 'machine_' + managed_server, managed_server, p_forms_port,true);
    createManagedServer('WLS_REPORTS' + str(i+1), 'machine_' + managed_server, managed_server, p_reports_port,false);
    cd('/');
    create('ohs' + str(i+1), 'SystemComponent');
    cd('/SystemComponent/ohs' + str(i+1));
    cmo.setComponentType('OHS');
    set('Machine', 'machine_' + managed_server);
    cd('/OHS/ohs' + str(i+1));
    set('ListenAddress', managed_server);
    set('SSLListenPort', '4443');
    set('ServerName','https://' + managed_server  + ':4443');
    cd('/');
    try:
        create('forms' + str(i+1), 'SystemComponent');
        cd('/SystemComponent/forms' + str(i+1));
        cmo.setComponentType('FORMS');
        set('Machine', 'machine_' + managed_server);
    except Exception, e:
        print("Ocurrió un error al intentar crear el componente 'forms1':", str(e));
    cd('/SystemComponent/forms' + str(i+1));
    cmo.setComponentType('FORMS');
    set('Machine', 'machine_' + managed_server);

#Elimino objetos creados por defecto
cd('/');
try:
    delete('WLS_FORMS','Server')
except:
    print("Ocurrió un error al borrar WLS_FORMS");
try:
    delete('WLS_REPORTS','Server')
except:
    print("Ocurrió un error al borrar WLS_REPORTS");
try: 
    delete('AdminServerMachine','Machine')
except:
    print("Ocurrió un error al borrar AdminServerMachine");

print "SET NODE MANAGER CREDENTIALS";
cd("/SecurityConfiguration/" + domain_name);
cmo.setNodeManagerUsername(node_manager_username);
cmo.setNodeManagerPasswordEncrypted(node_manager_password);

print "Config SSL";
cd('/Servers/AdminServer');
cmo.setKeyStores(config_type);
cmo.setCustomIdentityKeyStoreFileName(key_store_file_name);
cmo.setCustomIdentityKeyStoreType(store_type);

create(admin_server_name,'SSL');

cd('SSL/' + admin_server_name);
set('ServerPrivateKeyAlias',jks_alias);
cmo.setEnabled(java.lang.Boolean('true'));
cmo.setListenPort(java.lang.Integer(admin_server_ssl_listen_port));
cmo.setHostnameVerificationIgnored(true);
cmo.setHostnameVerifier(None);
cmo.setTwoWaySSLEnabled(false);
cmo.setClientCertificateEnforced(false);

cmo.setServerPrivateKeyPassPhraseEncrypted(jks_password);
#    cmo.setCustomIdentityKeyStorePassPhrase(jks_password);
#    cmo.setServerPrivateKeyPassPhrase(jks_password);



print 'SAVE CHANGES';
updateDomain();
closeDomain();

print 'CREATE FILES';
directory_name = domain_configuration_home + '/servers/'+ admin_server_name +'/security';
file_name = 'boot.properties';
content = 'username=' + admin_username + '\npassword=' + admin_password;
createFile(directory_name, file_name, content);

directory_name = domain_application_home;
file_name = 'readme.txt';
content = 'This directory contains deployment files and deployment plans.\nTo set-up a deployment, create a directory with the name of the application.\nSubsequently, create two sub-directories called app and plan.\nThe app directory contains the deployment artifact.\nThe plan directory contains the deployment plan.';
createFile(directory_name, file_name, content);

directory_name = node_manager_home;
file_name = 'nodemanager.properties';
if node_manager_mode == 'plain':
    content='DomainsFile=' + node_manager_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + node_manager_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=' + node_manager_listen_address + '\nNativeVersionEnabled=true\nListenPort=' + node_manager_listen_port + '\nLogToStderr=true\nSecureListener=false\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + node_manager_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50';
else:
    content='DomainsFile=' + node_manager_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + node_manager_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=' + node_manager_listen_address + '\nNativeVersionEnabled=true\nListenPort=' + node_manager_listen_port + '\nLogToStderr=true\nSecureListener=true\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + node_manager_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50\nKeyStores=CustomIdentityAndJavaStandardTrust\nCustomIdentityKeyStoreFileName=' + domain_configuration_home + '/security/' + jks_file + '\nCustomIdentityKeyStoreType=JKS\nCustomIdentityKeyStorePassPhrase=' + jks_password + '\nCustomIdentityAlias=' + jks_alias + '\nCustomIdentityPrivateKeyPassPhrase=' + jks_password;

createFile(directory_name, file_name, content);

