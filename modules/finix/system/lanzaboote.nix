{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.lanzaboote;
  loaderFormat = pkgs.formats.keyValue {
    mkKeyValue = k: v: lib.generators.mkKeyValueDefault { } " " k v;
  };
  loaderConfig = loaderFormat.generate "loader.conf" cfg.settings;
  latest = import ../../nixos/system/_lanzaboote-latest-entry.nix {
    inherit lib pkgs;
    namespace = "finix";
    title = "Finix";
  };
in
{
  options.boot.lanzaboote = {
    enable = lib.mkEnableOption "Lanzaboote Secure Boot";

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.lanzaboote.packages.${pkgs.stdenv.hostPlatform.system}.lzbt.overrideAttrs (old: {
        # Upstream owns EFI/nixos and every nixos-* UKI. Give Finix its
        # own artifacts so either installation can prune independently.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace systemd/src/esp.rs \
            --replace-fail 'efi.join("nixos")' 'efi.join("finix")'
          substituteInPlace systemd/src/install.rs \
            --replace-fail 'n.starts_with("nixos-")' 'n.starts_with("finix-")' \
            --replace-fail '"nixos-generation-' '"finix-generation-'
        '';
        # Upstream integration checks assume the original nixos namespace.
        doCheck = false;
      });
      description = "Lanzaboote installer with a separate Finix ESP namespace.";
    };

    pkiBundle = lib.mkOption {
      type = lib.types.externalPath;
      description = "Existing sbctl PKI bundle; keys stay outside the Nix store.";
    };

    configurationLimit = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 3;
      description = "Number of Finix generations to retain on the ESP; zero keeps all.";
    };

    settings = lib.mkOption {
      inherit (loaderFormat) type;
      default = {
        timeout = 4;
        editor = false;
        default = "@saved";
      };
      description = "Shared systemd-boot loader.conf settings.";
    };

    latestEntry = latest.options;
  };

  config = lib.mkIf cfg.enable {
    boot.bootspec = {
      enable = true;
      extensions."org.nix-community.lanzaboote".sort_key = latest.generationSortKey cfg.latestEntry;
    };

    boot.loader.script = {
      enable = true;
      installHook = pkgs.writeShellScript "install-lanzaboote-finix" ''
        set -euo pipefail
        export PATH=${pkgs.systemd}/lib/systemd:${lib.makeBinPath [ pkgs.coreutils ]}:$PATH
        shopt -s nullglob
        generations=(/nix/var/nix/profiles/system-*-link)
        if (( ''${#generations[@]} == 0 )); then
          echo "No Finix system generations found to install." >&2
          exit 1
        fi
        ${lib.getExe cfg.package} install \
          --system ${pkgs.stdenv.hostPlatform.system} \
          --systemd ${pkgs.systemd} \
          --systemd-boot-loader-config ${loaderConfig} \
          --configuration-limit ${toString cfg.configurationLimit} \
          --allow-unsigned false \
          --public-key ${lib.escapeShellArg "${cfg.pkiBundle}/keys/db/db.pem"} \
          --private-key ${lib.escapeShellArg "${cfg.pkiBundle}/keys/db/db.key"} \
          --protected-system /run/current-system \
          ${lib.escapeShellArg config.boot.loader.efi.efiSysMountPoint} \
          "''${generations[@]}"
        ${lib.optionalString cfg.latestEntry.enable (
          latest.command cfg.latestEntry config.boot.loader.efi.efiSysMountPoint
        )}
      '';
    };

    environment.systemPackages = [
      pkgs.sbctl
      pkgs.efibootmgr
    ];
  };
}
