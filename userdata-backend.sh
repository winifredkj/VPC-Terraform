#!/bin/bash
#
# Tweaking the SSH Conf to keep the SSH session alive.
#
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment
service sshd restart
#
# Setting an FQDN hostname for the Backend Server.
#
hostnamectl set-hostname backend.myprojectdomain.com
#
#Installing PHP 7.4 on the server.
#
amazon-linux-extras install php7.4 -y
#
# Removing and uninstalling any MySQL stale files and installations from the server to avoid conflict.
#
rm -rf /var/lib/mysql/*
yum remove mysql -y
#
# Installing Apache and MariaDB services.
#
yum install httpd mariadb-server -y
systemctl restart mariadb.service
systemctl enable mariadb.service
#
# Creating WP database and database user and granting privileges.
#
mysqladmin -u root password 'mysql123'
mysql -u root -pmysql123 -e "create database blog;"
mysql -u root -pmysql123 -e "create user 'bloguser'@'%' identified by 'bloguser123';"
mysql -u root -pmysql123 -e "grant all privileges on blog.* to 'bloguser'@'%'"
mysql -u root -pmysql123 -e "flush privileges"
