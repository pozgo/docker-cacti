#!/bin/sh

set -e
set -u

# Fix Cron jobs
crontab /etc/import-cron.conf
sed -i -e 's/^#*//' /etc/cron.d/cacti
#Export default DB Password
export MYSQL_PWD=$DB_PASS

# Check if Cacti DB exists
if [ STATUS=$(mysqlshow -u $DB_USER -h $DB_ADDRESS cacti) != "cacti" ]; then
    mysql -u $DB_USER -h $DB_ADDRESS -e "CREATE DATABASE cacti"
    mysql -u $DB_USER -h $DB_ADDRESS -e "GRANT ALL ON cacti.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASS'"
    mysql -u $DB_USER -h $DB_ADDRESS cacti < /etc/cacti/cacti.sql
fi

# Update Cacti config
sed -i 's/$DB_ADDRESS/'$DB_ADDRESS'/g' /etc/cacti/db.php
sed -i 's/$DB_USER/'$DB_USER'/g' /etc/cacti/db.php
sed -i 's/$DB_PASS/'$DB_PASS'/g' /etc/cacti/db.php

# Update Spine config
sed -i 's/$DB_ADDRESS/'$DB_ADDRESS'/g' /usr/local/spine/etc/spine.conf
sed -i 's/$DB_USER/'$DB_USER'/g' /usr/local/spine/etc/spine.conf
sed -i 's/$DB_PASS/'$DB_PASS'/g' /usr/local/spine/etc/spine.conf

if [ STATUS=$(mysqlshow -u $DB_USER -h $DB_ADDRESS cacti) != "cacti" ]; then
    mysql -u $DB_USER -h $DB_ADDRESS -e "REPLACE INTO cacti.settings SET name='path_spine', value='/usr/local/spine/bin/spine'";
fi
