#!/bin/bash

# Parámetros desde variables de entorno
ELK_VERSION=$1 # Versión

echo "Instalando ELK versión: $ELK_VERSION"

# Instalar dependencias necesarias
apt update && apt install -y wget vim iputils-ping iproute2 procps curl

sed -i s/#MAX_MAP_COUNT/MAX_MAP_COUNT/ /etc/default/elasticsearch
echo node.store.allow_mmap: false >> /etc/elasticsearch/elasticsearch.yml

#Permisos y propietario
chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
chown -R elasticsearch:elasticsearch /opt/elasticsearch
chown -R elasticsearch:elasticsearch /etc/elasticsearch
chown -R elasticsearch:elasticsearch /var/log/elasticsearch
chown -R logstash:logstash /etc/logstash/
chown -R logstash:logstash /opt/logstash/
chown -R kibana:kibana /opt/kibana/

echo "ELK $ELK_VERSION instalado."
