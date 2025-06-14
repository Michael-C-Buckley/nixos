{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.system.preset
    == "desktop") {
    environment.systemPackages = with pkgs; [
      devenv
    ];

    programs = {
      cosmic.enable = true;
      hyprland.enable = true;
    };

    features = {
      michael = {
        extendedGraphical = true;
        hyprland.enable = true;
      };
      autoLogin = true;
      displayManager = "greetd";
      gaming.enable = true;
      pkgs.fonts = true;
    };
  };
}
