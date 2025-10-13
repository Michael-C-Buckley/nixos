# Options used in NixOS hosts
{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) enum listOf str;

  mkDirectoryOption = mkOption {
    type = listOf str;
    default = [];
    description = "Create binds for the specified directories to the drive matching the option namespace.";
  };
in {
  options.host = {
    bootloader = mkOption {
      # None is used in special circumstances like WSL
      type = enum ["systemd-boot" "grub" "limine" "none"];
      default = "systemd-boot";
      description = "Which bootloader flake module to use with the host.";
    };
    impermanence = {
      enable = mkEnableOption "Enable impermanence features on this host.";

      cache = {
        directories = mkDirectoryOption;
        user.directories = mkDirectoryOption;
      };
      persist = {
        directories = mkDirectoryOption;
        user.directories = mkDirectoryOption;
      };
    };

    graphicalPackages = mkOption {
      type = listOf str;
      default = [];
      description = "List of graphical packages to install on this host. The strings will be interpreted later into the appropriate nixpkgs namespace.";
    };
  };
}
