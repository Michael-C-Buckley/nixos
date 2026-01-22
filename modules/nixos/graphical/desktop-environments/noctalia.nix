# Not technically a DE/WM but a Quickshell theme I'm just living here
# Based largely on the official Noctalia NixOS module
# https://github.com/noctalia-dev/noctalia-shell/blob/main/nix/nixos-module.nix
{
  flake.modules.nixos.noctalia = {
    config,
    lib,
    ...
  }: let
    local = config.custom.noctalia;
  in {
    custom.impermanence.persist.allUsers.directories = [
      ".config/noctalia"
    ];
    systemd.user.services.noctalia = lib.mkIf (config.custom.noctalia.parent != null) {
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
}
