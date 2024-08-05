#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

stopAll() {
    ${RUNTIME_HOME}/oracle_common/common/bin/wlst.sh -loadProperties ${SCRIPT_PATH}/environment.properties ${SCRIPT_PATH}/stopAllOHS.py
}

stopAll

