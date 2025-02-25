#!/bin/bash

# Parámetros desde variables de entorno
ELK_VERSION=$1 # Versión

echo "Instalando ELK versión: $ELK_VERSION"

# Instalar dependencias necesarias
apt update && apt install -y wget vim iputils-ping iproute2 procps curl

sed -i s/#MAX_MAP_COUNT/MAX_MAP_COUNT/ /etc/default/elasticsearch
echo node.store.allow_mmap: false >> /etc/elasticsearch/elasticsearch.yml

echo "ELK $ELK_VERSION instalado."
