#!/bin/bash
echo "*/5 * * * * cacti /usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&" > /etc/cron.d/cacti
exit 0