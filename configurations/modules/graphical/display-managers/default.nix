{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) nullOr enum bool;

  choices = enum ["sddm" "ly" "greetd"];
in {
  imports = [
    ./greetd.nix
    ./ly.nix
    ./sddm.nix
  ];

  options.features = {
    autoLogin = mkEnableOption {};
    displayManager = mkOption {
      type = nullOr choices;
      default = null;
      description = "Which display manager to run";
    };
    graphics = mkOption {
      type = bool;
      default = true;
      description = "Enable graphical features on host.";
    };
  };

  config = mkIf config.features.graphics {
    hardware.graphics.enable = true;
    services.xserver.enable = config.features.displayManager != null;
  };
}
