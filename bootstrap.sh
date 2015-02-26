#!/usr/bin/env bash

echo "Provisioning your Virtual Machine..."
echo "Installing Apache"
sudo apt-get update &> /dev/null
sudo apt-get install -y apache2 &> /dev/null
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant/www /var/www
fi

echo "Installing PHP"
sudo apt-get install php5 libapache2-mod-php5 libapache2-mod-php5filter -y &> /dev/null
 
echo "Installing PHP extensions"
sudo apt-get install php5-common curl php5-dev php5-curl php5-cli php5-gd php5-mcrypt php5-mysql php5-cgi php5-fpm -y &> /dev/null

echo "Fetching MySQL Utilities"
sudo apt-get install debconf-utils -y &> /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "Installing MySQL"
sudo apt-get install mysql-server libapache2-mod-auth-mysql -y &> /dev/null

echo "Installing NodeJS"
sudo apt-get install nodejs -y &> /dev/null
sudo apt-get install npm -y &> /dev/null

echo "Installing LESS"
sudo npm install -g less &> /dev/null


echo "Installing Required Modules"
sudo a2enmod mpm_event &> /dev/null
sudo a2enmod authz_core &> /dev/null
sudo a2enmod authz_host &> /dev/null
sudo a2enmod authz_owner &> /dev/null
sudo a2enmod authz_user &> /dev/null
sudo a2enmod authz_dbd &> /dev/null
sudo a2enmod authz_dbm &> /dev/null
sudo a2enmod authz_groupfile &> /dev/null
sudo a2enmod auth_basic &> /dev/null
sudo a2enmod auth_mysql &> /dev/null
sudo a2enmod deflate &> /dev/null
sudo a2enmod expires &> /dev/null
sudo a2enmod include &> /dev/null
sudo a2enmod rewrite &> /dev/null
sudo a2enmod ssl &> /dev/null
sudo a2enmod userdir &> /dev/null
sudo a2enmod vhost_alias &> /dev/null
sudo a2enmod session &> /dev/null
sudo a2enmod alias &> /dev/null
sudo a2enmod cache &> /dev/null
sudo a2enmod proxy &> /dev/null
sudo a2enmod security &> /dev/null
sudo a2enmod dir &> /dev/null

echo "Writing Required Files"
echo "ServerName localhost" | sudo tee /etc/apache2/conf-available/fqdn.conf && sudo a2enconf fqdn
sudo cat /vagrant/inc/apache.txt >> /etc/apache2/apache2.conf


echo "Finalizing..."
sudo usermod -aG adm vagrant &> /dev/null
sudo ln -s /etc/apache2/sites-available/* /etc/apache2/sites-enabled/
sudo service apache2 start
