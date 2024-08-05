#!/bin/bash

userdel oracle
rm -rf /home/oracle
rm -f /var/mail/oracle
groupadd -g 502 oracle
useradd -u 502 -g 502 oracle
mkdir /home/oracle/.ssh
chmod 700 /home/oracle/.ssh
cat /mnt/software/id_rsa.pub > /home/oracle/.ssh/authorized_keys
cp /mnt/software/id_rsa /home/oracle/.ssh
chmod 600 /home/oracle/.ssh/authorized_keys
chmod 600 /home/oracle/.ssh/id_rsa
chown -R oracle:oracle /home/oracle/.ssh

systemctl stop firewalld
systemctl disable firewalld

#Instalacióe paquetes
#rpm -Uvh /mnt/software/jdk-8u341-linux-x64.rpm
#OEL 8.9
yum install -y binutils gcc gcc-c++ glibc glibc-devel ksh libaio libaio-devel libgcc libnsl libstdc++ libstdc++-devel libX11 libXtst libXtst-devel make motif motif-devel openssl redhat-lsb redhat-lsb-core sysstat xorg-x11-utils

rm -rf /etc/oracle
mkdir /etc/oracle
rm -rf /opt/oracle
mkdir /opt/oracle
mkdir /opt/oracle/osb
mkdir /opt/oracle/config

chown -R oracle:oracle /opt/oracle
echo "inventory_loc=/opt/oracle/oraInventory" > /etc/oracle/oraInst.loc
echo "inst_group=oinstall" >> /etc/oracle/oraInst.loc
chown root:root /etc/oracle/oraInst.loc
chmod 644 /etc/oracle/oraInst.loc

echo "oracle  hard  nofile  65536" >> /etc/security/limits.conf
echo "oracle  soft  stack  10240" >> /etc/security/limits.conf
echo "oracle soft nproc 4096" >> /etc/security/limits.conf
echo "oracle hard nproc 32768" >> /etc/security/limits.conf

