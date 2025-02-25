#!/bin/bash

# Parámetros desde variables de entorno
SSH_VERSION=$1  # Versión de ssh 

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

echo "SSH $SSH_VERSION instalado."
