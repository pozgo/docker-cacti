#!/bin/bash

echo "Starting cron deamon first"
/usr/sbin/crond

cat "- : root : ALL" >> /etc/security/access.conf 
  
echo "Adding New cronjob for cacti poller"
echo "*/5    *   *   *   *   /usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&" | crontab -u cacti -

exit 0