{config, ...}: let
  hostName = "b550";
  inherit (config.flake.hosts.${hostName}) interfaces;
in {
  flake.modules.nixos.${hostName} = {
    imports = with config.flake.modules.nixos; [
      bfd
      bgp
      ospf
    ];
    services = {
      iperf3.enable = true;
    };

    networking = {
      inherit hostName;
      hostId = "272a6fae";

      # TODO: switch to using internal DNS server once set up
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      firewall.trustedInterfaces = ["br0"];

      bridges = {
        br0.interfaces = []; # General use bridge, typically for VMs
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
        enp3s0f0 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.enp3s0f0.ipv4;
              prefixLength = 28;
            }
          ];
        };
        enp3s0f1 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.enp3s0f1.ipv4;
              prefixLength = 28;
            }
          ];
        };
      };
    };
  };
}
