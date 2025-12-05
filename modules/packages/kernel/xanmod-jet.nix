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
{self, ...}: let
  # Use the npins nixpkgs to prevent unnecessary rebuilds because of dependency and
  # tool changes that otherwise do not affect the kernel build itself
  # IMPORTANT: unfree is set here to be compatible with drivers such as Nvidia, since it will not be
  # used from the system pkgs
  pkgs = import (import "${self}/npins").nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

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
    x86version ? "3", # Default to v3, but allow override
  }: let
    versionInfo = versions.${versionKey};
  in
    buildCustomKernel {
      inherit (versionInfo) version hash;
      inherit profile customSuffix x86version;
    };
in {
  flake = {
    packages.x86_64-linux = {
      # 6.16 Kernels
      jet1_6_16 = buildVersion {
        versionKey = "6.16.12";
        profile = "server";
        customSuffix = "jet1";
      };

      jet2_6_16 = buildVersion {
        versionKey = "6.16.12";
        profile = "balanced";
        customSuffix = "jet2";
      };

      jet3_6_16 = buildVersion {
        versionKey = "6.16.12";
        profile = "performance";
        customSuffix = "jet3";
      };

      jet1_latest = buildVersion {
        versionKey = "6.17.8";
        profile = "server";
        customSuffix = "jet1";
      };

      jet2_latest = buildVersion {
        versionKey = "6.17.8";
        profile = "balanced";
        customSuffix = "jet2";
      };

      jet3_latest = buildVersion {
        versionKey = "6.17.8";
        profile = "performance";
        customSuffix = "jet3";
      };
    };
  };
}
