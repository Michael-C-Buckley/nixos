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

  # Import modular components
  profileConfigs = import ./_profiles.nix;
  versions = import ./_versions.nix;
  buildCustomKernel = import ./_builder.nix {
    inherit pkgs profileConfigs;
  };

  # Helper to build a specific version with a profile
  buildVersion = {
    versionKey,
    profile,
    customSuffix,
  }: let
    versionInfo = versions.${versionKey};
  in
    buildCustomKernel {
      inherit (versionInfo) version hash;
      inherit profile customSuffix;
    };
in {
  flake = {
    packages.x86_64-linux = {
      # 6.16 Kernels
      jet1-kernel_6_16 = buildVersion {
        versionKey = "6.16.12";
        profile = "server";
        customSuffix = "jet1";
      };

      jet2-kernel_6_16 = buildVersion {
        versionKey = "6.16.12";
        profile = "balanced";
        customSuffix = "jet2";
      };

      jet3-kernel_6_16 = buildVersion {
        versionKey = "6.16.12";
        profile = "performance";
        customSuffix = "jet3";
      };

      # 6.17 Kernels - So far no servers since not using it because ZFS
      jet2-kernel_6_17_7 = buildVersion {
        versionKey = "6.17.7";
        profile = "balanced";
        customSuffix = "jet2";
      };

      jet3-kernel_6_17_7 = buildVersion {
        versionKey = "6.17.7";
        profile = "performance";
        customSuffix = "jet3";
      };

      jet2-kernel_6_17_8 = buildVersion {
        versionKey = "6.17.8";
        profile = "balanced";
        customSuffix = "jet2";
      };

      jet3-kernel_6_17_8 = buildVersion {
        versionKey = "6.17.8";
        profile = "performance";
        customSuffix = "jet3";
      };
    };
  };
}
