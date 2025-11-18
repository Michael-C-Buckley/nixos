{
  flake.modules.nixos.p520 = {lib, ...}: {
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
        listen_addresses = lib.mkForce "0.0.0.0";
      };
      authentication = ''
        host forgejo forgejo 10.42.0.0/16 trust
      '';
    };
  };
}
