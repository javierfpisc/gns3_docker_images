#!/bin/bash

# Parámetros desde variables de entorno
#CVE_ID=${CVE_ID:-"CVE-2021-41773"}          # Solo para referencia

echo "Instalando Python 3"

# Instalar dependencias necesarias
apt update && apt install -y wget iputils-ping iproute2 procps curl

echo "Python 3 instalado."
