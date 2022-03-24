#!/bin/bash

#Arrancamos apache y mysql
[ -d /var/lib/mysql ] && service mariadb start
[ -d /var/www/html ] && service apache2 start

exec bash

