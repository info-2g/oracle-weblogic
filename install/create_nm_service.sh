#!/bin/sh

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=$(dirname $SCRIPT)

. ${SCRIPT_PATH}/SetEnvironmentVariables.sh

echo '[Unit]
Description=NodeManager Service
After=network.target

[Service]
Type=simple
User=oracle
ExecStart='$DOMAIN_MSERVER_HOME'/bin/startNodeManager.sh
ExecStop='$DOMAIN_MSERVER_HOME'/bin/stopNodeManager.sh
Restart=on-abort

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/nodemanager.service

systemctl enable nodemanager.service
systemctl daemon-reload
