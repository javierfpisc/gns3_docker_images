#!/bin/bash

#Si se han definido rutas e iptables se cargan
# [ -f /etc/boot/boot.sh ] && sh /etc/boot/boot.sh
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

iptables -I FORWARD -j NFQUEUE --queue-num 0

[ -f /var/run/suricata.pid ] && rm /var/run/suricata.pid
#/usr/bin/suricata -c /etc/suricata/suricata.yaml --pidfile /var/run/suricata.pid --pcap -D
#/usr/bin/suricata -c /etc/suricata/suricata.yaml --pidfile /var/run/suricata.pid --af-packet -D
#Para el modo de captura nfqueue es necesario meter reglas iptables
/usr/bin/suricata -c /etc/suricata/suricata.yaml --pidfile /var/run/suricata.pid -q 0 -D

#DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf

#Cambiamos permisos de los logs y filebeat para que puedan escribir
chown -R root:root /var/log/suricata
chmod -R 755 /var/log/suricata
chown -R root:root /etc/filebeat
chown -R root:root /var/lib/filebeat
chown -R root:root /usr/share/filebeat

#Arrancamos filebeat si existe
[ -f /etc/init.d/filebeat ] && chown root:root /etc/filebeat/filebeat.yml && /etc/init.d/filebeat start

exec bash
