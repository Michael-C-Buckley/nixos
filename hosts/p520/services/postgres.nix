{
  flake.modules.nixos.p520 = {lib, ...}: {
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
      settings = {
        listen_addresses = lib.mkForce "0.0.0.0";
      };
    };

    networking.firewall.extraInputRules = ''
      ip saddr { 127.0.0.1, 10.42.0.0/16 192.168.0.0/16 } tcp dport 5432 accept comment "Allow PostgreSQL from LAN"
    '';
  };
}
