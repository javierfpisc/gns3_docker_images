#!/bin/bash

#Si existe el archivo /etc/routes lo ejecuta
[ -f /etc/routes/routes.sh ] && sh /etc/routes/routes.sh

#Establece los servidores DNS a 8.8.8.8
echo "nameserver 8.8.8.8" > /etc/resolv.conf

#Lanza el proceso de arranque dentro de la imagen
/usr/local/bin/start.sh

#Uso exec para lanzar bash
exec bash
