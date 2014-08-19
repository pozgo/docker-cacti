#!/bin/bash
crontab /data/config/cron.conf
sed -i -e 's/^#*//' /etc/cron.d/cacti
exit 0