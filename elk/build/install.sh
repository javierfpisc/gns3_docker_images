#!/bin/bash

# Parámetros desde variables de entorno
ELK_VERSION=${ELK_VERSION:-"8.15.0"}  # Versión por defecto vulnerable a CVE-2021-41773

echo "Instalando Apache versión vulnerable: $APACHE_VERSION (según $CVE_ID)"

# Instalar dependencias necesarias
apt update && apt install -y wget vim iputils-ping iproute2 procps curl

sed -i s/#MAX_MAP_COUNT/MAX_MAP_COUNT/ /etc/default/elasticsearch
echo node.store.allow_mmap: false >> /etc/elasticsearch/elasticsearch.yml

echo "ELK $ELK_VERSION instalado."
