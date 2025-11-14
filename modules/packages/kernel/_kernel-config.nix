# Shared kernel configuration options
# This can be imported and extended by different kernel builds
{
  lib,
  cfg, # Profile configuration (cpuGovernor, preemptModel, hz)
  hostname ? "",
  x86version ? "3",
}: let
  inherit (lib.modules) mkForce mkOverride;
  inherit (lib.kernel) yes no freeform;
in {
  ### Profile-based CPU Frequency Governor
  CPU_FREQ_DEFAULT_GOV_PERFORMANCE = mkOverride 60 (
    if cfg.cpuGovernor == "performance"
    then yes
    else no
  );
  CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = mkOverride 60 (
    if cfg.cpuGovernor == "schedutil"
    then yes
    else no
  );

  ### Profile-based Preemption Model
  # Note: PREEMPT_DYNAMIC allows runtime switching via kernel cmdline
  PREEMPT = mkOverride 60 (
    if cfg.preemptModel == "full"
    then yes
    else no
  );
  PREEMPT_VOLUNTARY = mkOverride 60 (
    if cfg.preemptModel == "voluntary"
    then yes
    else no
  );
  PREEMPT_DYNAMIC = mkOverride 60 (
    if cfg.preemptModel == "dynamic"
    then yes
    else no
  );

  ### Profile-based Timer Frequency
  HZ_250 =
    if cfg.hz == 250
    then yes
    else no;
  HZ_300 =
    if cfg.hz == 300
    then yes
    else no;
  HZ_500 =
    if cfg.hz == 500
    then yes
    else no;
  HZ_1000 =
    if cfg.hz == 1000
    then yes
    else no;
  HZ = freeform (toString cfg.hz);

  ### Tickless Configuration
  NO_HZ_FULL = mkForce no;
  NO_HZ_IDLE = mkForce yes;

  ### Profile-based CPU Architecture Optimization
  # v2 = 2009+ (CMPXCHG16B, POPCNT, SSE4.2)
  # v3 = 2015+ (AVX2, BMI1/2, F16C, FMA, MOVBE)
  # v4 = 2017+ (AVX512)
  X86_64_VERSION = freeform x86version;

  ### RCU Configuration (tuned for responsiveness)
  RCU_EXPERT = yes;
  RCU_FANOUT = freeform "64";
  RCU_FANOUT_LEAF = freeform "16";
  RCU_BOOST = yes;
  RCU_BOOST_DELAY = freeform "0";
  RCU_EXP_KTHREAD = yes;

  ### Basic Options
  DEFAULT_HOSTNAME = freeform (
    if hostname != ""
    then hostname
    else "(none)"
  );
  EXPERT = yes;
  DEBUG_KERNEL = mkForce no;
  WERROR = no;

  ### Security Hardening (enabled for all profiles)
  GCC_PLUGINS = yes;
  BUG_ON_DATA_CORRUPTION = yes;
  INIT_ON_FREE_DEFAULT_ON = yes; # Zero memory on free
  INIT_STACK_ALL_ZERO = yes; # Zero stack on allocation
  RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes; # KASLR for stacks
  STACKPROTECTOR = yes;
  STACKPROTECTOR_STRONG = yes;

  ### Memory and Compression Optimizations
  ZSWAP_COMPRESSOR_DEFAULT_LZ4 = yes;
  ZSWAP_COMPRESSOR_DEFAULT = freeform "lz4";
  COMPACT_UNEVICTABLE_DEFAULT = freeform "1";

  ### Scheduler Optimizations
  SCHED_AUTOGROUP = yes; # Improves desktop interactivity, minimal server impact
  CFS_BANDWIDTH = yes; # CPU bandwidth control for cgroups

  ### I/O and Hardware Optimizations
  BLK_CGROUP_IOCOST = yes; # I/O cost-based scheduling
  NVME_MULTIPATH = yes; # NVMe multipath support

  ### Disable Debugging for Production Performance
  DEBUG_INFO = mkForce no;
  DEBUG_INFO_DWARF4 = mkForce no;
  DEBUG_INFO_BTF = mkForce no;
  DEBUG_INFO_REDUCED = mkForce no;

  ### SELinux Support (optional, runtime configurable)
  SECURITY_SELINUX = yes;
  SECURITY_SELINUX_BOOTPARAM = yes; # Allow boot-time enable/disable
  SECURITY_SELINUX_DEVELOP = yes; # Development support
  SECURITY_SELINUX_AVC_STATS = yes; # Statistics
  DEFAULT_SECURITY_SELINUX = no; # Don't enable by default
}
