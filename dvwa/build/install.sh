#!/bin/bash

# Parámetros desde variables de entorno
DB=$1
DBUSER=$2
DBPASS=$3

echo "Instalando DVWA"

# Instalar dependencias necesarias
apt update &&  apt install -y git apache2 php libapache2-mod-php php-mysqli php-gd php-curl php-mbstring php-xml php-zip

# Instalar DVWA
DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server mariadb-client

rm /var/www/html/index.html
git clone https://github.com/digininja/DVWA /var/www/html/
chown -R www-data:www-data /var/www/html

service mariadb start

echo "CREATE DATABASE $DB" | mysql -u root
echo "GRANT ALL ON $DB.* TO '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS'" | mysql -u root

cp /var/www/html/config/config.inc.php.dist /var/www/html/config/config.inc.php
sed -i "s/$_DVWA\[ 'db_user' \]     = 'dvwa'/$_DVWA\[ 'db_user' \]     = '$DBUSER'/" /var/www/html/config/config.inc.php
sed -i "s/$_DVWA\[ 'db_password' \] = '$DBPASS'/$_DVWA\[ 'db_password' \] = '$DBPASS'/" /var/www/html/config/config.inc.php
sed -i "s/$_DVWA\[ 'default_security_level' \] = 'impossible'/$_DVWA\[ 'default_security_level' \] = 'low'/" /var/www/html/config/config.inc.php
sed -i 's/^\s*allow_url_include\s*=\s*Off/allow_url_include = On/' /etc/php/*/apache2/php.ini

echo "DVWA instalado."