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

# Start QEMU
cd "$HEAD"
qemu-system-x86_64 \
  -kernel build/linux-x86-basic/arch/x86_64/boot/bzImage \
  -boot c \#-initrd build/initramfs.cpio.gz \
  -hda buildroot/output/images/rootfs.ext4 \
  -nographic -append "root=/dev/sda rw console=ttyS0" \
  -enable-kvm \
  -netdev tap,id=t0,ifname=qemu_tap,script=no,downscript=no -device e1000,netdev=t0 \
  -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0