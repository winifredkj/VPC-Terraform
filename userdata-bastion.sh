#!/bin/bash
#
# Tweaking the SSH Conf to keep the SSH session alive.
#
echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
echo "LANG=en_US.utf-8" >> /etc/environment
echo "LC_ALL=en_US.utf-8" >> /etc/environment
service sshd restart
#
# Setting an FQDN hostname for the Bastion Server.
#
hostnamectl set-hostname backend.myprojectdomain.com
#
