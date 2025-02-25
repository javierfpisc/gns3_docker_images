#!/bin/bash

# Parámetros desde variables de entorno
FILEBEAT_VERSION=$1 # Versión de FILEBEAT
ELK_SERVER=$2      # Dirección IP del servidor ELK

#export ELK_SERVER

echo "Instalando Suricata con FILEBEAT: $FILEBEAT_VERSION"

# Instalar dependencias necesarias
apt update && DEBIAN_FRONTEND=noninteractive apt install -y wget vim iputils-ping iproute2 procps curl iptables suricata

# Instalar FILEBEAT
cd /tmp && wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-amd64.deb && apt install -y /tmp/filebeat-${FILEBEAT_VERSION}-amd64.deb

filebeat modules enable suricata

#Configurar FILEBEAT
sed -i '/setup\.template\.settings:/a \  setup.template.name: "suricata"\n  setup.template.pattern: "suricata-*"\n  setup.dashboards.index: "suricata-*"\n  setup.ilm.enabled: false' /etc/filebeat/filebeat.yml
sed -i "/setup\.kibana:/a \  host: \"$ELK_SERVER:5601\"" /etc/filebeat/filebeat.yml
sed -i "/output\.elasticsearch:/,/^$/ s/hosts: \[\"localhost:9200\"\]/hosts: \[\"$ELK_SERVER:9200\"\]/" /etc/filebeat/filebeat.yml
sed -i '/eve:/,/^$/ s/enabled: false/enabled: true/' /etc/filebeat/modules.d/suricata.yml

filebeat setup

echo "Suricata y FILEBEAT $FILEBEAT_VERSION instalados."
