#!/bin/bash

/usr/bin/mysqld_safe &
sleep 10

 
mysqladmin -u root password password
mysqladmin -u root -ppassword reload

mysqladmin -u root -ppassword create cacti
echo "GRANT ALL ON cacti.* TO cactiuser@'localhost' IDENTIFIED BY 'password'; flush privileges; " | mysql -u root -ppassword
sleep 10 

echo  "Cacti User created..."

mysql -u cactiuser -ppassword cacti < /data/install/cacti.sql 

exit 0