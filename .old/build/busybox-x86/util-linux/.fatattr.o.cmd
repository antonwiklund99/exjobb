cmd_util-linux/fatattr.o := gcc -Wp,-MD,util-linux/.fatattr.o.d  -std=gnu99 -Iinclude -Ilibbb -Iinclude2 -I/home/anton/kernel_dev/busybox-1.36.1/include -I/home/anton/kernel_dev/busybox-1.36.1/libbb -include include/autoconf.h -D_GNU_SOURCE -DNDEBUG -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DBB_VER='"1.36.1"' -I/home/anton/kernel_dev/busybox-1.36.1/util-linux -Iutil-linux -malign-data=abi -Wall -Wshadow -Wwrite-strings -Wundef -Wstrict-prototypes -Wunused -Wunused-parameter -Wunused-function -Wunused-value -Wmissing-prototypes -Wmissing-declarations -Wno-format-security -Wdeclaration-after-statement -Wold-style-definition -finline-limit=0 -fno-builtin-strlen -fomit-frame-pointer -ffunction-sections -fdata-sections -fno-guess-branch-probability -funsigned-char -static-libgcc -falign-functions=1 -falign-jumps=1 -falign-labels=1 -falign-loops=1 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-builtin-printf -Oz  -DKBUILD_BASENAME='"fatattr"'  -DKBUILD_MODNAME='"fatattr"' -c -o util-linux/fatattr.o /home/anton/kernel_dev/busybox-1.36.1/util-linux/fatattr.c

deps_util-linux/fatattr.o := \
  /home/anton/kernel_dev/busybox-1.36.1/util-linux/fatattr.c \
    $(wildcard include/config/fatattr.h) \
  /usr/include/stdc-predef.h \
  /home/anton/kernel_dev/busybox-1.36.1/include/libbb.h \
    $(wildcard include/config/feature/shadowpasswds.h) \
    $(wildcard include/config/use/bb/shadow.h) \
    $(wildcard include/config/selinux.h) \
    $(wildcard include/config/feature/utmp.h) \
    $(wildcard include/config/locale/support.h) \
    $(wildcard include/config/use/bb/pwd/grp.h) \
    $(wildcard include/config/lfs.h) \
    $(wildcard include/config/feature/buffers/go/on/stack.h) \
    $(wildcard include/config/feature/buffers/go/in/bss.h) \
    $(wildcard include/config/extra/cflags.h) \
    $(wildcard include/config/variable/arch/pagesize.h) \
    $(wildcard include/config/feature/verbose.h) \
    $(wildcard include/config/feature/etc/services.h) \
    $(wildcard include/config/feature/ipv6.h) \
    $(wildcard include/config/feature/seamless/xz.h) \
    $(wildcard include/config/feature/seamless/lzma.h) \
    $(wildcard include/config/feature/seamless/bz2.h) \
    $(wildcard include/config/feature/seamless/gz.h) \
    $(wildcard include/config/feature/seamless/z.h) \
    $(wildcard include/config/float/duration.h) \
    $(wildcard include/config/feature/check/names.h) \
    $(wildcard include/config/feature/prefer/applets.h) \
    $(wildcard include/config/long/opts.h) \
    $(wildcard include/config/feature/pidfile.h) \
    $(wildcard include/config/feature/syslog.h) \
    $(wildcard include/config/feature/syslog/info.h) \
    $(wildcard include/config/warn/simple/msg.h) \
    $(wildcard include/config/feature/individual.h) \
    $(wildcard include/config/shell/ash.h) \
    $(wildcard include/config/shell/hush.h) \
    $(wildcard include/config/echo.h) \
    $(wildcard include/config/sleep.h) \
    $(wildcard include/config/printf.h) \
    $(wildcard include/config/test.h) \
    $(wildcard include/config/test1.h) \
    $(wildcard include/config/test2.h) \
    $(wildcard include/config/kill.h) \
    $(wildcard include/config/killall.h) \
    $(wildcard include/config/killall5.h) \
    $(wildcard include/config/chown.h) \
    $(wildcard include/config/ls.h) \
    $(wildcard include/config/xxx.h) \
    $(wildcard include/config/route.h) \
    $(wildcard include/config/feature/hwib.h) \
    $(wildcard include/config/desktop.h) \
    $(wildcard include/config/feature/crond/d.h) \
    $(wildcard include/config/feature/setpriv/capabilities.h) \
    $(wildcard include/config/run/init.h) \
    $(wildcard include/config/feature/securetty.h) \
    $(wildcard include/config/pam.h) \
    $(wildcard include/config/use/bb/crypt.h) \
    $(wildcard include/config/feature/adduser/to/group.h) \
    $(wildcard include/config/feature/del/user/from/group.h) \
    $(wildcard include/config/ioctl/hex2str/error.h) \
    $(wildcard include/config/feature/editing.h) \
    $(wildcard include/config/feature/editing/history.h) \
    $(wildcard include/config/feature/tab/completion.h) \
    $(wildcard include/config/feature/username/completion.h) \
    $(wildcard include/config/feature/editing/fancy/prompt.h) \
    $(wildcard include/config/feature/editing/savehistory.h) \
    $(wildcard include/config/feature/editing/vi.h) \
    $(wildcard include/config/feature/editing/save/on/exit.h) \
    $(wildcard include/config/pmap.h) \
    $(wildcard include/config/feature/show/threads.h) \
    $(wildcard include/config/feature/ps/additional/columns.h) \
    $(wildcard include/config/feature/topmem.h) \
    $(wildcard include/config/feature/top/smp/process.h) \
    $(wildcard include/config/pgrep.h) \
    $(wildcard include/config/pkill.h) \
    $(wildcard include/config/pidof.h) \
    $(wildcard include/config/sestatus.h) \
    $(wildcard include/config/unicode/support.h) \
    $(wildcard include/config/feature/mtab/support.h) \
    $(wildcard include/config/feature/clean/up.h) \
    $(wildcard include/config/feature/devfs.h) \
  /home/anton/kernel_dev/busybox-1.36.1/include/platform.h \
    $(wildcard include/config/werror.h) \
    $(wildcard include/config/big/endian.h) \
    $(wildcard include/config/little/endian.h) \
    $(wildcard include/config/nommu.h) \
  /usr/lib/gcc/x86_64-redhat-linux/13/include/limits.h \
  /usr/lib/gcc/x86_64-redhat-linux/13/include/syslimits.h \
  /usr/include/limits.h \
  /usr/include/bits/libc-header-start.h \
  /usr/include/features.h \
  /usr/include/features-time64.h \
  /usr/include/bits/wordsize.h \
  /usr/include/bits/timesize.h \
  /usr/include/sys/cdefs.h \
  /usr/include/bits/long-double.h \
  /usr/include/gnu/stubs.h \
  /usr/include/gnu/stubs-64.h \
  /usr/include/bits/posix1_lim.h \
  /usr/include/bits/local_lim.h \
  /usr/include/linux/limits.h \
  /usr/include/bits/pthread_stack_min-dynamic.h \
  /usr/include/bits/posix2_lim.h \
  /usr/include/bits/xopen_lim.h \
  /usr/include/bits/uio_lim.h \
  /usr/include/byteswap.h \
  /usr/include/bits/byteswap.h \
  /usr/include/bits/types.h \
  /usr/include/bits/typesizes.h \
  /usr/include/bits/time64.h \
  /usr/include/endian.h \
  /usr/include/bits/endian.h \
  /usr/include/bits/endianness.h \
  /usr/include/bits/uintn-identity.h \
  /usr/lib/gcc/x86_64-redhat-linux/13/include/stdint.h \
  /usr/include/stdint.h \
  /usr/include/bits/wchar.h \
  /usr/include/bits/stdint-intn.h \
  /usr/include/bits/stdint-uintn.h \
  /usr/lib/gcc/x86_64-redhat-linux/13/include/stdbool.h \
  /usr/include/unistd.h \
  /usr/include/bits/posix_opt.h \
  /usr/include/bits/environments.h \
  /usr/lib/gcc/x86_64-redhat-linux/13/include/stddef.h \
  /usr/include/bits/confname.h \
  /usr/include/bits/getopt_posix.h \
  /usr/include/bits/getopt_core.h \
  /usr/include/bits/unistd_ext.h \
  /usr/include/linux/close_range.h \
  /usr/include/ctype.h \
  /usr/include/bits/types/locale_t.h \
  /usr/include/bits/types/__locale_t.h \
  /usr/include/dirent.h \
  /usr/include/bits/dirent.h \
  /usr/include/bits/dirent_ext.h \
  /usr/include/errno.h \
  /usr/include/bits/errno.h \
  /usr/include/linux/errno.h \
  /usr/include/asm/errno.h \
  /usr/include/asm-generic/errno.h \
  /usr/include/asm-generic/errno-base.h \
  /usr/include/bits/types/error_t.h \
  /usr/include/fcntl.h \
  /usr/include/bits/fcntl.h \
  /usr/include/bits/fcntl-linux.h \
  /usr/include/bits/types/struct_iovec.h \
  /usr/include/linux/falloc.h \
  /usr/include/bits/types/struct_timespec.h \
  /usr/include/bits/types/time_t.h \
  /usr/include/bits/stat.h \
  /usr/include/bits/struct_stat.h \
  /usr/include/inttypes.h \
  /usr/include/netdb.h \
  /usr/include/netinet/in.h \
  /usr/include/sys/socket.h \
  /usr/include/bits/socket.h \
  /usr/include/sys/types.h \
  /usr/include/bits/types/clock_t.h \
  /usr/include/bits/types/clockid_t.h \
  /usr/include/bits/types/timer_t.h \
  /usr/include/sys/select.h \
  /usr/include/bits/select.h \
  /usr/include/bits/types/sigset_t.h \
  /usr/include/bits/types/__sigset_t.h \
  /usr/include/bits/types/struct_timeval.h \
  /usr/include/bits/pthreadtypes.h \
  /usr/include/bits/thread-shared-types.h \
  /usr/include/bits/pthreadtypes-arch.h \
  /usr/include/bits/atomic_wide_counter.h \
  /usr/include/bits/struct_mutex.h \
  /usr/include/bits/struct_rwlock.h \
  /usr/include/bits/socket_type.h \
  /usr/include/bits/sockaddr.h \
  /usr/include/asm/socket.h \
  /usr/include/asm-generic/socket.h \
  /usr/include/linux/posix_types.h \
  /usr/include/linux/stddef.h \
  /usr/include/asm/posix_types.h \
  /usr/include/asm/posix_types_64.h \
  /usr/include/asm-generic/posix_types.h \
  /usr/include/asm/bitsperlong.h \
  /usr/include/asm-generic/bitsperlong.h \
    $(wildcard include/config/64bit.h) \
  /usr/include/asm/sockios.h \
  /usr/include/asm-generic/sockios.h \
  /usr/include/bits/types/struct_osockaddr.h \
  /usr/include/bits/in.h \
  /usr/include/rpc/netdb.h \
  /usr/include/bits/types/sigevent_t.h \
  /usr/include/bits/types/__sigval_t.h \
  /usr/include/bits/netdb.h \
  /usr/include/setjmp.h \
  /usr/include/bits/setjmp.h \
  /usr/include/bits/types/struct___jmp_buf_tag.h \
  /usr/include/signal.h \
  /usr/include/bits/signum-generic.h \
  /usr/include/bits/signum-arch.h \
  /usr/include/bits/types/sig_atomic_t.h \
  /usr/include/bits/types/siginfo_t.h \
  /usr/include/bits/siginfo-arch.h \
  /usr/include/bits/siginfo-consts.h \
  /usr/include/bits/siginfo-consts-arch.h \
  /usr/include/bits/types/sigval_t.h \
  /usr/include/bits/sigevent-consts.h \
  /usr/include/bits/sigaction.h \
  /usr/include/bits/sigcontext.h \
  /usr/include/bits/types/stack_t.h \
  /usr/include/sys/ucontext.h \
  /usr/include/bits/sigstack.h \
  /usr/include/bits/sigstksz.h \
  /usr/include/bits/ss_flags.h \
  /usr/include/bits/types/struct_sigstack.h \
  /usr/include/bits/sigthread.h \
  /usr/include/bits/signal_ext.h \
  /usr/include/paths.h \
  /usr/include/stdio.h \
  /usr/lib/gcc/x86_64-redhat-linux/13/include/stdarg.h \
  /usr/include/bits/types/__fpos_t.h \
  /usr/include/bits/types/__mbstate_t.h \
  /usr/include/bits/types/__fpos64_t.h \
  /usr/include/bits/types/__FILE.h \
  /usr/include/bits/types/FILE.h \
  /usr/include/bits/types/struct_FILE.h \
  /usr/include/bits/types/cookie_io_functions_t.h \
  /usr/include/bits/stdio_lim.h \
  /usr/include/bits/floatn.h \
  /usr/include/bits/floatn-common.h \
  /usr/include/stdlib.h \
  /usr/include/bits/waitflags.h \
  /usr/include/bits/waitstatus.h \
  /usr/include/alloca.h \
  /usr/include/bits/stdlib-float.h \
  /usr/include/string.h \
  /usr/include/strings.h \
  /usr/include/libgen.h \
  /usr/include/poll.h \
  /usr/include/sys/poll.h \
  /usr/include/bits/poll.h \
  /usr/include/sys/ioctl.h \
  /usr/include/bits/ioctls.h \
  /usr/include/asm/ioctls.h \
  /usr/include/asm-generic/ioctls.h \
  /usr/include/linux/ioctl.h \
  /usr/include/asm/ioctl.h \
  /usr/include/asm-generic/ioctl.h \
  /usr/include/bits/ioctl-types.h \
  /usr/include/sys/ttydefaults.h \
  /usr/include/sys/mman.h \
  /usr/include/bits/mman.h \
  /usr/include/bits/mman-map-flags-generic.h \
  /usr/include/bits/mman-linux.h \
  /usr/include/bits/mman-shared.h \
  /usr/include/bits/mman_ext.h \
  /usr/include/sys/resource.h \
  /usr/include/bits/resource.h \
  /usr/include/bits/types/struct_rusage.h \
  /usr/include/sys/stat.h \
  /usr/include/bits/statx.h \
  /usr/include/linux/stat.h \
  /usr/include/linux/types.h \
  /usr/include/asm/types.h \
  /usr/include/asm-generic/types.h \
  /usr/include/asm-generic/int-ll64.h \
  /usr/include/bits/statx-generic.h \
  /usr/include/bits/types/struct_statx_timestamp.h \
  /usr/include/bits/types/struct_statx.h \
  /usr/include/sys/time.h \
  /usr/include/sys/sysmacros.h \
  /usr/include/bits/sysmacros.h \
  /usr/include/sys/wait.h \
  /usr/include/bits/types/idtype_t.h \
  /usr/include/termios.h \
  /usr/include/bits/termios.h \
  /usr/include/bits/termios-struct.h \
  /usr/include/bits/termios-c_cc.h \
  /usr/include/bits/termios-c_iflag.h \
  /usr/include/bits/termios-c_oflag.h \
  /usr/include/bits/termios-baud.h \
  /usr/include/bits/termios-c_cflag.h \
  /usr/include/bits/termios-c_lflag.h \
  /usr/include/bits/termios-tcflow.h \
  /usr/include/bits/termios-misc.h \
  /usr/include/time.h \
  /usr/include/bits/time.h \
  /usr/include/bits/timex.h \
  /usr/include/bits/types/struct_tm.h \
  /usr/include/bits/types/struct_itimerspec.h \
  /usr/include/sys/param.h \
  /usr/include/bits/param.h \
  /usr/include/linux/param.h \
  /usr/include/asm/param.h \
  /usr/include/asm-generic/param.h \
  /usr/include/pwd.h \
  /usr/include/grp.h \
  /usr/include/mntent.h \
  /usr/include/sys/statfs.h \
  /usr/include/bits/statfs.h \
  /usr/include/utmp.h \
  /usr/include/bits/utmp.h \
  /usr/include/utmpx.h \
  /usr/include/bits/utmpx.h \
  /usr/include/arpa/inet.h \
  /home/anton/kernel_dev/busybox-1.36.1/include/pwd_.h \
  /home/anton/kernel_dev/busybox-1.36.1/include/grp_.h \
  /home/anton/kernel_dev/busybox-1.36.1/include/shadow_.h \
  /home/anton/kernel_dev/busybox-1.36.1/include/xatonum.h \

util-linux/fatattr.o: $(deps_util-linux/fatattr.o)

$(deps_util-linux/fatattr.o):
