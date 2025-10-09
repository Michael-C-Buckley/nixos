{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.features) autoLogin;
  useGreetd = config.features.displayManager == "greetd";
in {
  environment.systemPackages = [pkgs.tuigreet];

  services.greetd = mkIf useGreetd {
    enable = true;
    settings = {
      # Session on first login which would use auto-login
      initial_session = mkIf autoLogin {
        user = "michael";
        command = "hyprland";
      };
      # All other sessions
      default_session = {
        command = "tuigreet --cmd hyprland";
        user = "greeter";
      };
    };
  };
}
