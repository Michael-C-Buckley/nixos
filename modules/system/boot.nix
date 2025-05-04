{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkOption;
  inherit (lib.types) enum;
  loader = config.features.boot;
in {
  options.features = {
    boot = mkOption {
      type = enum ["systemd" "grub" "none"];
      default = "systemd";
      description = "Which bootloader settings to use from this repository.";
    };
  };
  config = {
    boot = {
      kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_hardened;
      loader = {
        # Grub
        grub = {
          enable =
            if loader == "grub"
            then true
            else false;
          efiSupport = true;
          efiInstallAsRemovable = true;
          device = "nodev";
        };

        # Systemd Related options
        systemd-boot = {
          enable =
            if loader == "systemd"
            then true
            else false;
          configurationLimit = 15;
          netbootxyz.enable = true;
        };
        efi.canTouchEfiVariables =
          if loader == "systemd"
          then true
          else false;
      };
    };
  };
}
