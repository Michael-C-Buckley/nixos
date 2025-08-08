{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  useGreetd = config.features.displayManager == "greetd";

  tuiSession = {
    command = "tuigreet --cmd hyprland";
    user = "greeter";
  };
in {
  environment.systemPackages = [pkgs.tuigreet];

  services.greetd = mkIf useGreetd {
    enable = true;
    settings = {
      # Session on first login which would use auto-login
      initial_session = mkIf config.features.autoLogin {
        user = "michael";
        command = "hyprland";
      };
      # All other sessions
      default_session = tuiSession;
    };
  };
}
