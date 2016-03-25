FROM million12/nginx-php:php70
MAINTAINER Przemyslaw Ozgo <linux@ozgo.info>

ENV DB_USER=user \
    DB_PASS=password \
    DB_ADDRESS=127.0.0.1 \
    SPINE_VERSION=0.8.8f \
    CACTI_COMMIT_HASH=dfba135dbd84f93f30704da824fa52a7df272b65 \
    TIMEZONE=UTC

RUN \
    rpm --rebuilddb && yum clean all && \
    yum install -y rrdtool net-snmp net-snmp-devel net-snmp-utils mariadb-devel cronie && \
    git clone https://github.com/Cacti/cacti.git /cacti/ && \
    cd /cacti && git checkout ${CACTI_COMMIT_HASH} && \
    curl -o /tmp/cacti-spine.tgz http://www.cacti.net/downloads/spine/cacti-spine-${SPINE_VERSION}.tar.gz && \
    mkdir -p /tmp/spine && \
    tar zxvf /tmp/cacti-spine.tgz -C /tmp/spine --strip-components=1 && \
    rm -f /tmp/cacti-spine.tgz && \
    cd /tmp/spine/ && ./configure && make && make install && \
    rm -rf /tmp/spine && \
     yum remove -y gcc mariadb-devel net-snmp-devel && \
    yum clean all

COPY container-files /

EXPOSE 80 81 443