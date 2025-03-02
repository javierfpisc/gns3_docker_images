#!/bin/bash

# Parámetros desde variables de entorno
SSH_VERSION=$1  # Versión de ssh
AUDITBEAT_VERSION=$2  # Versión de auditd
ELK_SERVER=$3  # Dirección IP del servidor ELK

echo "Instalando SSH versión : $SSH_VERSION"

# Compilar, instalar y dependencias necesarias
apt update && apt install -y wget vim iputils-ping iproute2 procps curl build-essential zlib1g-dev libssl-dev libpcap-dev libpam0g-dev

wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${SSH_VERSION}.tar.gz
tar -xvzf openssh-${SSH_VERSION}.tar.gz
cd openssh-${SSH_VERSION}

./configure --prefix=/usr --sysconfdir=/etc/ssh
make
make install

#Configuración básica y creación del usuario para el servicio
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
useradd -r -M -d /var/empty -s /usr/sbin/nologin sshd

#Instalación de auditbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-${AUDITBEAT_VERSION}-amd64.deb
dpkg -i auditbeat-${AUDITBEAT_VERSION}-amd64.deb

#Configuración de auditbeat
sed -i "/setup\.kibana:/a \  host: \"$ELK_SERVER:5601\"" /etc/auditbeat/auditbeat.yml
sed -i "/output\.elasticsearch:/,/^$/ s/hosts: \[\"localhost:9200\"\]/hosts: \[\"$ELK_SERVER:9200\"\]/" /etc/auditbeat/auditbeat.yml
sed -i '/- module: audit/a \  enabled: false' /etc/auditbeat/auditbeat.yml  # Deshabilitar el módulo de auditd

auditbeat setup -e

echo "SSH $SSH_VERSION instalado y Auditbeat $AUDITBEAT_VERSION instalado"
