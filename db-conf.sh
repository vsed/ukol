#!/bin/sh
apt update >> /var/log/mujlog
apt -y install mariadb-server >> /var/log/mujlog

echo 'bind-address = 0.0.0.0' >> /etc/mysql/mariadb.conf.d/50-server.cfg
systemctl restart mysql

mysql -e "CREATE DATABASE counter"
mysql -e "CREATE TABLE counter"
mysql -e "GRANT ALL ON counter.* TO counter@'10.0.0.%' IDENTIFIED BY 'counter'"