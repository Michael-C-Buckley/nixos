{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  useLy = config.features.displayManager == "ly";
in {
  services.displayManager = mkIf useLy {
    defaultSession = "hyprland";
    ly.enable = true;
  };
}
