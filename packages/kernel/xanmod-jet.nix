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
  # I specifically allow unfree so that kernel modules can work, like nvidia
  pkgs = import inputs.kernel-nixpkgs {
    system = "x86_64-linux";
    config = {allowUnfree = true;};
  };

  # Import modular components
  profileConfigs = import ./_profiles.nix;
  buildCustomKernel = import ./_builder.nix {
    inherit pkgs profileConfigs;
  };

  # Helper to build a specific version with a profile
  buildVersion = {
    profile,
    customSuffix,
    x86version ? "3", # Default to v3, but allow override
  }:
    buildCustomKernel {
      version = "6.17.11";
      hash = "sha256-NJQ67MOjFMScwECxQd00F3SZ+kITbuBp/3imNXdUqlQ=";
      inherit profile customSuffix x86version;
    };
in {
  flake.packages.x86_64-linux = {
    jet1 = buildVersion {
      profile = "server";
      customSuffix = "jet1";
    };

    jet2 = buildVersion {
      profile = "balanced";
      customSuffix = "jet2";
    };

    jet3 = buildVersion {
      profile = "performance";
      customSuffix = "jet3";
    };
  };
}
