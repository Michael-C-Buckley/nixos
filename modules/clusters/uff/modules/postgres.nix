{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.uff = {
    config,
    pkgs,
    ...
  }: let
    lo = flake.hosts.${config.networking.hostName}.interfaces.lo.ipv4;
  in {
    # The hosts already have the filesystem declared
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;

      settings = {
        listen_addresses = "${lo},127.0.0.1,[::1]";
        wal_level = "replica";
        max_wal_senders = 10;
        max_replication_slots = 10;
        hot_standby = "on";
      };
    };

    networking.firewall.extraInputRules = ''
      ip saddr { 127.0.0.0/8, 10.42.0.0/16, 192.168.0.0/16 } tcp dport 5432 accept comment "Allow PostgreSQL from LAN"
    '';
  };
}
