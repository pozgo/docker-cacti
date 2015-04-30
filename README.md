###Cacti Server (CentOS7 + Supervisor)
[Docker Image](https://registry.hub.docker.com/u/polinux/cacti/) with Cacti server using CentOS7 and Supervisor.
Image is using external datbase. 

### Database deployment
To be able to connect to database we would need one to be running first. Easiest way to do that is to use another docker image. For this purpose we will use our [million12/mariadb](https://registry.hub.docker.com/u/million12/mariadb/) image as our database.

**For more information about million12/MariaDB see our [documentation.](https://github.com/million12/docker-mariadb) **

Example:  
`docker run \`  
`-d \`  
`--name cacti-db \`  
`-p 3306:3306 \`  
`--env="MARIADB_USER=cactiuser" \`  
`--env="MARIADB_PASS=my_password" \`  
`million12/mariadb`  

***Remember to use the same credentials when deploying cacti image.***


### Environmental Variable
In this Image you can use environmental variables to connect into external MySQL/MariaDB database.

`DB_USER` = database user  
`DB_PASS` = database password  
`DB_ADDRESS` = database address (either ip or domain-name).

### Cacti Deployment
Now when we have our database running we can deploy cacti image with appropriate environmental variables set.

Example:  
`docker run \`  
`-d \`  
`--name cacti \`  
`-p 80:80 \`  
`--env="DB_ADDRESS=database_ip" \`  
`--env="DB_USER=cactiuser" \`  
`--env="DB_PASS=my_password" \`  
`polinux/cacti`

### Access Cacti web interface 
To log in into cacti for the first time use credentials `admin:admin`. System will ask you to change those when logged in for the firts time. 

Access web interface under 

> [dockerhost.ip/cacti]()  

Follow the on screen instructions.

## Author
  
Author: Przemyslaw Ozgo (<linux@ozgo.info>)

---

