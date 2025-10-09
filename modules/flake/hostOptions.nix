# Options used in NixOS hosts
{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) listOf string;
in {
  options.host = {
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
      type = listOf string;
      default = [];
      description = "List of graphical packages to install on this host. The strings will be interpreted later into the appropriate nixpkgs namespace.";
    };
  };
}
