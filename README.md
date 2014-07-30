###Cacti 0.8.8b server container
Installation based on Centos 7 (polinux/centos7:latest).

Built in Mysql Database server into container. 

### Starting container

`docker run -d --name cacti --net host polinux/cacti:latest`

Access through 

`localhost/cacti` 

or

`dockerhost.ip/cacti`

Follow the on screen instructions.
### Login Details
DB Username:    cactiuser

DB Password:    password

Cacti default login details :

user:   admin

pass:   admin

### FYI
During Web Installation add spine directory:

`/usr/local/spine/bin/spine`

If everything is ok you should see:

`[OK: FILE FOUND]` 