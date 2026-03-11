#!/bin/bash

#Si se han definido rutas e iptables se cargan
# [ -f /etc/boot/boot.sh ] && sh /etc/boot/boot.sh
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

#Creación del bridge que puentea eth0 y eth1 en br0
brctl addbr br0
brctl addif br0 eth0
brctl addif br0 eth1
ifconfig eth0 0.0.0.0
ifconfig eth1 0.0.0.0
ifconfig br0 up
ifconfig br0 $IP netmask $MASK up
#DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

chown -R root:root /var/log/snort
chmod -R 755 /var/log/snort

${SNORT_PREFIX}/bin/snort -D -c ${SNORT_PREFIX}/etc/snort/snort.lua -R ${SNORT_PREFIX}/etc/snort/rules/local.rules -i br0 -A alert_fast &

exec bash

