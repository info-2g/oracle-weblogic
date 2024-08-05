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
 
print 'CREATE VARIABLES';
domain_application_home = os.getenv('DOMAIN_APPLICATION_HOME');
domain_configuration_home = os.getenv('DOMAIN_MSERVER_HOME');
domain_name = os.getenv('DOMAIN_NAME');
fusion_middleware_home = os.getenv('FUSION_MIDDLEWARE_HOME');
java_home = os.getenv('JAVA_HOME');
middleware_home = os.getenv('MIDDLEWARE_HOME');
node_manager_home = os.getenv('NODE_MANAGER_LOCAL_HOME');
weblogic_home = os.getenv('WEBLOGIC_HOME');
jks_file = os.getenv('JKS_FILE');
 
node_manager_listen_address = socket.gethostname();
 
print 'CREATE FILES';
directory_name = domain_application_home;
file_name = 'readme.txt';
content = 'This directory contains deployment files and deployment plans.\nTo set-up a deployment, create a directory with the name of the application.\nSubsequently, create two sub-directories called app and plan.\nThe app directory contains the deployment artifact.\nThe plan directory contains the deployment plan.';
createFile(directory_name, file_name, content);
 
directory_name = node_manager_home;
file_name = 'nodemanager.properties';
if node_manager_mode == 'plain':
    content='DomainsFile=' + node_manager_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + node_manager_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=' + node_manager_listen_address + '\nNativeVersionEnabled=true\nListenPort=' + node_manager_listen_port_local + '\nLogToStderr=true\nSecureListener=false\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + node_manager_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50';
else:
    content='DomainsFile=' + node_manager_home + '/nodemanager.domains\nLogLimit=0\nPropertiesVersion=12.1\nAuthenticationEnabled=true\nNodeManagerHome=' + node_manager_home + '\nJavaHome=' + java_home +'\nLogLevel=INFO\nDomainsFileEnabled=true\nStartScriptName=startWebLogic.sh\nListenAddress=' + node_manager_listen_address + '\nNativeVersionEnabled=true\nListenPort=' + node_manager_listen_port_local + '\nLogToStderr=true\nSecureListener=true\nLogCount=1\nStopScriptEnabled=false\nQuitEnabled=false\nLogAppend=true\nStateCheckInterval=500\nCrashRecoveryEnabled=true\nStartScriptEnabled=true\nLogFile=' + node_manager_home + '/nodemanager.log\nLogFormatter=weblogic.nodemanager.server.LogFormatter\nListenBacklog=50\nKeyStores=CustomIdentityAndJavaStandardTrust\nCustomIdentityKeyStoreFileName=' + domain_configuration_home + '/security/' + jks_file + '\nCustomIdentityKeyStoreType=JKS\nCustomIdentityKeyStorePassPhrase=' + jks_password + '\nCustomIdentityAlias=' + jks_alias + '\nCustomIdentityPrivateKeyPassPhrase=' + jks_password;

createFile(directory_name, file_name, content);

