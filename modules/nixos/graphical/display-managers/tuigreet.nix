{
  flake.nixosModules.tuigreet = {pkgs, ...}: {
    environment.systemPackages = [pkgs.tuigreet];

    hardware.graphics.enable = true;
    services.xserver.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        # Session on first login which would use auto-login
        initial_session = {
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
  };
}
