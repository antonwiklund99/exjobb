#!/bin/bash
qemu-system-x86_64 \
  -kernel linux-x86-build/arch/x86_64/boot/bzImage \
  -boot c \
  -hda buildroot/output/images/rootfs.ext4 \
  -nographic -append "root=/dev/sda rw console=ttyS0 acpi=off nokaslr" \
  -enable-kvm \
  -netdev tap,id=t0,ifname=qemu_tap,script=no,downscript=no -device rtl8139,netdev=t0 \