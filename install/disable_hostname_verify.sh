#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

disable_hostname_verification() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/../environment.properties ${SCRIPT_PATH}/disable_hostname_verify.py
}

disable_hostname_verification
