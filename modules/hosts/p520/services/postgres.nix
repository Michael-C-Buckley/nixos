{
  flake.modules.nixos.p520 = {lib, ...}: {
    # Data directory is a ZFS dataset: zroot/p520/postgres
    services.postgresql = {
      enable = true;
      ensureDatabases = ["hydra" "atticd" "forgejo" "openwebui"];
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
        {
          name = "openwebui";
          ensureDBOwnership = true;
        }
      ];
      # Allow connections from pods (K3s default pod network)
      settings = {
        listen_addresses = lib.mkForce "0.0.0.0";
      };
      authentication = ''
        host forgejo forgejo 10.42.0.0/16 trust
        host openwebui openwebui 10.42.0.0/16 trust
      '';
    };

    networking.firewall.extraInputRules = ''
      ip saddr { 127.0.0.1, 10.42.0.0/16 } tcp dport 5432 accept comment "Allow PostgreSQL from localhost and k3s pods"
    '';
  };
}
