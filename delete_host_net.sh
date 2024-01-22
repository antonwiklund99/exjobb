#!/bin/bash
set -e
ip route del 192.168.111.0/24 dev qemu_tap
ip link set qemu_tap down
ip tuntap del mode tap dev qemu_tap