{
  config,
  lib,
  pkgs,
  ...
}:
let
  command = "start-hyprland";
  inherit (config.services.displayManager.sessionData) desktops;
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = lib.escapeShellArgs [
          (lib.getExe pkgs.tuigreet)
          "--remember-session"
          "--sessions"
          "${desktops}/share/wayland-sessions"
          "--cmd"
          command
          "--xsessions"
          "${desktops}/share/xsessions"
        ];
        user = lib.mkDefault "greeter";
      };
    };
  };
}
