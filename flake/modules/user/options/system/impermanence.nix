{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str nullOr null listOf;
in {
  options.system = {
    impermanence = {
      enable = mkEnableOption "Use impermanence on this user's home directory.";
      userPersistDevice = mkOption {
        type = nullOr str;
        default = null;
        description = "The device that Impermanence will persist and will be snapshotted.";
      };
      userCacheDevice = mkEnableOption {
        type = nullOr str;
        default = null;
        description = "Device that Impermanence will use to cache (persist but not snapshot).";
      };
      userPersistDirs = mkOption {
        type = listOf str;
        default = [];
        description = "The directories to be persisted";
      };
      userCacheDirs = mkOption {
        type = listOf str;
        default = [];
        description = "The directories to be persistently cached.";
      };
    };
  };
}
