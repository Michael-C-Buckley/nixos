# This is a custom Xanmod-based Kernel for my own uses
#  I was inspired to create this after running into Nixpkgs deprecating mainline kernels
#  before ZFS would release stable updates
#  I had wanted to produce my own anyway, and this inspired me to start
#
# Inspiration:
# Xanmod (the base) - https://xanmod.org/
# Raf - https://github.com/NotAShelf/nyx/blob/main/hosts/enyo/kernel/packages/xanmod.nix
# Clear Linux - RIP to Clear, though they did provide some insight into optimizations I chose
#
# WARNING:
# These are all **x86-64v3** builds by default
#
# I only have that architecture among my systems, so it works for me,
#  check your CPUs before using this as-is
{inputs, ...}: let
  pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
in {
  flake = let
    # Build a custom Xanmod kernel with the given profile
    # Profiles: "server", "workstation", "performance"
    buildCustomKernel = {
      profile ? "server",
      hostname ? "",
      customSuffix ? "jet",
      x86version ? "3",
    }: let
      inherit (pkgs) lib stdenv gccStdenv buildLinux kernelPatches;
      inherit (lib.modules) mkForce mkOverride;
      inherit (lib.kernel) yes no freeform;
      inherit (lib.versions) pad majorMinor;

      version = "6.16.12";
      vendorSuffix = "xanmod1";

      pname = "linux-xanmod";
      modDirVersion = pad 3 "${version}-${customSuffix}";

      # Profile-specific settings
      profileConfig = {
        # Profiles approximate the workload they'll be experiencing
        # - Server: throughput and efficiency focused
        # - Balanced: mix of responsiveness and throughput
        # - Performance: maximum responsiveness
        # Balanced is used on my laptop and performance on my desktop, servers use server (obviously)
        server = {
          cpuGovernor = "schedutil";
          preemptModel = "voluntary"; # Lower overhead, better throughput
          hz = 300; # Good balance for server workloads
        };
        balanced = {
          cpuGovernor = "schedutil";
          preemptModel = "dynamic"; # Runtime tunable preemption
          hz = 500; # Good compromise
        };
        performance = {
          cpuGovernor = "performance"; # Maximum frequency always
          preemptModel = "full"; # Full preemption for low latency
          hz = 1000; # Maximum timer frequency
        };
      };

      cfg = profileConfig.${profile};

      xanmod_custom =
        (buildLinux {
          inherit pname version modDirVersion;

          stdenv = gccStdenv;

          src = pkgs.fetchFromGitLab {
            owner = "xanmod";
            repo = "linux";
            rev = "refs/tags/${version}-${vendorSuffix}";
            hash = "sha256-m2aepV++9RwobXOTxiLJaUV8TnPvBkZzNooKQR4nRtA=";
          };

          kernelPatches = [
            kernelPatches.bridge_stp_helper
            kernelPatches.request_key_helper
          ];

          ignoreConfigErrors = true;
          enableCommonConfig = true;

          # after booting to the new kernel
          # use zcat /proc/config.gz | grep -i "<value>"
          # to check if the kernel options are set correctly
          # Do note that values set in config/*.nix will override
          # those values in most cases.
          structuredExtraConfig = {
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
            X86_64_VERSION = freeform x86version; # I only have x86-64v3 CPUs

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
          };

          extraMeta = {
            broken = stdenv.isAarch64; # Aarch64 is a stretch goal, X64 was a priority
            branch = majorMinor version;
            description = ''
              Custom Xanmod Kernel (${profile} profile)
              - CPU Governor: ${cfg.cpuGovernor}
              - Preemption: ${cfg.preemptModel}
              - Timer Hz: ${toString cfg.hz}
              - x86-64 level: v${toString cfg.x86Version}
            '';
          };
        })
    .overrideAttrs (oa: {
          prePatch =
            (oa.prePatch or "")
            + ''
              # A gem from Raf on renaming your kernel
              echo "Replacing localversion with custom suffix"
              substituteInPlace localversion \
                --replace-fail "xanmod1" "${customSuffix}"
            '';
        });
    in
      xanmod_custom;
  in {
    # TODO:
    # Make this more customizable and properly add to packagesFor under linux
    packages.x86_64-linux = {
      jet-kernel-server = buildCustomKernel {
        profile = "server";
        customSuffix = "jet1";
      };

      jet-kernel-balanced = buildCustomKernel {
        profile = "balanced";
        customSuffix = "jet2";
      };

      jet-kernel-performance = buildCustomKernel {
        profile = "performance";
        customSuffix = "jet3";
      };
    };
  };
}
