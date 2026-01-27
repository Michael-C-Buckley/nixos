{config, ...}: {
  flake.modules.nixos.o1 = {pkgs, ...}: {
    imports = [config.flake.modules.nixos.postgres-sanoid];

    networking.firewall.allowedTCPPorts = [5432];

    systemd.services.postgresql.after = ["k3s.service"];

    services.postgresql = {
      enable = true;
      authentication = ''
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             all                                     peer
        host    all             all             127.0.0.1/32            scram-sha-256
        host    all             all             ::1/128                 scram-sha-256

        # Allow connections from k3s pod network
        host    authentik       authentik       10.42.0.0/16            scram-sha-256
        host    vaultwarden     vaultwarden     10.42.0.0/16            scram-sha-256
        host    forgejo         forgejo         10.42.0.0/17            scram-sha-256
      '';
      package = pkgs.postgresql_18;
      enableTCPIP = true; # makes it listen on all addresses
    };
  };
}
