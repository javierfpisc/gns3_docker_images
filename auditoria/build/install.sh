#!/bin/bash
FFUF_VERSION=$1
HTTPPROBE_VERSION=$2
OWASP_ZAP_VERSION=$3

echo "Instalando programas necesarios de auditoría"

# Instalar herramientas de sistema
apt update && apt install -y vim curl iproute2 iputils-ping net-tools ifupdown dnsutils nano wget procps git unzip gpg

# Instalar dependencias
apt install -y perl libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl libmd-dev default-jre

# 1. Instalar Nmap, nikto, OWASP ZAP, Dirb, SQLMap, Gobuster, Hydra, OpenVAS, Netcat. ssh-audit
echo "[*] Instalando Nmap y otras herramientas..."
apt install -y nmap dirb sqlmap gobuster hydra netcat-openbsd ssh-audit

# 2. Instalar ffuf (descargar binario precompilado)
echo "[*] Instalando ffuf..."
wget https://github.com/ffuf/ffuf/releases/download/v${FFUF_VERSION}/ffuf_${FFUF_VERSION}_linux_amd64.tar.gz
tar -xzf ffuf_${FFUF_VERSION}_linux_amd64.tar.gz
mv ffuf /usr/local/bin/
rm ffuf_${FFUF_VERSION}_linux_amd64.tar.gz
echo "[*] ffuf instalado en /usr/local/bin/"

# 3. Instalar httprobe (descargar binario precompilado)
echo "[*] Instalando httprobe..."
wget https://github.com/tomnomnom/httprobe/releases/download/v${HTTPPROBE_VERSION}/httprobe-linux-amd64-${HTTPPROBE_VERSION}.tgz
tar -xzf httprobe-linux-amd64-${HTTPPROBE_VERSION}.tgz
mv httprobe /usr/local/bin/
rm httprobe-linux-amd64-${HTTPPROBE_VERSION}.tgz
echo "[*] httprobe instalado en /usr/local/bin/"

# 4. Instalar Nikto
echo "[*] Instalando Nikto..."
# Descargar Nikto desde GitHub
wget https://github.com/sullo/nikto/archive/master.zip -O nikto.zip
# Extraer el archivo
unzip nikto.zip
# Entrar en el directorio de Nikto
cd nikto-master/program
# Crear un enlace simbólico para usar Nikto desde cualquier lugar
ln -s $(pwd)/nikto.pl /usr/local/bin/nikto
# Limpiar archivos descargados
cd ../..
rm -rf nikto.zip
echo "[*] Nikto instalado correctamente."

# 5. Instalar OWASP ZAP
echo "[*] Instalando OWASP ZAP..."
# Descargar OWASP ZAP desde GitHub
wget https://github.com/zaproxy/zaproxy/releases/download/v${OWASP_ZAP_VERSION}/ZAP_${OWASP_ZAP_VERSION}_Linux.tar.gz
# Extraer el archivo
tar -xvf ZAP_${OWASP_ZAP_VERSION}_Linux.tar.gz
# Mover OWASP ZAP a /opt
mv ZAP_${OWASP_ZAP_VERSION} /opt/zaproxy
# Crear un enlace simbólico para usar OWASP ZAP desde cualquier lugar
ln -s /opt/zaproxy/zap.sh /usr/local/bin/zaproxy
# Limpiar archivos descargados
rm ZAP_${OWASP_ZAP_VERSION}_Linux.tar.gz
echo "[*] OWASP ZAP instalado correctamente."

# Finalizar
echo "[*] Instalación completada. Todas las herramientas están listas para usar."
echo "[*] Herramientas instaladas: Nmap, Nikto, OWASP ZAP, Dirb, SQLMap, Gobuster, Hydra, Netcat, ffuf, httprobe."