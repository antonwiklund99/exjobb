#!/bin/bash

BUILD_DIR="linux-x86-build"
if [[ $# -eq 1 ]] && [[ "$1" == "clean" ]]; then
  BUILD_DIR="linux-x86-clean-build"
fi

qemu-system-x86_64 \
  -kernel "$BUILD_DIR/arch/x86_64/boot/bzImage" \
  -boot c \
  -hda buildroot/output/images/rootfs.ext4 \
  -nographic -append "root=/dev/sda rw console=ttyS0 acpi=off nokaslr" \
  -enable-kvm \
  -netdev tap,id=t0,ifname=qemu_tap,script=no,downscript=no -device e1000,netdev=t0 \
