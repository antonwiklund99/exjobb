#!/bin/sh
ip addr add 192.168.0.3/24 dev eth0
ip addr add 192.168.111.3/24 dev eth1
ip link set eth0 up
ip link set eth1 up
ip route add 192.168.0.0/24 dev eth0
ip route add 192.168.111.0/24 dev eth1
echo 1 > /proc/sys/net/ipv4/ip_forward
