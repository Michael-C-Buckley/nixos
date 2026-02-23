{
  flake.modules.nixos.greetd = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.custom.greetd = {
      defaultCommand = lib.mkOption {
        type = lib.types.str;
        default = "start-hyprland";
        description = "The default session command for greetd and auto-login";
      };
    };

    config = {
      hardware.graphics.enable = true;
      services.xserver.enable = true;

      services = {
        displayManager.ly.enable = false; # Intentionally collide
        greetd = {
          enable = true;
          useTextGreeter = true;
          settings = {
            # Session on first login which would use auto-login
            initial_session = {
              user = "michael";
              command = config.custom.greetd.defaultCommand;
            };
            # All other sessions
            default_session = {
              command = "${pkgs.greetd}/bin/agreety";
              user = "greeter";
            };
          };
        };
      };
    };
  };
}
