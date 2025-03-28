{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals mkIf;
  useSDDM = config.features.displayManager == "sddm";
in {
  services.displayManager = mkIf useSDDM {
    autoLogin = {
      enable = config.features.autoLogin;
      user = "michael";
    };
    defaultSession = "hyprland";
    sddm = {
      enable = true;
      theme = "chili";
    };
  };

  environment.systemPackages = with pkgs;
    mkIf useSDDM [
      sddm-chili-theme
    ];
}
