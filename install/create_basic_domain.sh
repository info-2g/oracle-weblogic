#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

create_basic_domain() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/create_basic_domain.py
    cp ${SOFTWARE_DIRECTORY}/${JKS_FILE} ${DOMAIN_CONFIGURATION_HOME}/security
    echo 'CHANGE DERBY FLAG'
    sed -i -e '/DERBY_FLAG="true"/ s:DERBY_FLAG="true":DERBY_FLAG="false":' ${DOMAIN_CONFIGURATION_HOME}/bin/setDomainEnv.sh
}

configure_wallet() {
for dir in "$DOMAIN_CONFIGURATION_HOME"/config/fmwconfig/components/OHS/ohs*; do
    if [ -d "$dir" ]; then
        # Define el destino donde se copiará la carpeta
        DESTINATION="$dir/keystores"

        # Copia la carpeta al destino
        cp -rp "$WALLET_DIRECTORY" "$DESTINATION"
        echo "Copiado el contenido de '$WALLET_DIRECTORY' a '$DESTINATION'"

	sed -i.bak '/^\s*Listen\s\+\S\+:[0-9]\+/ s/^/# /' "$DESTINATION"/../httpd.conf
	sed -i.bak 's|^\s*SSLWallet.*keystores/default"|   SSLWallet "${ORACLE_INSTANCE}/config/fmwconfig/components/${COMPONENT_TYPE}/instances/${COMPONENT_NAME}/keystores/'$(basename ${WALLET_DIRECTORY})'"'| "$DESTINATION"/../ssl.conf
	echo "Se desactivó el puerto no seguro"
    fi
done
}
create_basic_domain
configure_wallet
