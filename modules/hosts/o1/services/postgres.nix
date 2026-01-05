{
  flake.modules.nixos.o1 = {
    services.postgresql = {
      enable = true;
      settings = {
        listen_addresses = "0.0.0.0";
      };
    };
  };
}
