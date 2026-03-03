#!/bin/bash

#Si existe el archivo /etc/routes lo ejecuta
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Establece los servidores DNS a 8.8.8.8
echo "nameserver 8.8.8.8" > /etc/resolv.conf

#Cambia permisos de /var/lib/elasticsearch porque a veces falla al arrancar
chmod -R 777 /var/lib/elasticsearch
chown -R elasticsearch:elasticsearch /opt/elasticsearch
chmod 777 /etc/elasticsearch
chmod a+x /opt/elasticsearch/jdk/bin/java


#Lanza el proceso de arranque dentro de la imagen
/usr/local/bin/start.sh &

#Uso exec para lanzar bash
exec bash
