{
  flake.modules.nixos.p520 = {
    # Data directory is a ZFS dataset: zroot/p520/postgres
    services.postgresql = {
      enable = true;
      ensureDatabases = ["hydra" "atticd" "forgejo"];
      ensureUsers = [
        {
          name = "hydra";
          ensureDBOwnership = true;
          ensureClauses = {createdb = true;};
        }
        {
          name = "atticd";
          ensureDBOwnership = true;
        }
        {
          name = "forgejo";
          ensureDBOwnership = true;
        }
      ];
      # Allow connections from pods (K3s default pod network)
      settings = {
        listen_addresses = "'localhost,192.168.63.5'";
      };
      authentication = ''
        host forgejo forgejo 10.42.0.0/16 trust
      '';
    };
  };
}
