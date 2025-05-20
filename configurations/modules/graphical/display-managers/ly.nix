# Legacy Module
#  TUIgreet has pretty much replaced this for me
#  Since it does not support auto-login
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
