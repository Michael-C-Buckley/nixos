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
in
  {
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
  # WSL-specific configuration (only applied when hostname contains "wsl" or explicitly enabled)
  // (
    if (lib.strings.hasInfix "wsl" (lib.strings.toLower hostname))
    then {
      ### Hyper-V Guest Support (required for WSL2)
      HYPERVISOR_GUEST = yes;
      PARAVIRT = yes;
      PARAVIRT_SPINLOCKS = yes;
      HYPERV = yes;
      HYPERV_TIMER = yes;
      HYPERV_UTILS = yes;
      HYPERV_BALLOON = yes;
      HYPERV_VSOCKETS = yes;

      ### Hyper-V Storage and Network
      SCSI_LOWLEVEL = yes;
      HYPERV_STORAGE = yes;
      HYPERV_NET = yes;
      HYPERV_NET_VERBOSE = no;
      HYPERV_KEYBOARD = yes;

      ### 9P Filesystem Support (for /mnt/c Windows filesystem access)
      NET_9P = yes;
      NET_9P_VIRTIO = yes;
      NET_9P_DEBUG = no;
      "9P_FS" = yes;
      "9P_FSCACHE" = yes;
      "9P_FS_POSIX_ACL" = yes;
      "9P_FS_SECURITY" = yes;

      ### FUSE and Overlay FS (for DrvFS and containers)
      FUSE_FS = yes;
      CUSE = yes;
      VIRTIO_FS = yes;
      OVERLAY_FS = yes;
      OVERLAY_FS_REDIRECT_DIR = yes;
      OVERLAY_FS_INDEX = yes;
      OVERLAY_FS_XINO_AUTO = yes;

      ### USB/IP Support (for USBIPD)
      USB_SUPPORT = yes;
      USB = yes;
      USB_ANNOUNCE_NEW_DEVICES = yes;
      USBIP_CORE = "module";
      USBIP_VHCI_HCD = "module";
      USBIP_VHCI_HC_PORTS = freeform "8";
      USBIP_VHCI_NR_HCS = freeform "1";
      USBIP_HOST = "module";
      USBIP_VUDC = "module";
      USBIP_DEBUG = no;

      ### Additional USB drivers (commonly needed)
      USB_EHCI_HCD = "module";
      USB_XHCI_HCD = "module";
      USB_STORAGE = "module";
      USB_UAS = "module";
      USB_ACM = "module";
      USB_SERIAL = "module";
      USB_SERIAL_GENERIC = yes;
      USB_SERIAL_FTDI_SIO = "module";
      USB_SERIAL_CP210X = "module";
      USB_SERIAL_CH341 = "module";

      ### Enhanced Network Support
      NETDEVICES = yes;
      ETHERNET = yes;
      NET_VENDOR_INTEL = yes;
      NET_VENDOR_REALTEK = yes;
      NET_VENDOR_BROADCOM = yes;

      # Common NICs as modules
      E1000 = "module";
      E1000E = "module";
      IGB = "module";
      IGBVF = "module";
      IXGB = "module";
      IXGBE = "module";
      R8169 = "module";

      # Virtual NICs
      VIRTIO_NET = yes;
      TUN = "module";
      VETH = "module";
      MACVLAN = "module";
      MACVTAP = "module";
      IPVLAN = "module";
      VXLAN = "module";

      ### Namespace and Container Support (needed for ZFS and experiments)
      NAMESPACES = yes;
      UTS_NS = yes;
      IPC_NS = yes;
      USER_NS = yes;
      PID_NS = yes;
      NET_NS = yes;

      ### Cgroups (essential for systemd and containers)
      CGROUPS = yes;
      CGROUP_FREEZER = yes;
      CGROUP_PIDS = yes;
      CGROUP_DEVICE = yes;
      CGROUP_CPUACCT = yes;
      CGROUP_PERF = yes;
      CGROUP_BPF = yes;
      MEMCG = yes;
      MEMCG_SWAP = yes;
      BLK_CGROUP = yes;

      ### Module Support (critical for ZFS and experiments)
      MODULES = yes;
      MODULE_FORCE_LOAD = yes;
      MODULE_UNLOAD = yes;
      MODULE_FORCE_UNLOAD = yes;
      MODVERSIONS = yes;
      MODULE_SRCVERSION_ALL = yes;
      MODULE_SIG = yes;
      MODULE_SIG_FORCE = no; # Allow unsigned modules for experiments
      MODULE_SIG_ALL = no;
      MODULE_SIG_SHA256 = yes;
      MODULE_COMPRESS_NONE = yes;

      ### Filesystem Support (for ZFS and general use)
      BTRFS_FS = "module";
      BTRFS_FS_POSIX_ACL = yes;
      XFS_FS = "module";
      XFS_QUOTA = yes;
      XFS_POSIX_ACL = yes;
      EXT4_FS = yes;
      EXT4_FS_POSIX_ACL = yes;
      EXT4_FS_SECURITY = yes;

      ### Crypto Support
      CRYPTO = yes;
      CRYPTO_DEFLATE = "module";
      CRYPTO_LZO = "module";
      CRYPTO_ZSTD = "module";
      CRYPTO_AES = yes;
      CRYPTO_SHA256 = yes;
      CRYPTO_SHA512 = "module";

      ### Device Mapper (for LVM)
      MD = yes;
      BLK_DEV_DM = "module";
      DM_SNAPSHOT = "module";
      DM_THIN_PROVISIONING = "module";
      DM_CRYPT = "module";

      ### eBPF and tracing (useful for debugging)
      BPF = yes;
      BPF_SYSCALL = yes;
      BPF_JIT = yes;
      BPF_JIT_ALWAYS_ON = no; # Allow fallback for compatibility
      DEBUG_INFO_BTF = yes; # Re-enable for eBPF

      ### VirtIO (additional drivers for VM compatibility)
      VIRTIO = yes;
      VIRTIO_PCI = yes;
      VIRTIO_BALLOON = yes;
      VIRTIO_INPUT = yes;
      VIRTIO_MMIO = yes;
      VIRTIO_BLK = "module";
      SCSI_VIRTIO = "module";
    }
    else {}
  )
