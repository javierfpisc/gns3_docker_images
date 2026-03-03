#!/bin/bash

#Si se han definido rutas e iptables se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

#Ajustamos propietario
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
chown -R www-data:www-data /var/www/html

#WORDPRESS
#Arrancamos apache y mysql
[ -d /var/lib/mysql ] && service mariadb start
[ -d /var/www/html ] && service apache2 start

exec bash

