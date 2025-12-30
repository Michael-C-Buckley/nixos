# Not technically a DE/WM but a Quickshell theme I'm just living here
# Based largely on the official Noctalia NixOS module
# https://github.com/noctalia-dev/noctalia-shell/blob/main/nix/nixos-module.nix
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.noctalia = {
    config,
    pkgs,
    lib,
    ...
  }: let
    local = config.custom.noctalia;
  in {
    options.custom.noctalia = {
      target = lib.mkOption {
        description = "Systemd user service target that triggers Noctalia.";
        type = lib.types.str;
        default = "graphical-session.target";
      };
      parent = lib.mkOption {
        description = "Systemd user service that Noctalia will inherit and link into.";
        type = lib.types.str;
      };
      package = lib.mkOption {
        description = "Which Noctalia package to use.";
        type = lib.types.package;
        default = flake.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
      };
    };

    config = {
      custom.impermanence.persist.user.directories = [
        ".config/noctalia"
      ];
      systemd.user.services.noctalia = {
        description = "Noctalia Shell";
        documentation = ["https://docs.noctalia.dev/docs"];

        after = [local.parent];
        bindsTo = [local.parent];
        wantedBy = [local.target];

        serviceConfig = {
          Slice = "session.slice";
          ExecStart = lib.getExe local.package;
          Restart = "on-failure";
          Environment = [
            "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
          ];
        };
        environment = {
          PATH = lib.mkForce "/run/wrappers/bin:/run/current-system/sw/bin";
        };
      };
    };
  };
}
