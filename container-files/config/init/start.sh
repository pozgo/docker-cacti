#!/bin/sh
set -eu
export TERM=xterm
#Export default DB Password
export MYSQL_PWD=$DB_PASS
# Bash Colors
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[LOG `date +'%T'`]${reset} $@";
  else echo; fi
}
move_cacti() {
    if [ -e "/cacti" ]; then
        log "Moving Cacti into Web Directory"
        rm -rf /data/www/cacti
        mv -f /cacti /data/www/cacti
        chown -R www:www /data/www
        log "Cacti moved"
    fi
}
move_config_files() {
    if [ -e "/config.php" ]; then
        log "Moving Config files"
        mv /config.php /data/www/cacti/include/config.php
        mv -f /global.php /data/www/cacti/include/global.php
        chown -R www:www /data/www
        log "Config files moved"
    fi
}
create_db(){
    log "Creating Cacti Database"
    mysql -u $DB_USER -h $DB_ADDRESS -e "CREATE DATABASE IF NOT EXISTS cacti;"
    mysql -u $DB_USER -h $DB_ADDRESS -e "GRANT ALL ON cacti.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
    mysql -u $DB_USER -h $DB_ADDRESS -e "flush privileges;"
    log "Database created successfully"
}
import_db() {
    log "Importing Database..."
    mysql -u $DB_USER -h $DB_ADDRESS cacti < /data/www/cacti/cacti.sql
    log "Database Imported successfully"
}
spine_db_update() {
    log "Update databse with spine config details"
    mysql -u $DB_USER -h $DB_ADDRESS -e "REPLACE INTO cacti.settings SET name='path_spine', value='/usr/local/spine/bin/spine';"
    log "Database updated"
}
update_cacti_db_config() {
    log "Updating default Cacti config file"
    sed -i 's/$DB_ADDRESS/'$DB_ADDRESS'/g' /data/www/cacti/include/config.php
    sed -i 's/$DB_USER/'$DB_USER'/g' /data/www/cacti/include/config.php
    sed -i 's/$DB_PASS/'$DB_PASS'/g' /data/www/cacti/include/config.php
    log "Config file updated with Database credentials"
}
update_spine_config() {
    log "Updating Spine config file"
    if [ -e "/spine.conf" ]; then
    mv -f /spine.conf /usr/local/spine/etc/spine.conf
    sed -i 's/$DB_ADDRESS/'$DB_ADDRESS'/g' /usr/local/spine/etc/spine.conf
    sed -i 's/$DB_USER/'$DB_USER'/g' /usr/local/spine/etc/spine.conf
    sed -i 's/$DB_PASS/'$DB_PASS'/g' /usr/local/spine/etc/spine.conf
    log "Spine config updated"
    fi
    }
update_cron() {
    log "Updating Cron jobs"
    # Add Cron jobs
    crontab /etc/import-cron.conf
    log "Crontab updated."
}
set_timezone() {
    if [[ $(grep "date.timezone = ${TIMEZONE}" /etc/php.ini) != "date.timezone = ${TIMEZONE}" ]]; then
        log "Updating TIMEZONE"
        echo "date.timezone = ${TIMEZONE}" >> /etc/php.ini
        log "TIMEZONE set to: ${TIMEZONE}"
    fi
}
start_crond() {
    crond
    log "Started cron daemon"
}
# ## Magic Starts Here
move_cacti
move_config_files
# Check Database Status and update if needed
if [[ $(mysql -u "${DB_USER}" -h "${DB_ADDRESS}" -e "show databases" | grep cacti) != "cacti" ]]; then
    create_db
    import_db
    spine_db_update
fi
# Update Cacti config
update_cacti_db_config
# Update Spine config
update_spine_config
update_cron
set_timezone
start_crond
log "Cacti Server UP."