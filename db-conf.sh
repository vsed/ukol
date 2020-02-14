#!/bin/sh
apt update > /var/log/mujlog
apt -y install haproxy > /var/log/mujlog