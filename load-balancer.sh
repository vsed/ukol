#!/bin/sh
apt update > /var/log/mujlog
apt -y install haproxy > /var/log/mujlog

echo '
frontend localnodes
    bind *:80
    mode http
    default_backend nodes

backend nodes
    mode http
    balance roundrobin
    option forwardfor
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request add-header X-Forwarded-Proto https if { ssl_fc }
    option httpchk HEAD / HTTP/1.1\r\nHost:localhost
    server web01 10.0.0.1:80 check
    server web02 10.0.0.2:80 check
    server web03 10.0.0.3:80 check
    server web04 10.0.0.4:80 check
    server web05 10.0.0.5:80 check
    server web06 10.0.0.6:80 check
    server web07 10.0.0.7:80 check
    server web08 10.0.0.8:80 check
    server web09 10.0.0.9:80 check
    server web10 10.0.0.10:80 check
    ' >> /etc/haproxy/haproxy.cfg
    systemctl restart haproxy
