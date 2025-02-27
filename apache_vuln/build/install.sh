#!/bin/bash

# Parámetros desde variables de entorno
# APACHE_VERSION=$1 # Versión por defecto vulnerable a CVE-2021-41773

# echo "Instalando Apache versión: $APACHE_VERSION"



# Instalar dependencias necesarias
#apt update && apt install -y wget vim nano iputils-ping iproute2 procps curl build-essential libapr1-dev libaprutil1-dev libpcre3-dev && apt clean
apt update && apt install -y wget vim nano iputils-ping iproute2 procps curl && apt clean

#Configurar el sitio vulnerable
chmod +x /usr/local/apache2/htdocs/vulnerable-site/cgi-bin/*
echo "LoadModule cgi_module /usr/local/apache2/modules/mod_cgi.so" >> /usr/local/apache2/conf/httpd.conf
echo "Include /usr/local/apache2/conf/extra/vulnerable.conf" >> /usr/local/apache2/conf/httpd.conf

# Descargar e instalar la versión específica de Apache
# cd /usr/local/src
# wget https://archive.apache.org/dist/httpd/httpd-$APACHE_VERSION.tar.gz
# tar -xvzf httpd-$APACHE_VERSION.tar.gz
# cd httpd-$APACHE_VERSION

# # Configurar y compilar
# ./configure --prefix=/usr/local/apache2 --enable-so --enable-rewrite --with-ssl=/usr/lib/ssl --enable-cgi
# make && make install

# ln -s /usr/local/apache2/bin/apachectl /usr/sbin/apachectl

echo "Apache $APACHE_VERSION instalado."
