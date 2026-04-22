# Baseline Greetd used in the linux preset
# This is specific for my graphical hosts extending it
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

      # Session on first login which would use auto-login
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd}/bin/agreety";
            user = "greeter";
          };
          initial_session = {
            user = "michael";
            command = config.custom.greetd.defaultCommand;
          };
        };
      };
    };
  };
}
