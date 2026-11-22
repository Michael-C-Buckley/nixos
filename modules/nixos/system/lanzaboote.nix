{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.lanzaboote.latestEntry;
  latest = import ./_lanzaboote-latest-entry.nix {
    inherit lib pkgs;
    namespace = "nixos";
    title = "NixOS";
  };
in
{
  imports = [ inputs.lanzaboote.nixosModules.default ];

  options.boot.lanzaboote.latestEntry = latest.options;

  config = lib.mkMerge [
    {
      boot = {
        loader = {
          systemd-boot.enable = false;
          limine.enable = lib.mkForce false;
        };
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          configurationLimit = 3;
          # Group NixOS generations under its distro name, after Finix.
          sortKey = latest.generationSortKey cfg;
        };
      };
    }

    # Upstream keeps its lzbt hook private, so wrap the installer that
    # switch-to-configuration calls instead of the hook option itself.
    (lib.mkIf cfg.enable {
      system.build.installBootLoader = lib.mkForce (
        pkgs.writeShellScript "install-lanzaboote-latest" ''
          set -euo pipefail
          ${config.boot.loader.external.installHook} "$@"
          ${latest.command cfg config.boot.loader.efi.efiSysMountPoint}
        ''
      );
    })
  ];
}
