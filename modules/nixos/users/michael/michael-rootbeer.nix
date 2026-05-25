# Link my rootbeer generated configs
{
  inputs,
  config,
  pkgs,
  lib,
  flake,
  ...
}: let
  smfh = lib.getExe pkgs.smfh;
  drv = inputs.dotfiles.packages.${flake.system}."config-${config.networking.hostName}";
  manifest = "${drv}/manifest.json";
in {
  hjem.users.michael = {
    systemd.services.rootbeer = {
      wantedBy = ["multi-user.target"];
      script = "${smfh} activate ${manifest}";
      postStop = "${smfh} deactivate ${manifest}";
    };
  };
}
