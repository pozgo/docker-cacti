#!/bin/bash

yum install -y nogpgcheck wget gcc make mariadb-devel net-snmp-devel
cd /data/install
wget http://www.cacti.net/downloads/spine/cacti-spine-0.8.8b.tar.gz 
tar zxvf cacti-spine-0.8.8b.tar.gz 
cd cacti-spine-0.8.8b/
./configure 
make 
make install 

exit 0
