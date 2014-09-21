FROM polinux/centos7:latest
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

ADD install/ /data/install 
ADD config/ /data/config

RUN yum update -y && \
yum install -y --nogpgcheck cacti mariadb-server && \
yum clean all && \
rm -rf /var/lib/mysql/* && \
mysql_install_db --user=mysql --ldata=/var/lib/mysql/ && \
cd /data/install && \
./mysql.sh && \
./spine.sh && \
mv /data/config/info.php /var/www/html/info.php && \
mv /data/config/db.php /etc/cacti/db.php && \
mv /data/config/cacti.conf /etc/httpd/conf.d/cacti.conf && \
mv /data/config/spine.conf /usr/local/spine/etc/spine.conf && \
cd /data/install/ && \
./cron.sh && \
echo "date.timezone = UTC" >> /etc/php.ini && \

# Clenaning installation directories
rm -rf /data/install/cacti-spine-0.8.8b

ADD supervisord.conf /etc/supervisor.d/cacti.conf

EXPOSE 80