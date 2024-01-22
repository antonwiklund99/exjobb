#!/bin/bash
set -e
echo "Add tap"
ip tuntap add mode tap dev qemu_tap
echo "Up tap"
ip link set qemu_tap up
echo "Add ip to tap"
ip addr add 192.168.111.1/24 dev qemu_tap
echo "Add route for tap (192.168.111.0/24)"
ip route add 192.168.111.0/24 dev qemu_tap