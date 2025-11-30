{config, ...}: let
  inherit (config.flake.hosts.p520) interfaces;
in {
  flake.modules.nixos.p520 = {
    services = {
      iperf3.enable = true;
    };

    networking = {
      nameservers = [
        "192.168.49.1"
        "192.168.49.31"
        "192.168.49.32"
        "192.168.49.33"
      ];

      hostName = "p520";
      hostId = "181a3ead";

      # I would like to learn default routes with routing but container
      # networking is a massive thorn as it creates endless unwanted
      # default routes that I absolutely did not ask for;
      # So for now, use my core switch within the LAN
      defaultGateway = {
        address = "192.168.49.1";
        interface = "br0";
      };

      firewall.trustedInterfaces = ["br0"];

      bridges = {
        br0.interfaces = [];
      };
      interfaces = {
        br0.ipv4.addresses = [
          {
            address = interfaces.br0.ipv4;
            prefixLength = 27;
          }
        ];
        eno1.ipv4.addresses = [
          {
            address = interfaces.eno1.ipv4;
            prefixLength = 24;
          }
        ];
        ens1f0 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.ens1f0.ipv4;
              prefixLength = 28;
            }
          ];
        };
        ens1f1 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.ens1f1.ipv4;
              prefixLength = 28;
            }
          ];
        };
      };
    };
  };
}
