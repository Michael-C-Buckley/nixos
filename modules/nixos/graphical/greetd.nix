# Baseline Greetd used in the linux preset
# This is specific for my graphical hosts extending it
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.greetd = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) tuigreet;
  in {
    options.custom.greetd = {
      defaultCommand = lib.mkOption {
        type = lib.types.str;
        default = "mango";
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
            command = "${tuigreet}/bin/tuigreet --time --remember --remember-session";
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
