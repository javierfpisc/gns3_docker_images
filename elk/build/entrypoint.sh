#!/bin/bash

#Si existe el archivo /etc/routes lo ejecuta
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Establece los servidores DNS a 8.8.8.8
echo "nameserver 8.8.8.8" > /etc/resolv.conf

#Cambio propietarios
for dir in  /var/lib/elasticsearch /opt/elasticsearch /etc/elasticsearch /var/log/elasticsearch
do
    if [ -d "$dir" ]; then
        if [ "$(stat -c %u "$dir")" != "$(id -u elasticsearch)" ]; then
            echo "Fixing ownership of $dir"
            chown -R elasticsearch:elasticsearch "$dir"
        fi
    fi
done

for dir in  /etc/logstash /opt/logstash
do
    if [ -d "$dir" ]; then
        if [ "$(stat -c %u "$dir")" != "$(id -u logstash)" ]; then
            echo "Fixing ownership of $dir"
            chown -R logstash:logstash "$dir"
        fi
    fi
done

for dir in  /opt/kibana
do
    if [ -d "$dir" ]; then
        if [ "$(stat -c %u "$dir")" != "$(id -u kibana)" ]; then
            echo "Fixing ownership of $dir"
            chown -R kibana:kibana "$dir"
        fi
    fi
done

#Lanza el proceso de arranque dentro de la imagen
#/usr/local/bin/start.sh &

/etc/init.d/elasticsearch start
/etc/init.d/logstash start
/etc/init.d/kibana start

#Uso exec para lanzar bash
exec bash
