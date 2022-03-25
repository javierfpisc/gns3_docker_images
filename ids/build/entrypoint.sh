#!/bin/bash

#Cargamos iptables almacenadas
[ -f /etc/iptables/rules.v4 ] && iptables-restore < /etc/iptables/rules.v4

#Cargamos rutas si están definidas
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Arrancamos snort si existe el servicio
if [ -f /etc/snort/snort.conf ]
then
	#snort -D -i eth0  -I -u snort -g snort -K ascii -c /etc/snort/snort.conf &
	#snort -D -i eth1  -I -u snort -g snort -K ascii -c /etc/snort/snort.conf &
	#snort -D -i br0  -I -u snort -g snort -K ascii -c /etc/snort/snort.conf &
fi

#Arrancamos suricata si existe el servicio
if [ -f /etc/suricata/suricata.yaml ]
then
	rm /var/run/suricata.pid
	#/usr/bin/suricata -c /etc/suricata/suricata.yaml --pidfile /var/run/suricata.pid --pcap -D
	#/usr/bin/suricata -c /etc/suricata/suricata.yaml --pidfile /var/run/suricata.pid --af-packet -D
	#Para el modo de captura nfqueue es necesario meter reglas iptables
	/usr/bin/suricata -c /etc/suricata/suricata.yaml --pidfile /var/run/suricata.pid -q 0 -D
fi

#Arrancamos filebeat si existe
[ -f /etc/init.d/filebeat ] && /etc/init.d/filebeat start

exec bash

