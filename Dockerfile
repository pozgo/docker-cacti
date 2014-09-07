FROM polinux/centos7:latest
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

ADD install/ /data/install 
ADD config/ /data/config/

RUN yum update -y && \
yum install -y --nogpgcheck cacti mariadb-server && \
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
echo "date.timezone = UTC" >> /etc/php.ini

ADD supervisord.conf /etc/supervisord.d/services.conf