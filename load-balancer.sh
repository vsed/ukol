#!/bin/sh
apt update >> /var/log/mujlog
apt -y install nmap haproxy >> /var/log/mujlog

echo '
frontend localnodes
    bind *:80
    mode http
    default_backend nodes

backend nodes
    mode http
    balance roundrobin
    option forwardfor
    option httpchk HEAD / HTTP/1.1\r\nHost:localhost' >> /etc/haproxy/haproxy.cfg


c=1
for i in $(nmap -sn 10.0.0.0/24|grep appvm| grep -o -E '((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')
do
echo '    server' srv$c $i:80 >> /etc/haproxy/haproxy.cfg
c=$((c+1))
done

systemctl restart haproxy
