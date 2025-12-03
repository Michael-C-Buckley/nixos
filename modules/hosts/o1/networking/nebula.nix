{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.o1 = {
    # This is all I need for now on this lighthouse unit
    imports = [flake.modules.nixos.nebula-main];

    services.nebula.networks.main = {
      isLighthouse = true;
      isRelay = true;

      lighthouse.dns = {
        enable = true;
        host = "[::]";
        port = 53;
      };
    };
  };
}
