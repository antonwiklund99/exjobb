## Buildroot
`make menuconfig` to configure.\
Checked options:
- Target Architecture = x86_64 (Target options)
- Enable C++ support (apperently needed by iperf3) (Toolchain)
- Disable 'Enable root login with password' (System configuration)
- Disable 'Run a getty (login prompt) after boot' (System configuration)
- Disable Linux Kernel (Kernel)
- Enable iperf3 (Target packages -> Networking applications)
- Enable ext2/3/4 root filesystem (Filesystem images)
    - ext4 variant
- Disable 'tar the root filesystem' (Filesystem images)

Copy init scripts to rootfs (maybe have to do one make before this):
```
cp inittab buildroot/output/target/etc/inittab 
cp setup_client_net.sh buildroot/output/target/etc/init.d/S41network_qemu
cp -p enable_events.sh buildroot/output/target/
cd buildroot
make
```

## Networking
Create tap between host and client called qemu_tap (no outside connection) on subnet 192.168.111.0/24. The host ip is **192.168.111.1** and the client **192.168.111.2**.

Run `setup_host_net.sh` to setup host network (create tap, assign ip and routing).\
Run `delete_host_net.sh` to remove the host network (remove tap and routing).
The script `setup_client_net.sh` is run during by the init script in qemu on boot which sets up ip and routing on the client

Need to enable this driver in the kernel for `-device rtl8139` to work. (Device Drivers -> Network device support -> Ethernet driver support -> RealTek RTL-8139 C+ PCI Fast Ethernet Adapter support)
![Enabled realtek network drivers](misc/realtek-network-drivers.png)

## Linux Kernel
```
mkdir linux-x86-build
cd linux

# Default configuration
make O=../linux-x86-build defconfig
make O=../linux-x86-build kvm_guest.config

# Further configuration
make O=../linux-x86-build menuconfig

# Build
make O=../linux-x86-build -j8 
```