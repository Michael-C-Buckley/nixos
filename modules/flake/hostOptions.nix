# Options used in NixOS hosts
{lib, ...}: {
  options.host = {
    impermanence = {
      enable = lib.mkEnableOption "Enable impermanence features on this host.";

      cache = {
        directories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "List of directories to bind mount from /cache to the root filesystem for persistence without snapshots.";
        };
        persist = {
          directories = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of directories to bind mount from /persist to the root filesystem for persistent storage with snapshots.";
          };
        };
      };
    };
  };
}
