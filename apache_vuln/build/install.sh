#!/bin/bash

# Parámetros desde variables de entorno
APACHE_VERSION=${APACHE_VERSION:-"2.4.49"}  # Versión por defecto vulnerable a CVE-2021-41773
CVE_ID=${CVE_ID:-"CVE-2021-41773"}          # Solo para referencia

echo "Instalando Apache versión vulnerable: $APACHE_VERSION (según $CVE_ID)"

# Instalar dependencias necesarias
apt update && apt install -y wget iputils-ping iproute2 procps curl build-essential libapr1-dev libaprutil1-dev libpcre3-dev

# Descargar e instalar la versión específica de Apache
cd /usr/local/src
wget https://archive.apache.org/dist/httpd/httpd-$APACHE_VERSION.tar.gz
tar -xvzf httpd-$APACHE_VERSION.tar.gz
cd httpd-$APACHE_VERSION

# Configurar y compilar
./configure --prefix=/usr/local/apache2 --enable-so --enable-rewrite --with-ssl=/usr/lib/ssl --enable-cgi
make && make install

ln -s /usr/local/apache2/bin/apachectl /usr/sbin/apachectl

echo "Apache $APACHE_VERSION instalado."
