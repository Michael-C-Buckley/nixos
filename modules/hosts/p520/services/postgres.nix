{
  flake.modules.nixos.p520 = {
    # Data directory is a ZFS dataset: zroot/p520/postgres
    services.postgresql = {
      enable = true;
      ensureDatabases = ["hydra"];
      ensureUsers = [
        {
          name = "hydra";
          ensureDBOwnership = true;
          ensureClauses = {createdb = true;};
        }
      ];
    };
  };
}
