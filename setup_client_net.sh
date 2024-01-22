#!/bin/sh
ip addr add 192.168.111.2/24 dev eth0
ip link set eth0 up
ip route add 192.168.111.0/24 dev eth0