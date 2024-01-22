#!/bin/bash
HEAD=$(pwd)

# Busybox and file system
cd "$HEAD/build/initramfs/busybox-x86/"
find . -print0 | cpio --null -ov --format=newc | gzip -9 > "$HEAD/build/initramfs.cpio.gz"

## https://gist.github.com/ncmiller/d61348b27cb17debd2a6c20966409e86
#cd $HEAD/linux
##make O=../build/linux-x86-basic x86_64_defconfig
##make O=../build/linux-x86-basic kvm_guest.config
#make O=../build/linux-x86-basic
##https://gist.github.com/chrisdone/02e165a0004be33734ac2334f215380e
##https://medium.com/@daeseok.youn/prepare-the-environment-for-developing-linux-kernel-with-qemu-c55e37ba8ade
# make modules

# Networking
# sudo ip tuntap add mode tap dev qemu_tap
# sudo ip link set qemu_tap up promisc on
# sudo ip link add qemu_net type bridge
# sudo ip link set qemu_net up
# sudo ip link set qemu_tap master qemu_net
# sudo ip addr add 192.168.123.1/24 broadcast 192.168.123.255 dev qemu_net

# Start QEMU
cd "$HEAD"
qemu-system-x86_64 \
  -kernel build/linux-x86-basic/arch/x86_64/boot/bzImage \
  -initrd build/initramfs.cpio.gz \
  -nographic -append "console=ttyS0" \
  -enable-kvm \
  -netdev tap,id=t0,ifname=qemu_tap,script=no,downscript=no -device e1000,netdev=t0
#  -netdev tap,id=mynet0,ifname=qemu_tap,script=no,downscript=no \
#  -append "ip=192.168.123.2::192.168.123.1:255.255.255.0:::"
