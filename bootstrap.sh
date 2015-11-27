#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "postfix postfix/mailname string $(hostname)"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password password root"
debconf-set-selections <<< "mariadb-server-5.5 mysql-server/root_password_again password root"

# install mariadb
sudo apt-get update

sudo apt-get install -y software-properties-common python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu precise main'
# install nodejs (https://github.com/nodejs/node-v0.x-archive/wiki/Installing-Node.js-via-package-manager?)
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get update

# install dependencies
sudo apt-get install python-dev python-setuptools build-essential python-mysqldb git ntp vim screen htop mariadb-server mariadb-common libmariadbclient-dev libxslt1.1 libxslt1-dev redis-server libssl-dev libcrypto++-dev postfix nginx supervisor python-pip fontconfig libxrender1 libxext6 xfonts-75dpi xfonts-base libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev libffi-dev nodejs -y

echo "Installing wkhtmltopdf"
wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-precise-i386.deb
dpkg -i wkhtmltox-0.12.2.1_linux-precise-i386.deb

# setup mariadb conf
config="
[mysqld]
innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
[mysql]
default-character-set = utf8mb4
"
echo "$config" > /etc/mysql/conf.d/barracuda.cnf
sudo service mysql restart
# mysqladmin -u root password root

su vagrant << EOF

whoami

sudo pip install -e pyopenssl ndg-httpsclient pyasn1
cd /vagrant
git clone https://github.com/frappe/bench bench-repo
cd /vagrant
sudo pip install -e bench-repo

echo "Installing frappe-bench"
cd /vagrant

bench init frappe-bench

cd /vagrant/frappe-bench
bench get-app erpnext https://github.com/frappe/erpnext.git
bench new-site site1.local --mariadb-root-password root --admin-password admin --install-app erpnext
bench use site1.local

bench setup socketio
bench setup procfile --with-watch --with-celery-broker

EOF

echo "Installed"

echo "To start, use 'vagrant ssh', go to /vagrant/frappe-bench and run bench start"

