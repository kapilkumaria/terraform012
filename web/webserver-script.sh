#!/bin/bash

#############################################################
####### USE THIS USER_DATA WITH APACHE WEB SERVER ###########
#############################################################

# Get Admin Privileges

sudo su

# Install Apache2 Web Server 

apt update -y
apt install awscli -y
apt install apache2 -y
service apache2 start
service apache2 enable
echo "<html><h1>Testing the Apache Web Server Launching Sucessfully from $(hostname -f)</h1></html>" > /var/www/html/index.html
