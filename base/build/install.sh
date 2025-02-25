#!/bin/bash

# Parámetros desde variables de entorno
VAR1=$1

echo "Instalando programas necesarios según requitios y variables definidas: $VAR1"

# Instalar dependencias necesarias
apt update && apt install -y procps
#apt update && apt install -y vim curl iproute2 iputils-ping net-tools ifupdown dnsutils nano wget procps git

# Configuración e instalaciones adicionales...
# cd /usr/local/src
# wget https://archive.apache.org/dist/httpd/httpd-$APACHE_VERSION.tar.gz
# tar -xvzf httpd-$APACHE_VERSION.tar.gz
# cd httpd-$APACHE_VERSION
# Configurar y compilar
# ./configure --prefix=/usr/local/apache2 --enable-so --enable-rewrite --enable-ssl --enable-cgi
# make && make install
# Iniciar Apache
#/usr/local/apache2/bin/apachectl start