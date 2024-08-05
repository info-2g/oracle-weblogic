#!/bin/sh
 
#############Revisar estas variables por ambiente ######################
export SCHEMA_PREFIX=
export SYSDBA_USER=
export DB_CONNECTION_STRING=
# Name of the domain
DOMAIN_NAME=""
export DOMAIN_NAME

############# Fin Revision #############################################

JKS_FILE=""
export JKS_FILE

# Directory where the software to be installed is located
SOFTWARE_DIRECTORY="$HOME/instaladores"
export SOFTWARE_DIRECTORY

WALLET_DIRECTORY="${SOFTWARE_DIRECTORY}/"
export WALLET_DIRECTORY
 
# Name of JVM file that is used in the installation
JVM_FILE_NAME="jdk-7u40-linux-x64.gz"
export JVM_FILE_NAME
 
# Name of the WebLogic file that is used in the installation
WEBLOGIC_FILE_NAME="fmw_12.2.1.4.0_infrastructure.jar"
export WEBLOGIC_FILE_NAME

# Name of the OHS file
OHS_FILE_NAME="ohs_121200_linux64.bin"
export HTTPD_FILE_NAME
 
# The scripts create files that are placed in this directory
TEMPORARY_DIRECTORY="${DOMAIN_CONFIGURATION_HOME}/tmp"
export TEMPORARY_DIRECTORY
 
# Base directory
BASE_DIRECTORY="/opt/oracle"
export BASE_DIRECTORY
 
# Directory that will used for the installation and configuration
RUNTIME_HOME="${BASE_DIRECTORY}/product/12.2.1.19/forms"
export RUNTIME_HOME
 
ORACLE_HOME=${RUNTIME_HOME}
export ORACLE_HOME
# Directory where the JVM will be installed
JAVA_HOME="/usr/java/jdk1.8.0-x64"
export JAVA_HOME
 
# Directory that will be used as the middleware home (holds software binaries)
MIDDLEWARE_HOME="${RUNTIME_HOME}"
export MIDDLEWARE_HOME
 
# Location of the Oracle inventory
ORACLE_INVENTORY_HOME="${BASE_DIRECTORY}/oraInventory"
export ORACLE_INVENTORY_HOME
 
# Group under which the software needs to be installed
ORACLE_INSTALL_GROUP="oracle"
export ORACLE_INSTALL_GROUP
 
# Directory where the configuration will be placed
CONFIGURATION_HOME="${BASE_DIRECTORY}/config"
export CONFIGURATION_HOME
 
# Domain home (directory that contains the domain configuration files)
DOMAIN_CONFIGURATION_HOME="${CONFIGURATION_HOME}/domains/aserver/${DOMAIN_NAME}"
export DOMAIN_CONFIGURATION_HOME
 
# Domain application home (directory in which application related artifacts are placed)
DOMAIN_APPLICATION_HOME="${CONFIGURATION_HOME}/domains/applications/${DOMAIN_NAME}"
export DOMAIN_APPLICATION_HOME

DOMAIN_MSERVER_HOME="${CONFIGURATION_HOME}/domains/mserver/${DOMAIN_NAME}"
export DOMAIN_MSERVER_HOME

# Node manager home (directory that contains the node manager configuration files)
#NODE_MANAGER_HOME="${CONFIGURATION_HOME}/nodemanagers/${DOMAIN_NAME}"
NODE_MANAGER_HOME="${DOMAIN_CONFIGURATION_HOME}/nodemanager"
export NODE_MANAGER_HOME

NODE_MANAGER_LOCAL_HOME="${DOMAIN_MSERVER_HOME}/nodemanager"
export NODE_MANAGER_LOCAL_HOME

# Default homes that are created when the software is installed
COHERENCE_HOME="${MIDDLEWARE_HOME}/coherence"
export COHERENCE_HOME
FUSION_MIDDLEWARE_HOME="${MIDDLEWARE_HOME}/oracle_common"
export FUSION_MIDDLEWARE_HOME
WEBLOGIC_HOME="${MIDDLEWARE_HOME}/wlserver"
export WEBLOGIC_HOME
