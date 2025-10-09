{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) enum;
in {
  options.system = {
    preset = mkOption {
      type = enum ["cloud" "desktop" "laptop" "server" "wsl"];
      default = null;
      description = "Preset defines a set of common options by group type.";
    };
    impermanence = {
      enable = mkEnableOption "Enable Impermanence on the system's storage.";
    };
  };
}
