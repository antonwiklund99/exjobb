#!/bin/bash
set -e

for i in 0 1
do
	subnet="192.168.$i$i$i"
	tap="qemu_tap$i"
	tap_ip="$subnet.2"
	ns="qemu_ns$i"
	br="qemu_br$i"
	veth="qemu_veth$i"
	veth_ip="$subnet.1"
	vpeer="qemu_vpeer$i"
	echo "Add tap $tap"
	ip tuntap add mode tap dev $tap
	ip addr add "$tap_ip/24" dev $tap
	ip link set $tap up
	echo "Create namespace $ns"
	ip netns add $ns
	echo "Create veth pair and bridge"
	ip link add dev $veth type veth peer $vpeer 
	ip link set $veth netns $ns 
	ip link add $br type bridge
	echo "Add address and routing for $veth in $ns"
	ip -n $ns addr add "$veth_ip/24" dev $veth 
	ip -n $ns link set $veth up
	ip -n $ns route add default via $veth_ip 
	ip -n $ns link set dev lo up
	echo "Add tap and vpeer to bridge"
	ip link set $tap master $br 
	ip link set $vpeer master $br
	echo "Up bridge and vpeer"
	ip link set $vpeer up
	ip link set $br up
done 
