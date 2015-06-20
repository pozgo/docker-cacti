FROM million12/centos-supervisor
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

RUN \
    yum update --nogpgcheck -y && \
    yum install --nogpgcheck -y tar httpd gcc make mariadb-devel net-snmp-devel cacti && \
    curl -o /tmp/cacti-spine.tgz http://www.cacti.net/downloads/spine/cacti-spine-0.8.8c.tar.gz && \
    mkdir -p /tmp/spine && \
    tar zxvf /tmp/cacti-spine.tgz -C /tmp/spine --strip-components=1 && \
    rm -f /tmp/cacti-spine.tgz && \
    cd /tmp/spine/ && ./configure && make && make install && \
    echo "date.timezone = UTC" >> /etc/php.ini && \
    rm -rf /tmp/spine && \
    yum remove -y gcc make tar mariadb-devel && \
    yum clean all

ENV DB_USER=user DB_PASS=password DB_ADDRESS=127.0.0.1

COPY container-files /

EXPOSE 80