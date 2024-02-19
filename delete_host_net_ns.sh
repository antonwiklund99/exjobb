#!/bin/bash
set -e
for i in 0 1
do
	ip link del "qemu_tap$i"
	ip link del "qemu_vpeer$i"
	ip link del "qemu_br$i"
	ip netns del "qemu_ns$i"
done
