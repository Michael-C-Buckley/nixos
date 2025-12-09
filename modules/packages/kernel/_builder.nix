# Core kernel builder function
# Reusable for building Xanmod kernels with different configurations
{
  pkgs,
  profileConfigs,
}: {
  version,
  hash,
  profile,
  hostname ? "",
  customSuffix ? "jet",
  x86version ? "3",
  extraConfig ? {}, # Allow additional config overrides
}: let
  inherit (pkgs) lib stdenv gccStdenv buildLinux kernelPatches;
  inherit (lib.versions) pad majorMinor;

  pname = "linux-xanmod";
  modDirVersion = pad 3 "${version}-${customSuffix}";

  cfg = profileConfigs.${profile};

  # Import base config and allow overrides
  baseConfig = import ./_config.nix {
    inherit lib cfg hostname x86version;
  };
  structuredExtraConfig = baseConfig // extraConfig;

  xanmod_custom =
    (buildLinux {
      inherit pname version modDirVersion structuredExtraConfig;

      stdenv = gccStdenv;

      src = pkgs.fetchFromGitLab {
        owner = "xanmod";
        repo = "linux";
        rev = "refs/tags/${version}-xanmod1";
        inherit hash;
      };

      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];

      ignoreConfigErrors = true;
      enableCommonConfig = true;

      extraMeta = {
        broken = stdenv.isAarch64; # Aarch64 is a stretch goal, X64 was a priority
        branch = majorMinor version;
        description = ''
          Custom Xanmod Kernel (${profile} profile)
          - CPU Governor: ${cfg.cpuGovernor}
          - Preemption: ${cfg.preemptModel}
          - Timer Hz: ${toString cfg.hz}
          - x86-64 level: v${x86version}
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
  xanmod_custom
