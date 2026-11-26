{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.netbird;
  stateDir = "/var/lib/netbird";
  env = {
    NB_CONFIG = "${stateDir}/config.json";
    NB_DAEMON_ADDR = "unix:///run/netbird/sock";
    NB_INTERFACE_NAME = cfg.interface;
    NB_LOG_FILE = "console";
    NB_LOG_LEVEL = "info";
    NB_SERVICE = "netbird";
    NB_STATE_DIR = stateDir;
    NB_WIREGUARD_PORT = toString cfg.port;
  };
  # The CLI and daemon must agree on the socket and state paths.
  wrapped = pkgs.symlinkJoin {
    name = "${cfg.package.name}-wrapper";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/netbird ${
        lib.concatStringsSep " " (
          lib.mapAttrsToList (name: value: "--set-default ${name} ${lib.escapeShellArg value}") env
        )
      }
    '';
  };
  mergeConfig = pkgs.writeShellScript "netbird-merge-config" ''
    set -eu
    export PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.diffutils
        pkgs.jq
      ]
    }
    config=${env.NB_CONFIG}
    test -e "$config" || printf '{}' > "$config"
    jq -sS 'reduce .[] as $i ({}; . * $i)' "$config" /etc/netbird/config.d/*.json > "$config.new"
    if cmp -s <(jq -S < "$config") "$config.new"; then
      rm "$config.new"
    else
      mv "$config.new" "$config"
    fi
  '';
in
{
  options.services.netbird = {
    enable = lib.mkEnableOption "the NetBird client daemon";
    package = lib.mkPackageOption pkgs "netbird" { };
    interface = lib.mkOption {
      type = lib.types.str;
      default = "wt0";
      description = "WireGuard interface name.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 51820;
      description = "WireGuard listening port.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the WireGuard port, and NetBird DNS/mDNS on its interface.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ wrapped ];
        environment.etc."netbird/config.d/50-finix.json".text = builtins.toJSON {
          DisableAutoConnect = false;
          WgIface = cfg.interface;
          WgPort = cfg.port;
        };
        boot.kernelModules = [ "wireguard" ];
        finit.services.netbird = {
          description = "NetBird client daemon";
          conditions = [ "hook/net/up" ];
          command = "${wrapped}/bin/netbird service run";
          exec-start-pre = "${mergeConfig}";
          state-dir = "netbird";
          state-dir-mode = "0700";
          runtime-dir = "netbird";
          runtime-dir-mode = "0755";
          path = [
            pkgs.iproute2
            pkgs.kmod
            pkgs.nftables
            pkgs.openresolv
          ];
          log = { };
        };
        providers.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
      }
      (lib.optionalAttrs (options.services ? nftables) {
        services.nftables.tables.nixos-fw.content = lib.mkIf cfg.openFirewall (
          lib.mkAfter ''
            chain input-allow {
              iifname "${cfg.interface}" udp dport { 5353, 22054 } accept comment "NetBird mDNS and DNS"
            }
          ''
        );
      })
    ]
  );
}
