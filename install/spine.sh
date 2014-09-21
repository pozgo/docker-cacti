#!/bin/bash

yum install -y tar gcc make mariadb-devel net-snmp-devel
yum clean all 
cd /data/install
curl -O http://www.cacti.net/downloads/spine/cacti-spine-0.8.8b.tar.gz 
tar zxvf cacti-spine-0.8.8b.tar.gz 
rm cacti-spine-0.8.8b.tar.gz 
cd cacti-spine-0.8.8b/
./configure 
make 
make install 

exit 0
