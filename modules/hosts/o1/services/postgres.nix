{
  flake.modules.nixos.o1 = {
    pkgs,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [5432];

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      settings = {
        listen_addresses = lib.mkForce "127.0.0.1,10.42.0.1";
      };
    };
  };
}
