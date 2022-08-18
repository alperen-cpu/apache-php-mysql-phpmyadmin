#!/bin/bash
# Author: Alperen Sah
#Date 18.08.2022
clear
PHP_VERSION=8.1
apt update -y
apt install curl gnupg2 ca-certificates lsb-release -y
echo "---------- Apache 2.4 INSTALL START ----------"
apt install apache2 -y
apache2 -version
echo "---------- Apache 2.4 INSTALL FINISH ----------"
echo "----------------------------------------"
echo "----------------------------------------"
echo "----------------------------------------"
echo "---------- PHP8.1 INSTALL ----------"
apt-get install software-properties-common -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update -y
apt-get install php$PHP_VERSION php$PHP_VERSION-fpm -y
sed -i 's/memory_limit = 128M/memory_limit = 1G/' /etc/php/$PHP_VERSION/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/$PHP_VERSION/cli/php.ini
touch phpinfo.php && echo '<?php phpinfo(); ?>' > phpinfo.php && mv phpinfo.php /var/www/html/
sed -i 's/listen.owner \= www-data/listen.owner \= apache/g' /etc/php/8.1/fpm/pool.d/www.conf
sed -i 's/listen.group \= www-data/listen.group \= apache/g' /etc/php/8.1/fpm/pool.d/www.conf
apt install libapache2-mod-php8.1 -y
apt install libapache2-mod-fcgid
a2enmod proxy_fcgi setenvif && a2enconf php8.1-fpm
systemctl status php8.1-fpm && systemctl restart apache2
php -v
echo "---------- PHP INSTALL FINISH ----------"
echo "----------------------------------------"
echo "----------------------------------------"
echo "----------------------------------------"
echo "---------- MYSQL 8.0 INSTALL START ----------"
apt update -y
apt install apt-transport-https wget -y
wget http://repo.mysql.com/RPM-GPG-KEY-mysql-2022
gpg2 --import RPM-GPG-KEY-mysql-2022
wget https://repo.mysql.com//mysql-apt-config_0.8.22-1_all.deb
dpkg -i mysql-apt-config_0.8.22-1_all.deb
apt update -y
apt install mysql-server -y
systemctl restart mysql
mysql_secure_installation
echo "---------- MYSQL 8.0 INSTALL FINISH ----------"