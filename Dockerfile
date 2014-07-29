FROM polinux/centos7:latest
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

RUN \
yum update -y && \
yum install -y --nogpgcheck cacti mariadb-server

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*
# Create new Mysql DB setup
RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql/

RUN mkdir -p /data/install
ADD install/ /data/install 

# Installing Cacti Database 
RUN cd /data/install &&\
./mysql.sh

RUN mkdir -p /data/config/

ADD config/ /data/config/
RUN cp /data/config/info.php /var/www/html/info.php

ADD supervisord.conf /etc/supervisord.d/services.conf