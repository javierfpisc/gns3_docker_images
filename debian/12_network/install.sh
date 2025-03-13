#!/bin/bash

echo "Instalando paquetes en Debian"

# Instalar y dependencias necesarias
apt update && apt install -y wget vim iputils-ping iproute2 procps curl build-essential zlib1g-dev libssl-dev libpcap-dev \
    libpam0g-dev openssh-server net-tools ifupdown dnsutils nano git
    
DEBIAN_FRONTEND=noninteractive apt install -y iptables iptables-persistent

echo "Paquetes instalados"
