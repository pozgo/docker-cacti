#!/bin/bash

# Add crontab job
echo "*/5 * * * *	cacti	/usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&" | crontab -

exit 0 