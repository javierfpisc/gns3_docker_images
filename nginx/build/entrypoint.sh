#!/bin/bash

#Si se han definido rutas e iptables se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

#Arrancamos SimpleHTTPServer
cd /ser8080 && python -m SimpleHTTPServer 8080 &
cd /ser8081 && python -m SimpleHTTPServer 8081 &

#Arrancamos nginx
[ -d /etc/nginx ] && service nginx start

exec bash

