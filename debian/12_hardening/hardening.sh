#!/bin/bash

# Script de fortificación para sistemas basados en Debian 12 (sin systemctl y usando iptables)

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root."
  exit
fi

# Actualizar el sistema
echo "Actualizando el sistema..."
apt-get update && apt-get upgrade -y

# Instalar herramientas de seguridad básicas
echo "Instalando herramientas de seguridad..."
apt-get install -y iptables fail2ban rkhunter chkrootkit unattended-upgrades

# Configurar el firewall (iptables)
echo "Configurando el firewall (iptables)..."

# Flush todas las reglas existentes
iptables -F
iptables -X

# Políticas por defecto: denegar todo el tráfico entrante y permitir el saliente
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfico en localhost
iptables -A INPUT -i lo -j ACCEPT

# Permitir conexiones SSH (puerto 2222)
iptables -A INPUT -p tcp --dport 2222 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 2222 -m state --state ESTABLISHED -j ACCEPT

# Permitir tráfico HTTP/HTTPS (opcional, si es necesario)
# iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -A INPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

# Guardar las reglas de iptables para que persistan después de reiniciar
echo "Guardando reglas de iptables..."
iptables-save > /etc/iptables/rules.v4

# Configurar Fail2Ban para proteger contra ataques de fuerza bruta
echo "Configurando Fail2Ban..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sed -i 's/bantime  = 10m/bantime  = 1h/' /etc/fail2ban/jail.local
sed -i 's/maxretry = 5/maxretry = 3/' /etc/fail2ban/jail.local
service fail2ban restart

# Escanear el sistema en busca de rootkits
echo "Escaneando el sistema en busca de rootkits..."
rkhunter --checkall --sk
chkrootkit

# Habilitar actualizaciones automáticas de seguridad
echo "Habilitando actualizaciones automáticas de seguridad..."
sed -i 's/\/\/\s*"\${distro_id}:\${distro_codename}-updates";/\"\${distro_id}:\${distro_codename}-updates";/' /etc/apt/apt.conf.d/50unattended-upgrades
sed -i 's/\/\/\s*"\${distro_id}:\${distro_codename}-security";/\"\${distro_id}:\${distro_codename}-security";/' /etc/apt/apt.conf.d/50unattended-upgrades
echo 'APT::Periodic::Update-Package-Lists "1";' > /etc/apt/apt.conf.d/20auto-upgrades
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/20auto-upgrades

# Deshabilitar servicios innecesarios (usando service en lugar de systemctl)
echo "Deshabilitando servicios innecesarios..."
service avahi-daemon stop
update-rc.d avahi-daemon disable
service cups stop
update-rc.d cups disable
service rpcbind stop
update-rc.d rpcbind disable

# Asegurar SSH
echo "Asegurando SSH..."
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
service ssh restart

# Configurar permisos de archivos sensibles
echo "Configurando permisos de archivos sensibles..."
chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/passwd
chmod 644 /etc/group

# Limitar el acceso a cron y at
echo "Limitar el acceso a cron y at..."
echo "root" > /etc/cron.allow
echo "root" > /etc/at.allow
chmod 600 /etc/cron.allow
chmod 600 /etc/at.allow
rm -f /etc/cron.deny
rm -f /etc/at.deny

# Habilitar AppArmor (usando service en lugar de systemctl)
echo "Habilitando AppArmor..."
service apparmor start
update-rc.d apparmor enable

# Configurar sysctl para mejorar la seguridad del kernel
echo "Configurando sysctl para mejorar la seguridad del kernel..."
echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_source_route=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route=0" >> /etc/sysctl.conf
echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf
echo "net.ipv4.icmp_ignore_bogus_error_responses=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.log_martians=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians=1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps=0" >> /etc/sysctl.conf
sysctl -p

# Limpiar el sistema
echo "Limpiando el sistema..."
apt-get autoremove -y
apt-get autoclean -y

echo "Fortificación completada. Por favor, revisa los logs y ajusta las configuraciones según sea necesario."