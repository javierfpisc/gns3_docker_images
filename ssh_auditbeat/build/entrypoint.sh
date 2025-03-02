#!/bin/bash

#Si se han definido rutas e iptables se cargan
# [ -f /etc/boot/boot.sh ] && sh /etc/boot/boot.sh
# [ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
# [ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

/usr/sbin/sshd -D &
service auditbeat start

exec bash

