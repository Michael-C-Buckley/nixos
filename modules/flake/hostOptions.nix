# Options used in NixOS hosts
{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) enum;
in {
  options.host = {
    bootloader = mkOption {
      # None is used in special circumstances like WSL
      type = enum ["systemd-boot" "grub" "limine" "none"];
      default = "systemd-boot";
      description = "Which bootloader flake module to use with the host.";
    };
  };
}
