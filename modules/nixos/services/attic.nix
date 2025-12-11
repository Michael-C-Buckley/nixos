{
  flake.modules.nixos.attic = {config, ...}: {
    services.atticd = {
      enable = true;
      environmentFile = config.sops.secrets.attic.path;

      settings = {
        listen = "[::]:3080";
        allowed-hosts = [];

        storage = {
          type = "local";
          path = "/var/lib/attic";
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
}
