#!/bin/bash
#
# Tweaking the SSH Conf to keep the SSH session alive.
#
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment
service sshd restart
#
# Setting an FQDN hostname for the Frontend Server.
#
hostnamectl set-hostname frontend.myprojectdomain.com
#
# Installing and configuring PHP 7.4 and Apache service.
#
amazon-linux-extras install php7.4
yum install httpd -y
systemctl restart httpd
systemctl enable httpd
#
# Downloading the latest version of the WordPress CMS from the official website and copying the files and directories to the Document Root.
#
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -rf wordpress/* /var/www/html/
#
# Renaming the 'wp-config-sample.php' to 'wp-config.php' (WordPress Configuration File).
#
mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
#
# Changing the ownership of the files.
#
chown -R apache:apache /var/www/html/*
#
# Adding the Database name, user, password, and the hostname to 'wp-config.php'.
#
cd  /var/www/html/
sed -i 's/database_name_here/blog/g' wp-config.php
sed -i 's/username_here/bloguser/g' wp-config.php
sed -i 's/password_here/bloguser123/g' wp-config.php
sed -i 's/localhost/mydb-backend.local/g' wp-config.php
#
