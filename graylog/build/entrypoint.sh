#!/bin/bash

#Si se han definido rutas e iptables se cargan
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

cd /graylog/open-core && docker-compose up -d

exec bash -c "while true;do sleep 10;done"

