#!/bin/bash

#WORDPRESS
#Arrancamos apache y mysql
[ -d /var/lib/mysql ] && service mysql start
[ -d /var/www/html ] && service apache2 start

##Arrancamos fail2ban
[ -f /etc/init.d/fail2ban ] & rm -rf /var/run/fail2ban/fail2ban.sock & service fail2ban start

exec bash

