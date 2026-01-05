{
  flake.modules.nixos.o1 = {
    pkgs,
    lib,
    ...
  }: {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
      settings = {
        # This will be adjusted
        listen_addresses = lib.mkForce "0.0.0.0";
      };
    };
  };
}
