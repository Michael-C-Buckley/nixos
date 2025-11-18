{
  flake.modules.nixos.p520 = {
    services.atticd = {
      enable = true;

      environmentFile = "/run/secrets/atticEnv"; # Must be quoted absolute path

      settings = {
        listen = "[::]:5002";
        allowed-hosts = ["192.168.0.0/16"];
        require-proof-of-possession = false;

        database.url = "postgresql:///atticd?host=/run/postgresql";

        storage = {
          type = "local";
          path = "/var/lib/attic"; # ZFS: zroot/local/attic
        };

        chunking = {
          # These are the recommended defaults
          nar-size-threshold = 64 * 1024; # 64 KiB
          # The preferred minimum size of a chunk, in bytes
          min-size = 16 * 1024; # 16 KiB
          # The preferred average size of a chunk, in bytes
          avg-size = 64 * 1024; # 64 KiB
          # The preferred maximum size of a chunk, in bytes
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };
  };
}
