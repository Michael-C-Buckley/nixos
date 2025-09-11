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
      # None is used in special circumstances like WSL
      type = enum ["systemd" "grub" "limine" "none"];
      default = "systemd";
      description = "Which bootloader settings to use from this repository.";
    };
  };

  config = {
    boot = {
      kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };

      kernelPackages = mkDefault pkgs.linuxPackages_6_16;

      initrd = {
        systemd = {
          enable = true;
          emergencyAccess = config.users.users.root.hashedPassword;
        };
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

        limine = mkIf (loader == "limine") {
          enable = true;
        };

        efi.canTouchEfiVariables =
          if loader == "systemd"
          then true
          else false;
      };
    };
  };
}
