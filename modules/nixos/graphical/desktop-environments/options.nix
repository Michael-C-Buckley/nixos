{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.linuxPreset = {
    pkgs,
    lib,
    ...
  }: {
    options.custom = {
      niri.extraConfig = lib.mkOption {
        description = "Instance-specific options that gets sent to the wrapper function.";
        type = lib.types.lines;
        default = '''';
      };

      noctalia = {
        target = lib.mkOption {
          description = "Systemd user service target that triggers Noctalia.";
          type = lib.types.str;
          default = "graphical-session.target";
        };
        parent = lib.mkOption {
          description = "Systemd user service that Noctalia will inherit and link into.";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        package = lib.mkOption {
          description = "Which Noctalia package to use.";
          type = lib.types.package;
          default = flake.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
        };
      };
    };
  };
}
