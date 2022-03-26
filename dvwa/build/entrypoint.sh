#!/bin/bash

#Si se han definido rutas se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Arrancamos apache y mysql
[ -d /var/lib/mysql ] && service mariadb start
[ -d /var/www/html ] && service apache2 start

exec bash

