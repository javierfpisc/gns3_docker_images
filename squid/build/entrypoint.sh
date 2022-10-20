#!/bin/bash

#Si se han definido rutas e iptables se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

#SQUID
#Arrancamos squid
[ -f /etc/squid/squid.conf ] && service squid start

exec bash

