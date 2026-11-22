{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.hjem.nixosModules.default ];
  hjem = {
    specialArgs = { inherit inputs; };
    clobberByDefault = true;
    extraModules = [
      ./_nh.nix
      ./_direnv.nix
      ./_ssh.nix
      ./runtime.nix
    ];
  };
  systemd.services."hjem-reload@".serviceConfig.ExecStartPre = [
    "${pkgs.writeShellScript "hjem-after-link" ''
      set -eu
      case "$1" in
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (_: user: ''
            ${lib.escapeShellArg user.user}) exec ${user.activation.script} ;;
          '') (lib.filterAttrs (_: user: user.enable) config.hjem.users)
        )}
        *) exit 0 ;;
      esac
    ''} %i"
  ];
}
