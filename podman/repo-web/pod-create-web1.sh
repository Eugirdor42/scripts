#!/bin/bash

EXT_IPADDR=
IPADDRESS1=
SERVERNAME=
DOMAINNAME=

OPTFLDR=/srv/containers/$SERVERNAME/opt/
LOGFLDR=/srv/containers/$SERVERNAME/var/log/
WWWFLDR=/opt/www

mkdir -p $OPTFLDR/scripts
mkdir -p $OPTFLDR/httpd/certs
mkdir -p $OPTFLDR/httpd/tls/certs
mkdir -p $OPTFLDR/httpd/tls/misc
mkdir -p $OPTFLDR/httpd/tls/private
mkdir -p $LOGFLDR/httpd/
mkdir -p $WWWFLDR/html/repos

cp -f index.html $WWWFLDR/html/
#Extract an existing configuration to the folder for the web container
tar -xvf scripts.tar --directory=$OPTFLDR
tar -xvf httpd.tgz --directory=$OPTFLDR

#Manage selinux 
semanage fcontext -a -t container_file_t "/opt/www(/.*)?"
restorecon -R -v /opt/www
restorecon -R -v /srv/containers

#Create the web server instance
/bin/podman run -dit\
    --hostname $SERVERNAME \
    --dns-search eugirdor.net\
    --name $SERVERNAME \
    -p $EXT_IPADDR:80:80/tcp \
    -p $EXT_IPADDR:443:443/tcp \
    -v $OPTFLDR:/opt/ \
    -v $LOGFLDR:/var/log/ \
    -v $WWWFLDR:/opt/www \
    --restart always \
    --entrypoint='/opt/scripts/httpd-launch' \
    centos
