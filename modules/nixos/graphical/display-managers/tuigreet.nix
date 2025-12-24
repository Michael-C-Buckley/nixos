{
  flake.modules.nixos.tuigreet = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.custom.tuigreet = {
      defaultCommand = lib.mkOption {
        type = lib.types.str;
        # This is the wrapped niri provided within this flake
        default = "niri";
        description = "The default session command for tuigreet and auto-login";
      };
    };

    config = {
      environment.systemPackages = [pkgs.tuigreet];
      hardware.graphics.enable = true;
      services.xserver.enable = true;

      services = {
        displayManager.ly.enable = false; # Intentionally collide
        greetd = {
          enable = true;
          settings = {
            # Session on first login which would use auto-login
            initial_session = {
              user = "michael";
              command = config.custom.tuigreet.defaultCommand;
            };
            # All other sessions
            default_session = {
              command = "tuigreet --cmd " + config.custom.tuigreet.defaultCommand;
              user = "greeter";
            };
          };
        };
      };
    };
  };
}
