#!/bin/sh
apt update > /var/log/mujlog
apt -y install apache2 > /var/log/mujlog
