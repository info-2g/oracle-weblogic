#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

configure_keystore() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/configure_keystore.py
}

disable_hostname_verification() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/disable_hostname_verify.py
}

disable_no_ssl_port() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/disable_no_ssl_port.py
}

configure_libovd() {
    source ${SCRIPT_PATH}/../environment.properties
    export WL_HOME=${WEBLOGIC_HOME}
    ${FUSION_MIDDLEWARE_HOME}/bin/libovdconfig.sh -host $admin_server_listen_address -port $admin_server_listen_port -domainPath $DOMAIN_CONFIGURATION_HOME -userName $admin_username -createKeystore
}

configure_keystore
#disable_hostname_verification
configure_libovd
disable_no_ssl_port
