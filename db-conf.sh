#!/bin/sh
apt update > /var/log/mujlog
apt -y install mariadb-server > /var/log/mujlog