savedcmd_/home/anton/kernel_dev/test_module/test_module.o := gcc -Wp,-MMD,/home/anton/kernel_dev/test_module/.test_module.o.d -nostdinc -I/home/anton/kernel_dev/linux/arch/x86/include -I./arch/x86/include/generated -I/home/anton/kernel_dev/linux/include -I./include -I/home/anton/kernel_dev/linux/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/anton/kernel_dev/linux/include/uapi -I./include/generated/uapi -include /home/anton/kernel_dev/linux/include/linux/compiler-version.h -include /home/anton/kernel_dev/linux/include/linux/kconfig.h -include /home/anton/kernel_dev/linux/include/linux/compiler_types.h -D__KERNEL__ -fmacro-prefix-map=/home/anton/kernel_dev/linux/= -Werror -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=branch -fno-jump-tables -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -fno-jump-tables -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fomit-frame-pointer -ftrivial-auto-var-init=zero -fno-stack-clash-protection -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fno-stack-check -fconserve-stack -Wall -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wmissing-declarations -Wmissing-prototypes -Wframe-larger-than=2048 -Wno-main -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-dangling-pointer -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-restrict -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-overflow -Wno-stringop-truncation -Wno-missing-field-initializers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare  -DMODULE  -DKBUILD_BASENAME='"test_module"' -DKBUILD_MODNAME='"test_module"' -D__KBUILD_MODNAME=kmod_test_module -c -o /home/anton/kernel_dev/test_module/test_module.o /home/anton/kernel_dev/test_module/test_module.c   ; ./tools/objtool/objtool --hacks=jump_label --hacks=noinstr --hacks=skylake --ibt --orc --retpoline --rethunk --static-call --uaccess --prefix=16  --link  --module /home/anton/kernel_dev/test_module/test_module.o

source_/home/anton/kernel_dev/test_module/test_module.o := /home/anton/kernel_dev/test_module/test_module.c

deps_/home/anton/kernel_dev/test_module/test_module.o := \
  /home/anton/kernel_dev/linux/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/anton/kernel_dev/linux/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/anton/kernel_dev/linux/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/anton/kernel_dev/linux/include/linux/compiler_attributes.h \
  /home/anton/kernel_dev/linux/include/linux/compiler-gcc.h \
    $(wildcard include/config/RETPOLINE) \
    $(wildcard include/config/ARCH_USE_BUILTIN_BSWAP) \
    $(wildcard include/config/SHADOW_CALL_STACK) \
    $(wildcard include/config/KCOV) \
  /home/anton/kernel_dev/linux/include/linux/init.h \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
    $(wildcard include/config/STRICT_KERNEL_RWX) \
    $(wildcard include/config/STRICT_MODULE_RWX) \
    $(wildcard include/config/LTO_CLANG) \
  /home/anton/kernel_dev/linux/include/linux/build_bug.h \
  /home/anton/kernel_dev/linux/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  arch/x86/include/generated/asm/rwonce.h \
  /home/anton/kernel_dev/linux/include/asm-generic/rwonce.h \
  /home/anton/kernel_dev/linux/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /home/anton/kernel_dev/linux/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /home/anton/kernel_dev/linux/include/uapi/linux/types.h \
  arch/x86/include/generated/uapi/asm/types.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/types.h \
  /home/anton/kernel_dev/linux/include/asm-generic/int-ll64.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/int-ll64.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/bitsperlong.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitsperlong.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/bitsperlong.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/posix_types.h \
  /home/anton/kernel_dev/linux/include/linux/stddef.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/stddef.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/posix_types.h \
    $(wildcard include/config/X86_32) \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/posix_types_64.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/posix_types.h \
  /home/anton/kernel_dev/linux/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/anton/kernel_dev/linux/include/linux/stringify.h \
  /home/anton/kernel_dev/linux/include/linux/module.h \
    $(wildcard include/config/MODULES) \
    $(wildcard include/config/SYSFS) \
    $(wildcard include/config/MODULES_TREE_LOOKUP) \
    $(wildcard include/config/LIVEPATCH) \
    $(wildcard include/config/STACKTRACE_BUILD_ID) \
    $(wildcard include/config/ARCH_USES_CFI_TRAPS) \
    $(wildcard include/config/MODULE_SIG) \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/KALLSYMS) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/TRACEPOINTS) \
    $(wildcard include/config/TREE_SRCU) \
    $(wildcard include/config/BPF_EVENTS) \
    $(wildcard include/config/DEBUG_INFO_BTF_MODULES) \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/EVENT_TRACING) \
    $(wildcard include/config/FTRACE_MCOUNT_RECORD) \
    $(wildcard include/config/KPROBES) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
    $(wildcard include/config/KUNIT) \
    $(wildcard include/config/PRINTK_INDEX) \
    $(wildcard include/config/MODULE_UNLOAD) \
    $(wildcard include/config/CONSTRUCTORS) \
    $(wildcard include/config/FUNCTION_ERROR_INJECTION) \
    $(wildcard include/config/DYNAMIC_DEBUG_CORE) \
  /home/anton/kernel_dev/linux/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /home/anton/kernel_dev/linux/include/linux/container_of.h \
  /home/anton/kernel_dev/linux/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /home/anton/kernel_dev/linux/include/linux/const.h \
  /home/anton/kernel_dev/linux/include/vdso/const.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/const.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/barrier.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/asm.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/extable_fixup_types.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/nops.h \
  /home/anton/kernel_dev/linux/include/asm-generic/barrier.h \
  /home/anton/kernel_dev/linux/include/linux/stat.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/stat.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/stat.h \
  /home/anton/kernel_dev/linux/include/linux/time.h \
    $(wildcard include/config/POSIX_TIMERS) \
  /home/anton/kernel_dev/linux/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/anton/kernel_dev/linux/include/uapi/linux/kernel.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/sysinfo.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /home/anton/kernel_dev/linux/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/anton/kernel_dev/linux/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/RETHUNK) \
    $(wildcard include/config/SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
  /home/anton/kernel_dev/linux/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/anton/kernel_dev/linux/include/linux/math.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/div64.h \
  /home/anton/kernel_dev/linux/include/asm-generic/div64.h \
  /home/anton/kernel_dev/linux/include/vdso/math64.h \
  /home/anton/kernel_dev/linux/include/linux/time64.h \
  /home/anton/kernel_dev/linux/include/vdso/time64.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/time.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/time_types.h \
  /home/anton/kernel_dev/linux/include/linux/time32.h \
  /home/anton/kernel_dev/linux/include/linux/timex.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/timex.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/param.h \
  arch/x86/include/generated/uapi/asm/param.h \
  /home/anton/kernel_dev/linux/include/asm-generic/param.h \
    $(wildcard include/config/HZ) \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/param.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/timex.h \
    $(wildcard include/config/X86_TSC) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/processor.h \
    $(wildcard include/config/X86_VMX_FEATURE_NAMES) \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/X86_USER_SHADOW_STACK) \
    $(wildcard include/config/PARAVIRT_XXL) \
    $(wildcard include/config/X86_DEBUGCTLMSR) \
    $(wildcard include/config/CPU_SUP_AMD) \
    $(wildcard include/config/XEN) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/PAGE_TABLE_ISOLATION) \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/processor-flags.h \
  /home/anton/kernel_dev/linux/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/mem_encrypt.h \
    $(wildcard include/config/X86_MEM_ENCRYPT) \
  /home/anton/kernel_dev/linux/include/linux/cc_platform.h \
    $(wildcard include/config/ARCH_HAS_CC_PLATFORM) \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/bootparam.h \
  /home/anton/kernel_dev/linux/include/linux/screen_info.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/screen_info.h \
  /home/anton/kernel_dev/linux/include/linux/apm_bios.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/apm_bios.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/ioctl.h \
  arch/x86/include/generated/uapi/asm/ioctl.h \
  /home/anton/kernel_dev/linux/include/asm-generic/ioctl.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/ioctl.h \
  /home/anton/kernel_dev/linux/include/linux/edd.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/edd.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/ist.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/ist.h \
  /home/anton/kernel_dev/linux/include/video/edid.h \
    $(wildcard include/config/X86) \
  /home/anton/kernel_dev/linux/include/uapi/video/edid.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/math_emu.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/PARAVIRT) \
    $(wildcard include/config/IA32_EMULATION) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/segment.h \
    $(wildcard include/config/XEN_PV) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/kaslr.h \
    $(wildcard include/config/RANDOMIZE_MEMORY) \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/ptrace.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/ptrace-abi.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/paravirt_types.h \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/ZERO_CALL_USED_REGS) \
    $(wildcard include/config/PARAVIRT_DEBUG) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/desc_defs.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/X86_INTEL_MEMORY_PROTECTION_KEYS) \
    $(wildcard include/config/X86_PAE) \
    $(wildcard include/config/MEM_SOFT_DIRTY) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
    $(wildcard include/config/PROC_FS) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pgtable_64_types.h \
    $(wildcard include/config/KMSAN) \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/sparsemem.h \
    $(wildcard include/config/SPARSEMEM) \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/nospec-branch.h \
    $(wildcard include/config/CALL_THUNKS_DEBUG) \
    $(wildcard include/config/CALL_DEPTH_TRACKING) \
    $(wildcard include/config/NOINSTR_VALIDATION) \
    $(wildcard include/config/CPU_UNRET_ENTRY) \
    $(wildcard include/config/CPU_SRSO) \
    $(wildcard include/config/CPU_IBPB_ENTRY) \
  /home/anton/kernel_dev/linux/include/linux/static_key.h \
  /home/anton/kernel_dev/linux/include/linux/jump_label.h \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/jump_label.h \
    $(wildcard include/config/HAVE_JUMP_LABEL_HACK) \
  /home/anton/kernel_dev/linux/include/linux/objtool.h \
    $(wildcard include/config/FRAME_POINTER) \
  /home/anton/kernel_dev/linux/include/linux/objtool_types.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cpufeatures.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/required-features.h \
    $(wildcard include/config/X86_MINIMUM_CPU_FAMILY) \
    $(wildcard include/config/MATH_EMULATION) \
    $(wildcard include/config/X86_CMPXCHG64) \
    $(wildcard include/config/X86_CMOV) \
    $(wildcard include/config/X86_P6_NOP) \
    $(wildcard include/config/MATOM) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/disabled-features.h \
    $(wildcard include/config/X86_UMIP) \
    $(wildcard include/config/ADDRESS_MASKING) \
    $(wildcard include/config/INTEL_IOMMU_SVM) \
    $(wildcard include/config/X86_SGX) \
    $(wildcard include/config/INTEL_TDX_GUEST) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/msr-index.h \
  /home/anton/kernel_dev/linux/include/linux/bits.h \
  /home/anton/kernel_dev/linux/include/vdso/bits.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/unwind_hints.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/orc_types.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/byteorder.h \
  /home/anton/kernel_dev/linux/include/linux/byteorder/little_endian.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/byteorder/little_endian.h \
  /home/anton/kernel_dev/linux/include/linux/swab.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/swab.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/swab.h \
  /home/anton/kernel_dev/linux/include/linux/byteorder/generic.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/X86_64_SMP) \
  /home/anton/kernel_dev/linux/include/asm-generic/percpu.h \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /home/anton/kernel_dev/linux/include/linux/threads.h \
    $(wildcard include/config/NR_CPUS) \
    $(wildcard include/config/BASE_SMALL) \
  /home/anton/kernel_dev/linux/include/linux/percpu-defs.h \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/current.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/asm-offsets.h \
  include/generated/asm-offsets.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/GEN-for-each-reg.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/spinlock_types.h \
  /home/anton/kernel_dev/linux/include/asm-generic/qspinlock_types.h \
  /home/anton/kernel_dev/linux/include/asm-generic/qrwlock_types.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/proto.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/ldt.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/sigcontext.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cpuid.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/string.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/string_64.h \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/page.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/page_64.h \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/X86_VSYSCALL_EMULATION) \
  /home/anton/kernel_dev/linux/include/linux/kmsan-checks.h \
  /home/anton/kernel_dev/linux/include/linux/range.h \
  /home/anton/kernel_dev/linux/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
  /home/anton/kernel_dev/linux/include/linux/pfn.h \
  /home/anton/kernel_dev/linux/include/asm-generic/getorder.h \
  /home/anton/kernel_dev/linux/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
  /home/anton/kernel_dev/linux/include/linux/bitops.h \
  /home/anton/kernel_dev/linux/include/linux/typecheck.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/generic-non-atomic.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/bitops.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/rmwcc.h \
  /home/anton/kernel_dev/linux/include/linux/args.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/sched.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/arch_hweight.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/const_hweight.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/instrumented-atomic.h \
  /home/anton/kernel_dev/linux/include/linux/instrumented.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/instrumented-non-atomic.h \
    $(wildcard include/config/KCSAN_ASSUME_PLAIN_WRITES_ATOMIC) \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/instrumented-lock.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/le.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/msr.h \
  arch/x86/include/generated/uapi/asm/errno.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/errno.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/errno-base.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cpumask.h \
  /home/anton/kernel_dev/linux/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/anton/kernel_dev/linux/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/PROVE_LOCKING) \
  /home/anton/kernel_dev/linux/include/linux/stdarg.h \
  /home/anton/kernel_dev/linux/include/linux/align.h \
  /home/anton/kernel_dev/linux/include/linux/array_size.h \
  /home/anton/kernel_dev/linux/include/linux/limits.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/limits.h \
  /home/anton/kernel_dev/linux/include/vdso/limits.h \
  /home/anton/kernel_dev/linux/include/linux/hex.h \
  /home/anton/kernel_dev/linux/include/linux/kstrtox.h \
  /home/anton/kernel_dev/linux/include/linux/minmax.h \
  /home/anton/kernel_dev/linux/include/linux/panic.h \
    $(wildcard include/config/PANIC_TIMEOUT) \
  /home/anton/kernel_dev/linux/include/linux/printk.h \
    $(wildcard include/config/MESSAGE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_QUIET) \
    $(wildcard include/config/EARLY_PRINTK) \
    $(wildcard include/config/PRINTK) \
    $(wildcard include/config/DYNAMIC_DEBUG) \
  /home/anton/kernel_dev/linux/include/linux/kern_levels.h \
  /home/anton/kernel_dev/linux/include/linux/ratelimit_types.h \
  /home/anton/kernel_dev/linux/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/DEBUG_SPINLOCK) \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
  /home/anton/kernel_dev/linux/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/LOCK_STAT) \
  /home/anton/kernel_dev/linux/include/linux/once_lite.h \
  /home/anton/kernel_dev/linux/include/linux/sprintf.h \
  /home/anton/kernel_dev/linux/include/linux/static_call_types.h \
    $(wildcard include/config/HAVE_STATIC_CALL) \
  /home/anton/kernel_dev/linux/include/linux/instruction_pointer.h \
  /home/anton/kernel_dev/linux/include/linux/bitmap.h \
  /home/anton/kernel_dev/linux/include/linux/errno.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/errno.h \
  /home/anton/kernel_dev/linux/include/linux/find.h \
  /home/anton/kernel_dev/linux/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
    $(wildcard include/config/FORTIFY_SOURCE) \
  /home/anton/kernel_dev/linux/include/linux/err.h \
  /home/anton/kernel_dev/linux/include/linux/overflow.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/string.h \
  /home/anton/kernel_dev/linux/include/linux/bitmap-str.h \
  /home/anton/kernel_dev/linux/include/linux/atomic.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/atomic.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cmpxchg.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cmpxchg_64.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/atomic64_64.h \
  /home/anton/kernel_dev/linux/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /home/anton/kernel_dev/linux/include/linux/atomic/atomic-long.h \
  /home/anton/kernel_dev/linux/include/linux/atomic/atomic-instrumented.h \
  /home/anton/kernel_dev/linux/include/linux/bug.h \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /home/anton/kernel_dev/linux/include/linux/instrumentation.h \
  /home/anton/kernel_dev/linux/include/asm-generic/bug.h \
    $(wildcard include/config/BUG) \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /home/anton/kernel_dev/linux/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
  /home/anton/kernel_dev/linux/include/linux/numa.h \
    $(wildcard include/config/NODES_SHIFT) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/msr.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/shared/msr.h \
  /home/anton/kernel_dev/linux/include/linux/tracepoint-defs.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/special_insns.h \
  /home/anton/kernel_dev/linux/include/linux/irqflags.h \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/PREEMPT_RT) \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /home/anton/kernel_dev/linux/include/linux/irqflags_types.h \
  /home/anton/kernel_dev/linux/include/linux/cleanup.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/irqflags.h \
    $(wildcard include/config/DEBUG_ENTRY) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/fpu/types.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/vmxfeatures.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/vdso/processor.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/shstk.h \
  /home/anton/kernel_dev/linux/include/linux/personality.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/personality.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/tsc.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/cpufeature.h \
  /home/anton/kernel_dev/linux/include/vdso/time32.h \
  /home/anton/kernel_dev/linux/include/vdso/time.h \
  /home/anton/kernel_dev/linux/include/linux/uidgid.h \
    $(wildcard include/config/MULTIUSER) \
    $(wildcard include/config/USER_NS) \
  /home/anton/kernel_dev/linux/include/linux/uidgid_types.h \
  /home/anton/kernel_dev/linux/include/linux/highuid.h \
  /home/anton/kernel_dev/linux/include/linux/buildid.h \
    $(wildcard include/config/CRASH_CORE) \
  /home/anton/kernel_dev/linux/include/linux/kmod.h \
  /home/anton/kernel_dev/linux/include/linux/umh.h \
  /home/anton/kernel_dev/linux/include/linux/gfp.h \
    $(wildcard include/config/HIGHMEM) \
    $(wildcard include/config/ZONE_DMA) \
    $(wildcard include/config/ZONE_DMA32) \
    $(wildcard include/config/ZONE_DEVICE) \
    $(wildcard include/config/CONTIG_ALLOC) \
  /home/anton/kernel_dev/linux/include/linux/mmzone.h \
    $(wildcard include/config/ARCH_FORCE_MAX_ORDER) \
    $(wildcard include/config/CMA) \
    $(wildcard include/config/MEMORY_ISOLATION) \
    $(wildcard include/config/ZSMALLOC) \
    $(wildcard include/config/UNACCEPTED_MEMORY) \
    $(wildcard include/config/SWAP) \
    $(wildcard include/config/NUMA_BALANCING) \
    $(wildcard include/config/TRANSPARENT_HUGEPAGE) \
    $(wildcard include/config/LRU_GEN) \
    $(wildcard include/config/LRU_GEN_STATS) \
    $(wildcard include/config/LRU_GEN_WALKS_MMU) \
    $(wildcard include/config/MEMCG) \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/COMPACTION) \
    $(wildcard include/config/MEMORY_FAILURE) \
    $(wildcard include/config/PAGE_EXTENSION) \
    $(wildcard include/config/DEFERRED_STRUCT_PAGE_INIT) \
    $(wildcard include/config/HAVE_MEMORYLESS_NODES) \
    $(wildcard include/config/SPARSEMEM_EXTREME) \
    $(wildcard include/config/HAVE_ARCH_PFN_VALID) \
  /home/anton/kernel_dev/linux/include/linux/spinlock.h \
    $(wildcard include/config/PREEMPTION) \
  /home/anton/kernel_dev/linux/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/preempt.h \
  /home/anton/kernel_dev/linux/include/linux/thread_info.h \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/GENERIC_ENTRY) \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/HARDENED_USERCOPY) \
    $(wildcard include/config/SH) \
  /home/anton/kernel_dev/linux/include/linux/restart_block.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/COMPAT) \
  /home/anton/kernel_dev/linux/include/linux/bottom_half.h \
  /home/anton/kernel_dev/linux/include/linux/lockdep.h \
    $(wildcard include/config/DEBUG_LOCKING_API_SELFTESTS) \
  /home/anton/kernel_dev/linux/include/linux/smp.h \
    $(wildcard include/config/UP_LATE_INIT) \
  /home/anton/kernel_dev/linux/include/linux/smp_types.h \
  /home/anton/kernel_dev/linux/include/linux/llist.h \
    $(wildcard include/config/ARCH_HAVE_NMI_SAFE_CMPXCHG) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/smp.h \
    $(wildcard include/config/DEBUG_NMI_SELFTEST) \
  arch/x86/include/generated/asm/mmiowb.h \
  /home/anton/kernel_dev/linux/include/asm-generic/mmiowb.h \
    $(wildcard include/config/MMIOWB) \
  /home/anton/kernel_dev/linux/include/linux/spinlock_types.h \
  /home/anton/kernel_dev/linux/include/linux/rwlock_types.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/spinlock.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/paravirt.h \
    $(wildcard include/config/PARAVIRT_SPINLOCKS) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/frame.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/qspinlock.h \
  /home/anton/kernel_dev/linux/include/asm-generic/qspinlock.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/qrwlock.h \
  /home/anton/kernel_dev/linux/include/asm-generic/qrwlock.h \
  /home/anton/kernel_dev/linux/include/linux/rwlock.h \
    $(wildcard include/config/PREEMPT) \
  /home/anton/kernel_dev/linux/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/INLINE_SPIN_LOCK) \
    $(wildcard include/config/INLINE_SPIN_LOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK_BH) \
    $(wildcard include/config/UNINLINE_SPIN_UNLOCK) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/GENERIC_LOCKBREAK) \
  /home/anton/kernel_dev/linux/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/INLINE_READ_LOCK) \
    $(wildcard include/config/INLINE_WRITE_LOCK) \
    $(wildcard include/config/INLINE_READ_LOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_LOCK_BH) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_READ_TRYLOCK) \
    $(wildcard include/config/INLINE_WRITE_TRYLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_BH) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQRESTORE) \
  /home/anton/kernel_dev/linux/include/linux/list_nulls.h \
  /home/anton/kernel_dev/linux/include/linux/wait.h \
  /home/anton/kernel_dev/linux/include/linux/seqlock.h \
  /home/anton/kernel_dev/linux/include/linux/mutex.h \
    $(wildcard include/config/DEBUG_MUTEXES) \
  /home/anton/kernel_dev/linux/include/linux/osq_lock.h \
  /home/anton/kernel_dev/linux/include/linux/debug_locks.h \
  /home/anton/kernel_dev/linux/include/linux/mutex_types.h \
    $(wildcard include/config/MUTEX_SPIN_ON_OWNER) \
  /home/anton/kernel_dev/linux/include/linux/seqlock_types.h \
  /home/anton/kernel_dev/linux/include/linux/nodemask.h \
  /home/anton/kernel_dev/linux/include/linux/nodemask_types.h \
  /home/anton/kernel_dev/linux/include/linux/random.h \
    $(wildcard include/config/VMGENID) \
  /home/anton/kernel_dev/linux/include/uapi/linux/random.h \
  /home/anton/kernel_dev/linux/include/linux/irqnr.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/irqnr.h \
  /home/anton/kernel_dev/linux/include/linux/prandom.h \
  /home/anton/kernel_dev/linux/include/linux/once.h \
  /home/anton/kernel_dev/linux/include/linux/pageblock-flags.h \
    $(wildcard include/config/HUGETLB_PAGE) \
    $(wildcard include/config/HUGETLB_PAGE_SIZE_VARIABLE) \
  /home/anton/kernel_dev/linux/include/linux/page-flags-layout.h \
  include/generated/bounds.h \
  /home/anton/kernel_dev/linux/include/linux/mm_types.h \
    $(wildcard include/config/HAVE_ALIGNED_STRUCT_PAGE) \
    $(wildcard include/config/USERFAULTFD) \
    $(wildcard include/config/ANON_VMA_NAME) \
    $(wildcard include/config/PER_VMA_LOCK) \
    $(wildcard include/config/SCHED_MM_CID) \
    $(wildcard include/config/HAVE_ARCH_COMPAT_MMAP_BASES) \
    $(wildcard include/config/MEMBARRIER) \
    $(wildcard include/config/AIO) \
    $(wildcard include/config/MMU_NOTIFIER) \
    $(wildcard include/config/ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH) \
    $(wildcard include/config/IOMMU_SVA) \
    $(wildcard include/config/KSM) \
  /home/anton/kernel_dev/linux/include/linux/mm_types_task.h \
    $(wildcard include/config/SPLIT_PTLOCK_CPUS) \
    $(wildcard include/config/ARCH_ENABLE_SPLIT_PMD_PTLOCK) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/tlbbatch.h \
  /home/anton/kernel_dev/linux/include/linux/auxvec.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/auxvec.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/auxvec.h \
  /home/anton/kernel_dev/linux/include/linux/kref.h \
  /home/anton/kernel_dev/linux/include/linux/refcount.h \
  /home/anton/kernel_dev/linux/include/linux/refcount_types.h \
  /home/anton/kernel_dev/linux/include/linux/rbtree.h \
  /home/anton/kernel_dev/linux/include/linux/rbtree_types.h \
  /home/anton/kernel_dev/linux/include/linux/rcupdate.h \
    $(wildcard include/config/PREEMPT_RCU) \
    $(wildcard include/config/TINY_RCU) \
    $(wildcard include/config/RCU_STRICT_GRACE_PERIOD) \
    $(wildcard include/config/RCU_LAZY) \
    $(wildcard include/config/TASKS_RCU_GENERIC) \
    $(wildcard include/config/RCU_STALL_COMMON) \
    $(wildcard include/config/NO_HZ_FULL) \
    $(wildcard include/config/KVM_XFER_TO_GUEST_WORK) \
    $(wildcard include/config/RCU_NOCB_CPU) \
    $(wildcard include/config/TASKS_RCU) \
    $(wildcard include/config/TASKS_TRACE_RCU) \
    $(wildcard include/config/TASKS_RUDE_RCU) \
    $(wildcard include/config/TREE_RCU) \
    $(wildcard include/config/DEBUG_OBJECTS_RCU_HEAD) \
    $(wildcard include/config/PROVE_RCU) \
    $(wildcard include/config/ARCH_WEAK_RELEASE_ACQUIRE) \
  /home/anton/kernel_dev/linux/include/linux/context_tracking_irq.h \
    $(wildcard include/config/CONTEXT_TRACKING_IDLE) \
  /home/anton/kernel_dev/linux/include/linux/rcutree.h \
  /home/anton/kernel_dev/linux/include/linux/maple_tree.h \
    $(wildcard include/config/MAPLE_RCU_DISABLED) \
    $(wildcard include/config/DEBUG_MAPLE_TREE) \
  /home/anton/kernel_dev/linux/include/linux/rwsem.h \
    $(wildcard include/config/RWSEM_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_RWSEMS) \
  /home/anton/kernel_dev/linux/include/linux/completion.h \
  /home/anton/kernel_dev/linux/include/linux/swait.h \
  /home/anton/kernel_dev/linux/include/linux/uprobes.h \
    $(wildcard include/config/UPROBES) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/uprobes.h \
  /home/anton/kernel_dev/linux/include/linux/notifier.h \
  /home/anton/kernel_dev/linux/include/linux/srcu.h \
    $(wildcard include/config/TINY_SRCU) \
    $(wildcard include/config/NEED_SRCU_NMI_SAFE) \
  /home/anton/kernel_dev/linux/include/linux/workqueue.h \
    $(wildcard include/config/DEBUG_OBJECTS_WORK) \
    $(wildcard include/config/FREEZER) \
    $(wildcard include/config/WQ_WATCHDOG) \
  /home/anton/kernel_dev/linux/include/linux/timer.h \
    $(wildcard include/config/DEBUG_OBJECTS_TIMERS) \
  /home/anton/kernel_dev/linux/include/linux/ktime.h \
  /home/anton/kernel_dev/linux/include/linux/jiffies.h \
  /home/anton/kernel_dev/linux/include/vdso/jiffies.h \
  include/generated/timeconst.h \
  /home/anton/kernel_dev/linux/include/vdso/ktime.h \
  /home/anton/kernel_dev/linux/include/linux/timekeeping.h \
    $(wildcard include/config/GENERIC_CMOS_UPDATE) \
  /home/anton/kernel_dev/linux/include/linux/clocksource_ids.h \
  /home/anton/kernel_dev/linux/include/linux/debugobjects.h \
    $(wildcard include/config/DEBUG_OBJECTS) \
    $(wildcard include/config/DEBUG_OBJECTS_FREE) \
  /home/anton/kernel_dev/linux/include/linux/timer_types.h \
  /home/anton/kernel_dev/linux/include/linux/workqueue_types.h \
  /home/anton/kernel_dev/linux/include/linux/rcu_segcblist.h \
  /home/anton/kernel_dev/linux/include/linux/srcutree.h \
  /home/anton/kernel_dev/linux/include/linux/rcu_node_tree.h \
    $(wildcard include/config/RCU_FANOUT) \
    $(wildcard include/config/RCU_FANOUT_LEAF) \
  /home/anton/kernel_dev/linux/include/linux/percpu_counter.h \
  /home/anton/kernel_dev/linux/include/linux/percpu.h \
    $(wildcard include/config/RANDOM_KMALLOC_CACHES) \
    $(wildcard include/config/NEED_PER_CPU_PAGE_FIRST_CHUNK) \
  /home/anton/kernel_dev/linux/include/linux/mmdebug.h \
    $(wildcard include/config/DEBUG_VM) \
    $(wildcard include/config/DEBUG_VM_IRQSOFF) \
    $(wildcard include/config/DEBUG_VM_PGFLAGS) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/mmu.h \
    $(wildcard include/config/MODIFY_LDT_SYSCALL) \
  /home/anton/kernel_dev/linux/include/linux/page-flags.h \
    $(wildcard include/config/ARCH_USES_PG_UNCACHED) \
    $(wildcard include/config/PAGE_IDLE_FLAG) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_X) \
    $(wildcard include/config/HUGETLB_PAGE_OPTIMIZE_VMEMMAP) \
  /home/anton/kernel_dev/linux/include/linux/local_lock.h \
  /home/anton/kernel_dev/linux/include/linux/local_lock_internal.h \
  /home/anton/kernel_dev/linux/include/linux/zswap.h \
    $(wildcard include/config/ZSWAP) \
  /home/anton/kernel_dev/linux/include/linux/memory_hotplug.h \
    $(wildcard include/config/HAVE_ARCH_NODEDATA_EXTENSION) \
    $(wildcard include/config/ARCH_HAS_ADD_PAGES) \
    $(wildcard include/config/MEMORY_HOTREMOVE) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/mmzone.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/mmzone_64.h \
  /home/anton/kernel_dev/linux/include/linux/topology.h \
    $(wildcard include/config/USE_PERCPU_NUMA_NODE_ID) \
    $(wildcard include/config/SCHED_SMT) \
  /home/anton/kernel_dev/linux/include/linux/arch_topology.h \
    $(wildcard include/config/ACPI_CPPC_LIB) \
    $(wildcard include/config/GENERIC_ARCH_TOPOLOGY) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/topology.h \
    $(wildcard include/config/SCHED_MC_PRIO) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/mpspec.h \
    $(wildcard include/config/EISA) \
    $(wildcard include/config/X86_LOCAL_APIC) \
    $(wildcard include/config/X86_MPPARSE) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/mpspec_def.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/x86_init.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/apicdef.h \
  /home/anton/kernel_dev/linux/include/asm-generic/topology.h \
  /home/anton/kernel_dev/linux/include/linux/cpu_smt.h \
    $(wildcard include/config/HOTPLUG_SMT) \
  /home/anton/kernel_dev/linux/include/linux/sysctl.h \
    $(wildcard include/config/SYSCTL) \
  /home/anton/kernel_dev/linux/include/uapi/linux/sysctl.h \
  /home/anton/kernel_dev/linux/include/linux/elf.h \
    $(wildcard include/config/ARCH_USE_GNU_PROPERTY) \
    $(wildcard include/config/ARCH_HAVE_ELF_PROT) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/elf.h \
    $(wildcard include/config/X86_X32_ABI) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/ia32.h \
  /home/anton/kernel_dev/linux/include/linux/compat.h \
    $(wildcard include/config/ARCH_HAS_SYSCALL_WRAPPER) \
    $(wildcard include/config/COMPAT_OLD_SIGACTION) \
    $(wildcard include/config/ODD_RT_SIGACTION) \
  /home/anton/kernel_dev/linux/include/linux/sem.h \
    $(wildcard include/config/SYSVIPC) \
  /home/anton/kernel_dev/linux/include/uapi/linux/sem.h \
  /home/anton/kernel_dev/linux/include/linux/ipc.h \
  /home/anton/kernel_dev/linux/include/linux/rhashtable-types.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/ipc.h \
  arch/x86/include/generated/uapi/asm/ipcbuf.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/ipcbuf.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/sembuf.h \
  /home/anton/kernel_dev/linux/include/linux/sem_types.h \
  /home/anton/kernel_dev/linux/include/linux/socket.h \
  arch/x86/include/generated/uapi/asm/socket.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/socket.h \
  arch/x86/include/generated/uapi/asm/sockios.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/sockios.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/sockios.h \
  /home/anton/kernel_dev/linux/include/linux/uio.h \
    $(wildcard include/config/ARCH_HAS_COPY_MC) \
  /home/anton/kernel_dev/linux/include/uapi/linux/uio.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/socket.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/if.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/libc-compat.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/hdlc/ioctl.h \
  /home/anton/kernel_dev/linux/include/linux/fs.h \
    $(wildcard include/config/READ_ONLY_THP_FOR_FS) \
    $(wildcard include/config/FS_POSIX_ACL) \
    $(wildcard include/config/SECURITY) \
    $(wildcard include/config/CGROUP_WRITEBACK) \
    $(wildcard include/config/IMA) \
    $(wildcard include/config/FILE_LOCKING) \
    $(wildcard include/config/FSNOTIFY) \
    $(wildcard include/config/FS_ENCRYPTION) \
    $(wildcard include/config/FS_VERITY) \
    $(wildcard include/config/EPOLL) \
    $(wildcard include/config/UNICODE) \
    $(wildcard include/config/QUOTA) \
    $(wildcard include/config/FS_DAX) \
    $(wildcard include/config/BLOCK) \
  /home/anton/kernel_dev/linux/include/linux/wait_bit.h \
  /home/anton/kernel_dev/linux/include/linux/kdev_t.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/kdev_t.h \
  /home/anton/kernel_dev/linux/include/linux/dcache.h \
  /home/anton/kernel_dev/linux/include/linux/rculist.h \
    $(wildcard include/config/PROVE_RCU_LIST) \
  /home/anton/kernel_dev/linux/include/linux/rculist_bl.h \
  /home/anton/kernel_dev/linux/include/linux/list_bl.h \
  /home/anton/kernel_dev/linux/include/linux/bit_spinlock.h \
  /home/anton/kernel_dev/linux/include/linux/lockref.h \
    $(wildcard include/config/ARCH_USE_CMPXCHG_LOCKREF) \
  /home/anton/kernel_dev/linux/include/linux/stringhash.h \
    $(wildcard include/config/DCACHE_WORD_ACCESS) \
  /home/anton/kernel_dev/linux/include/linux/hash.h \
    $(wildcard include/config/HAVE_ARCH_HASH) \
  /home/anton/kernel_dev/linux/include/linux/path.h \
  /home/anton/kernel_dev/linux/include/linux/list_lru.h \
    $(wildcard include/config/MEMCG_KMEM) \
  /home/anton/kernel_dev/linux/include/linux/shrinker.h \
    $(wildcard include/config/SHRINKER_DEBUG) \
  /home/anton/kernel_dev/linux/include/linux/xarray.h \
    $(wildcard include/config/XARRAY_MULTI) \
  /home/anton/kernel_dev/linux/include/linux/sched/mm.h \
    $(wildcard include/config/MMU_LAZY_TLB_REFCOUNT) \
    $(wildcard include/config/ARCH_HAS_MEMBARRIER_CALLBACKS) \
  /home/anton/kernel_dev/linux/include/linux/sched.h \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_NATIVE) \
    $(wildcard include/config/SCHED_INFO) \
    $(wildcard include/config/SCHEDSTATS) \
    $(wildcard include/config/SCHED_CORE) \
    $(wildcard include/config/FAIR_GROUP_SCHED) \
    $(wildcard include/config/RT_GROUP_SCHED) \
    $(wildcard include/config/RT_MUTEXES) \
    $(wildcard include/config/UCLAMP_TASK) \
    $(wildcard include/config/UCLAMP_BUCKETS_COUNT) \
    $(wildcard include/config/KMAP_LOCAL) \
    $(wildcard include/config/CGROUP_SCHED) \
    $(wildcard include/config/BLK_DEV_IO_TRACE) \
    $(wildcard include/config/COMPAT_BRK) \
    $(wildcard include/config/CGROUPS) \
    $(wildcard include/config/BLK_CGROUP) \
    $(wildcard include/config/PSI) \
    $(wildcard include/config/PAGE_OWNER) \
    $(wildcard include/config/EVENTFD) \
    $(wildcard include/config/CPU_SUP_INTEL) \
    $(wildcard include/config/TASK_DELAY_ACCT) \
    $(wildcard include/config/ARCH_HAS_SCALED_CPUTIME) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_GEN) \
    $(wildcard include/config/POSIX_CPUTIMERS) \
    $(wildcard include/config/POSIX_CPU_TIMERS_TASK_WORK) \
    $(wildcard include/config/KEYS) \
    $(wildcard include/config/DETECT_HUNG_TASK) \
    $(wildcard include/config/IO_URING) \
    $(wildcard include/config/AUDIT) \
    $(wildcard include/config/AUDITSYSCALL) \
    $(wildcard include/config/UBSAN) \
    $(wildcard include/config/UBSAN_TRAP) \
    $(wildcard include/config/TASK_XACCT) \
    $(wildcard include/config/CPUSETS) \
    $(wildcard include/config/X86_CPU_RESCTRL) \
    $(wildcard include/config/FUTEX) \
    $(wildcard include/config/PERF_EVENTS) \
    $(wildcard include/config/RSEQ) \
    $(wildcard include/config/FAULT_INJECTION) \
    $(wildcard include/config/LATENCYTOP) \
    $(wildcard include/config/FUNCTION_GRAPH_TRACER) \
    $(wildcard include/config/BCACHE) \
    $(wildcard include/config/VMAP_STACK) \
    $(wildcard include/config/BPF_SYSCALL) \
    $(wildcard include/config/GCC_PLUGIN_STACKLEAK) \
    $(wildcard include/config/X86_MCE) \
    $(wildcard include/config/KRETPROBES) \
    $(wildcard include/config/RETHOOK) \
    $(wildcard include/config/ARCH_HAS_PARANOID_L1D_FLUSH) \
    $(wildcard include/config/RV) \
    $(wildcard include/config/USER_EVENTS) \
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
  /home/anton/kernel_dev/linux/include/uapi/linux/sched.h \
  /home/anton/kernel_dev/linux/include/linux/pid_types.h \
  /home/anton/kernel_dev/linux/include/linux/shm.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/shmparam.h \
  /home/anton/kernel_dev/linux/include/linux/kmsan_types.h \
  /home/anton/kernel_dev/linux/include/linux/plist_types.h \
  /home/anton/kernel_dev/linux/include/linux/hrtimer_types.h \
  /home/anton/kernel_dev/linux/include/linux/timerqueue_types.h \
  /home/anton/kernel_dev/linux/include/linux/seccomp_types.h \
    $(wildcard include/config/SECCOMP) \
  /home/anton/kernel_dev/linux/include/linux/resource.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/resource.h \
  arch/x86/include/generated/uapi/asm/resource.h \
  /home/anton/kernel_dev/linux/include/asm-generic/resource.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/resource.h \
  /home/anton/kernel_dev/linux/include/linux/latencytop.h \
  /home/anton/kernel_dev/linux/include/linux/sched/prio.h \
  /home/anton/kernel_dev/linux/include/linux/sched/types.h \
  /home/anton/kernel_dev/linux/include/linux/signal_types.h \
    $(wildcard include/config/OLD_SIGACTION) \
  /home/anton/kernel_dev/linux/include/uapi/linux/signal.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/signal.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/signal.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/signal-defs.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/siginfo.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/siginfo.h \
  /home/anton/kernel_dev/linux/include/linux/syscall_user_dispatch_types.h \
  /home/anton/kernel_dev/linux/include/linux/task_io_accounting.h \
    $(wildcard include/config/TASK_IO_ACCOUNTING) \
  /home/anton/kernel_dev/linux/include/linux/posix-timers_types.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/rseq.h \
  /home/anton/kernel_dev/linux/include/linux/kcsan.h \
  /home/anton/kernel_dev/linux/include/linux/rv.h \
    $(wildcard include/config/RV_REACTORS) \
  /home/anton/kernel_dev/linux/include/linux/livepatch_sched.h \
  arch/x86/include/generated/asm/kmap_size.h \
  /home/anton/kernel_dev/linux/include/asm-generic/kmap_size.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL) \
  /home/anton/kernel_dev/linux/include/linux/sync_core.h \
    $(wildcard include/config/ARCH_HAS_SYNC_CORE_BEFORE_USERMODE) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/sync_core.h \
  /home/anton/kernel_dev/linux/include/linux/radix-tree.h \
  /home/anton/kernel_dev/linux/include/linux/pid.h \
  /home/anton/kernel_dev/linux/include/linux/capability.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/capability.h \
  /home/anton/kernel_dev/linux/include/linux/semaphore.h \
  /home/anton/kernel_dev/linux/include/linux/fcntl.h \
    $(wildcard include/config/ARCH_32BIT_OFF_T) \
  /home/anton/kernel_dev/linux/include/uapi/linux/fcntl.h \
  arch/x86/include/generated/uapi/asm/fcntl.h \
  /home/anton/kernel_dev/linux/include/uapi/asm-generic/fcntl.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/openat2.h \
  /home/anton/kernel_dev/linux/include/linux/migrate_mode.h \
  /home/anton/kernel_dev/linux/include/linux/percpu-rwsem.h \
  /home/anton/kernel_dev/linux/include/linux/rcuwait.h \
  /home/anton/kernel_dev/linux/include/linux/sched/signal.h \
    $(wildcard include/config/SCHED_AUTOGROUP) \
    $(wildcard include/config/BSD_PROCESS_ACCT) \
    $(wildcard include/config/TASKSTATS) \
    $(wildcard include/config/STACK_GROWSUP) \
  /home/anton/kernel_dev/linux/include/linux/signal.h \
    $(wildcard include/config/DYNAMIC_SIGFRAME) \
  /home/anton/kernel_dev/linux/include/linux/sched/jobctl.h \
  /home/anton/kernel_dev/linux/include/linux/sched/task.h \
    $(wildcard include/config/HAVE_EXIT_THREAD) \
    $(wildcard include/config/ARCH_WANTS_DYNAMIC_TASK_STRUCT) \
    $(wildcard include/config/HAVE_ARCH_THREAD_STRUCT_WHITELIST) \
  /home/anton/kernel_dev/linux/include/linux/uaccess.h \
    $(wildcard include/config/ARCH_HAS_SUBPAGE_FAULTS) \
  /home/anton/kernel_dev/linux/include/linux/fault-inject-usercopy.h \
    $(wildcard include/config/FAULT_INJECTION_USERCOPY) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/uaccess.h \
    $(wildcard include/config/CC_HAS_ASM_GOTO_OUTPUT) \
    $(wildcard include/config/CC_HAS_ASM_GOTO_TIED_OUTPUT) \
    $(wildcard include/config/X86_INTEL_USERCOPY) \
  /home/anton/kernel_dev/linux/include/linux/mmap_lock.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/smap.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/extable.h \
    $(wildcard include/config/BPF_JIT) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/tlbflush.h \
  /home/anton/kernel_dev/linux/include/linux/mmu_notifier.h \
  /home/anton/kernel_dev/linux/include/linux/interval_tree.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/invpcid.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pti.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pgtable.h \
    $(wildcard include/config/DEBUG_WX) \
    $(wildcard include/config/HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) \
    $(wildcard include/config/ARCH_HAS_PTE_DEVMAP) \
    $(wildcard include/config/HAVE_ARCH_SOFT_DIRTY) \
    $(wildcard include/config/ARCH_ENABLE_THP_MIGRATION) \
    $(wildcard include/config/PAGE_TABLE_CHECK) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pkru.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/fpu/api.h \
    $(wildcard include/config/X86_DEBUG_FPU) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/coco.h \
  /home/anton/kernel_dev/linux/include/asm-generic/pgtable_uffd.h \
  /home/anton/kernel_dev/linux/include/linux/page_table_check.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pgtable_64.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/fixmap.h \
    $(wildcard include/config/PROVIDE_OHCI1394_DMA_INIT) \
    $(wildcard include/config/X86_IO_APIC) \
    $(wildcard include/config/PCI_MMCONFIG) \
    $(wildcard include/config/ACPI_APEI_GHES) \
    $(wildcard include/config/INTEL_TXT) \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/vsyscall.h \
  /home/anton/kernel_dev/linux/include/asm-generic/fixmap.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/pgtable-invert.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/uaccess_64.h \
  /home/anton/kernel_dev/linux/include/asm-generic/access_ok.h \
    $(wildcard include/config/ALTERNATE_USER_ADDRESS_SPACE) \
  /home/anton/kernel_dev/linux/include/linux/cred.h \
  /home/anton/kernel_dev/linux/include/linux/key.h \
    $(wildcard include/config/KEY_NOTIFICATIONS) \
    $(wildcard include/config/NET) \
  /home/anton/kernel_dev/linux/include/linux/assoc_array.h \
    $(wildcard include/config/ASSOCIATIVE_ARRAY) \
  /home/anton/kernel_dev/linux/include/linux/sched/user.h \
    $(wildcard include/config/VFIO_PCI_ZDEV_KVM) \
    $(wildcard include/config/IOMMUFD) \
    $(wildcard include/config/WATCH_QUEUE) \
  /home/anton/kernel_dev/linux/include/linux/ratelimit.h \
  /home/anton/kernel_dev/linux/include/linux/posix-timers.h \
  /home/anton/kernel_dev/linux/include/linux/alarmtimer.h \
    $(wildcard include/config/RTC_CLASS) \
  /home/anton/kernel_dev/linux/include/linux/hrtimer.h \
    $(wildcard include/config/HIGH_RES_TIMERS) \
    $(wildcard include/config/TIME_LOW_RES) \
    $(wildcard include/config/TIMERFD) \
  /home/anton/kernel_dev/linux/include/linux/hrtimer_defs.h \
  /home/anton/kernel_dev/linux/include/linux/timerqueue.h \
  /home/anton/kernel_dev/linux/include/linux/rcu_sync.h \
  /home/anton/kernel_dev/linux/include/linux/delayed_call.h \
  /home/anton/kernel_dev/linux/include/linux/uuid.h \
  /home/anton/kernel_dev/linux/include/linux/errseq.h \
  /home/anton/kernel_dev/linux/include/linux/ioprio.h \
  /home/anton/kernel_dev/linux/include/linux/sched/rt.h \
  /home/anton/kernel_dev/linux/include/linux/iocontext.h \
    $(wildcard include/config/BLK_ICQ) \
  /home/anton/kernel_dev/linux/include/uapi/linux/ioprio.h \
  /home/anton/kernel_dev/linux/include/linux/fs_types.h \
  /home/anton/kernel_dev/linux/include/linux/mount.h \
  /home/anton/kernel_dev/linux/include/linux/mnt_idmapping.h \
  /home/anton/kernel_dev/linux/include/linux/slab.h \
    $(wildcard include/config/SLUB_DEBUG) \
    $(wildcard include/config/SLUB_TINY) \
    $(wildcard include/config/FAILSLAB) \
    $(wildcard include/config/KFENCE) \
  /home/anton/kernel_dev/linux/include/linux/percpu-refcount.h \
  /home/anton/kernel_dev/linux/include/linux/kasan.h \
    $(wildcard include/config/KASAN_STACK) \
    $(wildcard include/config/KASAN_VMALLOC) \
  /home/anton/kernel_dev/linux/include/linux/kasan-enabled.h \
  /home/anton/kernel_dev/linux/include/linux/kasan-tags.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/fs.h \
  /home/anton/kernel_dev/linux/include/linux/quota.h \
    $(wildcard include/config/QUOTA_NETLINK_INTERFACE) \
  /home/anton/kernel_dev/linux/include/uapi/linux/dqblk_xfs.h \
  /home/anton/kernel_dev/linux/include/linux/dqblk_v1.h \
  /home/anton/kernel_dev/linux/include/linux/dqblk_v2.h \
  /home/anton/kernel_dev/linux/include/linux/dqblk_qtree.h \
  /home/anton/kernel_dev/linux/include/linux/projid.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/quota.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/aio_abi.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/unistd.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/unistd.h \
  /home/anton/kernel_dev/linux/arch/x86/include/uapi/asm/unistd.h \
  arch/x86/include/generated/uapi/asm/unistd_64.h \
  arch/x86/include/generated/asm/unistd_64_x32.h \
  arch/x86/include/generated/asm/unistd_32_ia32.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/compat.h \
  /home/anton/kernel_dev/linux/include/linux/sched/task_stack.h \
    $(wildcard include/config/DEBUG_STACK_USAGE) \
  /home/anton/kernel_dev/linux/include/uapi/linux/magic.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/user32.h \
  /home/anton/kernel_dev/linux/include/asm-generic/compat.h \
    $(wildcard include/config/COMPAT_FOR_U64_ALIGNMENT) \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/syscall_wrapper.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/user.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/user_64.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/fsgsbase.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/vdso.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/elf.h \
  /home/anton/kernel_dev/linux/include/uapi/linux/elf-em.h \
  /home/anton/kernel_dev/linux/include/linux/kobject.h \
    $(wildcard include/config/UEVENT_HELPER) \
    $(wildcard include/config/DEBUG_KOBJECT_RELEASE) \
  /home/anton/kernel_dev/linux/include/linux/sysfs.h \
  /home/anton/kernel_dev/linux/include/linux/kernfs.h \
    $(wildcard include/config/KERNFS) \
  /home/anton/kernel_dev/linux/include/linux/idr.h \
  /home/anton/kernel_dev/linux/include/linux/kobject_ns.h \
  /home/anton/kernel_dev/linux/include/linux/moduleparam.h \
    $(wildcard include/config/ALPHA) \
    $(wildcard include/config/PPC64) \
  /home/anton/kernel_dev/linux/include/linux/rbtree_latch.h \
  /home/anton/kernel_dev/linux/include/linux/error-injection.h \
  /home/anton/kernel_dev/linux/include/asm-generic/error-injection.h \
  /home/anton/kernel_dev/linux/include/linux/dynamic_debug.h \
  /home/anton/kernel_dev/linux/arch/x86/include/asm/module.h \
    $(wildcard include/config/UNWINDER_ORC) \
  /home/anton/kernel_dev/linux/include/asm-generic/module.h \
    $(wildcard include/config/HAVE_MOD_ARCH_SPECIFIC) \
    $(wildcard include/config/MODULES_USE_ELF_REL) \
    $(wildcard include/config/MODULES_USE_ELF_RELA) \
  /home/anton/kernel_dev/linux/include/linux/proc_fs.h \
    $(wildcard include/config/PROC_PID_ARCH_STATUS) \

/home/anton/kernel_dev/test_module/test_module.o: $(deps_/home/anton/kernel_dev/test_module/test_module.o)

$(deps_/home/anton/kernel_dev/test_module/test_module.o):

/home/anton/kernel_dev/test_module/test_module.o: $(wildcard ./tools/objtool/objtool)
