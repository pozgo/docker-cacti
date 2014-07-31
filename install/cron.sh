#!/bin/bash

echo "Starting cron deamon first"
/usr/sbin/crond
touch /etc/cron.allow
echo "root" >> /etc/cron.allow  
echo "cacti" >> /etc/cron.allow 
echo "Adding New cronjob for cacti poller"
echo "*/5    *   *   *   *   /usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&" | crontab -u cacti -

exit 0