#!/bin/bash

# Installer nødvendige pakker
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y

# Installer phpmyadmin
yum install phpmyadmin -y

# Installer nødvendige pakker
yum install httpd php php-mysqlnd mod_ssl mysql yum-utils -y

# Tilføger et repo
touch /etc/yum.repos.d/webmin.repo
echo [Webmin] >> /etc/yum.repos.d/webmin.repo
echo name=Webmin Distribution Neutral >> /etc/yum.repos.d/webmin.repo
echo baseurl=https://download.webmin.com/download/yum >> /etc/yum.repos.d/webmin.repo
echo enabled=1 >> /etc/yum.repos.d/webmin.repo
echo gpgcheck=1 >> /etc/yum.repos.d/webmin.repo
echo gpgkey=https://download.webmin.com/jcameron-key.asc >> /etc/yum.repos.d/webmin.repo

# Importer det nyge repo
rpm --import https://download.webmin.com/jcameron-key.asc

# Installer webmin
yum install webmin -y

# Start webmin-tjenesten
systemctl start webmin
systemctl enable webmin

# Company details selvsigneret SSL-certifikat
country=DK
state=Sjaelland
locality=Keldby
organization=Keldby Technology
organizationalunit=IT
email=mail@kbytech.dom

# Generer selvsigneret SSL-certifikat
mkdir /etc/httpd/ssl
openssl req -new -x509 -nodes -days 365 -out /etc/httpd/ssl/server.crt -keyout /etc/httpd/ssl/server.key -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

# Konfigurer Apache til at bruge SSL
echo "<VirtualHost *:443>" >> /etc/httpd/conf/httpd.conf
echo "SSLEngine on" >> /etc/httpd/conf/httpd.conf
echo "SSLCertificateFile /etc/httpd/ssl/server.crt" >> /etc/httpd/conf/httpd.conf
echo "SSLCertificateKeyFile /etc/httpd/ssl/server.key" >> /etc/httpd/conf/httpd.conf
echo "</VirtualHost>" >> /etc/httpd/conf/httpd.conf

# Start Apache-tjenesten
systemctl enable httpd
systemctl start httpd

yum install mariadb-common -y

# Installer MariaDB-server
yum install mariadb-server -y

# Start MariaDB-tjenesten
service mariadb start

# Konfigurer MariaDB
mysql -u root -e "CREATE DATABASE Arvin_Abdi;"
mysql -u root -e "GRANT ALL PRIVILEGES ON Arvin_Abdi.* TO 'arbi0086'@'%' IDENTIFIED BY 'Kode1234!';"
mysql -u root -e "CREATE DATABASE Jesper_Lamborg;"
mysql -u root -e "GRANT ALL PRIVILEGES ON Jesper_Lamborg.* TO 'jesp555e'@'%' IDENTIFIED BY 'Kode1234!';"
mysql -u root -e "CREATE DATABASE Janick_Hansen;"
mysql -u root -e "GRANT ALL PRIVILEGES ON Janick_Hansen.* TO 'jani1631'@'%' IDENTIFIED BY 'Kode1234!';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Genstart MariaDB-tjenesten
service mariadb restart

# Installer firewalld
yum install firewalld -y

# Start og aktiver firewalld-tjenesten
systemctl start firewalld 
systemctl enable firewalld

# Konfigurer firewall-regler
firewall-cmd --permanent --add-service=https ;
firewall-cmd --permanent --add-service=http ;
firewall-cmd --permanent --add-port=3306/tcp ;
firewall-cmd --reload

echo "DATABASE setup + completed."