{config, ...}: {
  flake.modules.nixos.o1 = {
    imports = with config.flake.modules.nixos; [
      bgp
    ];

    networking = {
      hostId = "8c3d4e62";
      hostName = "o1";
      firewall = {
        allowedTCPPorts = [80 443];
        allowedUDPPortRanges = [
          {
            from = 33400;
            to = 33410;
          }
          {
            from = 33500;
            to = 33510;
          }
        ];
      };
    };
  };
}
