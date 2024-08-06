SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/../install/SetEnvironmentVariables.sh

source ${SCRIPT_PATH}/../install/environment.properties

MYCERT=server1.crt
CACERT=CA.crt

${MIDDLEWARE_HOME}/bin/orapki wallet create -wallet ${WALLET_DIRECTORY} -auto_login -pwd ${jks_password}
openssl pkcs12 -export -in $MYCERT.crt -inkey $MYCERT.key -CAfile $CACERT -out pkcs12.tmp -name ${jks_alias} -passout pass:${jks_password}
${MIDDLEWARE_HOME}/bin/orapki wallet import_pkcs12 -wallet ${WALLET_DIRECTORY} -pkcs12file ${SCRIPT_PATH}/pkcs12.tmp -pwd ${jks_password} -pkcs12pwd ${jks_password}
${MIDDLEWARE_HOME}/bin/orapki wallet add -wallet ${WALLET_DIRECTORY} -cert $CACERT -trusted_cert -pwd ${jks_password}
keytool -importkeystore -srckeystore pkcs12.tmp -destkeystore ${JKS_FILE} -srcstoretype PKCS12 -srcstorepass ${jks_password} -deststorepass ${jks_password}
keytool -importcert -trustcacerts -keystore ${JKS_FILE} -storepass ${jks_password} -file $CACERT
