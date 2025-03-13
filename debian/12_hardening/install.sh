#!/bin/bash

echo "Instalando Debian"

# Compilar, instalar y dependencias necesarias
apt update && apt install -y wget vim iputils-ping iproute2 procps curl build-essential zlib1g-dev libssl-dev libpcap-dev libpam0g-dev openssh-server

#Configuración básica y creación del usuario para el servicio
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "Sistema instalado"
