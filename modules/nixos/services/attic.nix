{
  flake.modules.nixos.attic = {
    config,
    lib,
    ...
  }: let
    inherit (config.custom.attic) listenPort;
  in {
    options.custom.attic.listenPort = lib.mkOption {
      type = lib.types.int;
      default = 3080;
      description = "The TCP listener port number for the Attic NixOS service.";
    };

    config = {
      networking.firewall.allowedTCPPorts = [listenPort];

      # Completely static users and self-managed state directory
      systemd.services.atticd = {
        serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = "atticd";
          Group = "atticd";
        };
      };

      users = {
        users.atticd = {
          isSystemUser = true;
          group = "atticd";
        };
        groups.atticd = {};
      };

      services.atticd = {
        enable = true;
        environmentFile = config.sops.secrets.attic.path;

        settings = {
          listen = "[::]:${toString listenPort}";
          allowed-hosts = [];

          storage = {
            type = "local";
            path = "/var/lib/atticd";
          };
          # I provide compression via ZFS
          compression.type = "none";

          garbage-collection = {
            interval = "3 days";
            default-retention-policy = "1 year";
          };

          chunking = {
            nar-size-threshold = 64 * 1024; # 64 KiB
            min-size = 16 * 1024; # 16 KiB
            avg-size = 64 * 1024; # 64 KiB
            max-size = 256 * 1024; # 256 KiB
          };
        };
      };
    };
  };
}
