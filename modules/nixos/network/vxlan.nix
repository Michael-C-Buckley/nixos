{
  flake.nixosModules.vxlan = {
    config,
    lib,
    ...
  }: {
    options.networking.vxlan = {
      port = lib.mkOption {
        type = lib.types.int;
        default = 4789;
        description = "UDP port that VXLAN will use";
      };
    };

    config.networking = {
      firewall.allowedUDPPorts = [config.networking.vxlan.port];
    };
  };
}
