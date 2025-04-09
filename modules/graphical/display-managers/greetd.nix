{
  config,
  lib,
  ...
}: let
  useGreetd = config.features.displayManager == "greetd";
in {
  # For now, it performs an autologin for me
  services.greetd = lib.mkIf useGreetd {
    enable = true;
    settings = {
      default_session.command = "hyprland";
      initial_session = {
        user = "michael";
        command = "hyprland";
      };
    };
  };
}
