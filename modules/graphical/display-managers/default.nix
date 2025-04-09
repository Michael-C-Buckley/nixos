{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf;
in {
  imports = [
    ./greetd.nix
    ./ly.nix
    ./sddm.nix
  ];

  options.features = {
    autoLogin = mkEnableOption {};
    displayManager = mkOption {
      type = types.enum ["sddm" "ly" "greetd"];
      default = "ly";
      description = "Which display manager to run";
    };
    graphics = mkOption {
      type = types.bool;
      default = true;
      description = "Enable graphical features on host.";
    };
  };

  config = mkIf config.features.graphics {
    hardware.graphics.enable = true;
    services.xserver.enable = true;
  };
}
