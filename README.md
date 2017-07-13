###Cacti Server (CentOS7 + Supervisor)
[![Circle CI](https://circleci.com/gh/pozgo/docker-cacti/tree/master.svg?style=svg&circle-token=f36545fc3efb2fa189ce90bd0cda6d19022eddc0)](https://circleci.com/gh/pozgo/docker-cacti/tree/master)
[![GitHub Open Issues](https://img.shields.io/github/issues/pozgo/docker-cacti.svg)](https://github.com/pozgo/docker-cacti/issues)
[![GitHub Stars](https://img.shields.io/github/stars/pozgo/docker-cacti.svg)](https://github.com/pozgo/docker-cacti)
[![GitHub Forks](https://img.shields.io/github/forks/pozgo/docker-cacti.svg)](https://github.com/pozgo/docker-cacti)  
[![Stars on Docker Hub](https://img.shields.io/docker/stars/polinux/cacti.svg)](https://hub.docker.com/r/polinux/cacti)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/polinux/cacti.svg)](https://hub.docker.com/r/polinux/cacti)  
[![Docker Layers](https://badge.imagelayers.io/polinux/cacti:latest.svg)](https://hub.docker.com/r/polinux/cacti)

 [![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/pozgo/docker-cacti/tree/master)

[Docker Image](https://registry.hub.docker.com/u/polinux/cacti/) with Cacti server using [million12/nginx-php]() docker image as base. (HTTP2 and HAProxy SSL termination ready.)
Image is using external datbase and it's build on PHP 7.0.

### Database deployment
To be able to connect to database we would need one to be running first. Easiest way to do that is to use another docker image. For this purpose we will use our [million12/mariadb](https://registry.hub.docker.com/u/million12/mariadb/) image as our database.

**For more information about million12/MariaDB see our [documentation.](https://github.com/million12/docker-mariadb) **

Example:  

    docker run \
    -d \
    --name cacti-db \
    -p 3306:3306 \
    --env="MARIADB_USER=cactiuser" \
    --env="MARIADB_PASS=my_password" \
    million12/mariadb

***Remember to use the same credentials when deploying cacti image.***


### Environmental Variable
In this Image you can use environmental variables to connect into external MySQL/MariaDB database.

`DB_USER` = database user  
`DB_PASS` = database password  
`DB_ADDRESS` = database address (either ip or domain-name)  
`TIMEZONE` = timezone  

### HTTP/2 Support
Container is built with `http/2` support and by default it listens on port `443`.  
Make sure you open it on `docker run`.  
Port `81` is used by default for load balancing (`HAProxy`) ssl termination.

### Cacti Deployment
Now when we have our database running we can deploy cacti image with appropriate environmental variables set.

Example:  

    docker run \
    -d \
    --name cacti \
    -p 80:80 \
    -p 443:443 \
    --env="DB_ADDRESS=database_ip" \
    --env="DB_USER=cactiuser" \
    --env="DB_PASS=my_password" \
    polinux/cacti

### Access Cacti web interface
To log in into cacti for the first time use credentials `admin:admin`. System will ask you to change those when logged in for the firts time.

Access web interface under

[dockerhost.ip/install]()  

Follow the on screen instructions.

## Author

Author: Przemyslaw Ozgo (<linux@ozgo.info>)

---

