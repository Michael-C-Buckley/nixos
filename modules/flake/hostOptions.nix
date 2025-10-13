# Options used in NixOS hosts
{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) enum listOf str;

  mkDirectoryOption = mkOption {
    type = listOf str;
    default = [];
    description = "Create binds for the specified directories to the drive matching the option namespace.";
  };
  mkFileOption = mkOption {
    type = listOf str;
    default = [];
    description = "Create binds for the specified files to the drive matching the option namespace.";
  };
in {
  options.host = {
    bootloader = mkOption {
      # None is used in special circumstances like WSL
      type = enum ["systemd-boot" "grub" "limine" "none"];
      default = "systemd-boot";
      description = "Which bootloader flake module to use with the host.";
    };

    # These options live separate from impermanence and are only activated if the system uses impermanence
    impermanence = {
      enable = mkEnableOption "Enable impermanence features on this host.";

      cache = {
        directories = mkDirectoryOption;
        files = mkFileOption;
        user = {
          directories = mkDirectoryOption;
          files = mkFileOption;
        };
      };
      persist = {
        directories = mkDirectoryOption;
        files = mkFileOption;
        user = {
          directories = mkDirectoryOption;
          files = mkFileOption;
        };
      };
    };

    graphicalPackages = mkOption {
      type = listOf str;
      default = [];
      description = "List of graphical packages to install on this host. The strings will be interpreted later into the appropriate nixpkgs namespace.";
    };

    users = mkOption {
      type = listOf str;
      default = [];
      description = "List of actual users to be added. This is used for features to affect declared users and not system users.";
    };
  };
}
