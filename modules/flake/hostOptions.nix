# Options used in NixOS hosts
{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
in {
  options.host = {
    bootloader = mkOption {
      # None is used in special circumstances like WSL
      type = enum ["systemd-boot" "grub" "limine" "none"];
      default = "systemd";
      description = "Which bootloader flake module to use with the host.";
    };
    impermanence = {
      enable = mkEnableOption "Enable impermanence features on this host.";

      cache = {
        directories = mkOption {
          type = listOf string;
          default = [];
          description = "List of directories to bind mount from /cache to the root filesystem for persistence without snapshots.";
        };
        persist = {
          directories = mkOption {
            type = listOf string;
            default = [];
            description = "List of directories to bind mount from /persist to the root filesystem for persistent storage with snapshots.";
          };
        };
      };
    };

    graphicalPackages = mkOption {
      type = with lib.types; listOf string;
      default = [];
      description = "List of graphical packages to install on this host. The strings will be interpreted later into the appropriate nixpkgs namespace.";
    };

    pkgs = mkOption {
      type = lib.types.attrs;
      default = {};
      description = "The imported nixpkgs of this host.";
    };
  };
}
