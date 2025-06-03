{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkOption mkIf;
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
      kernelPackages = mkDefault pkgs.linuxPackages_6_14;

      initrd = {
        systemd.enable = true;
      };

      loader = {
        # Grub
        grub = mkIf (loader == "grub") {
          enable = true;
          efiSupport = true;
          efiInstallAsRemovable = true;
          device = "nodev";
        };

        # Systemd Related options
        systemd-boot = mkIf (loader == "systemd") {
          enable = true;
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
