{config, ...}: let
  inherit (config.flake.hosts.p520) interfaces;
in {
  flake.modules.nixos.p520 = {
    imports = with config.flake.modules.nixos; [
      bfd
      bgp
      ospf
    ];
    services = {
      iperf3.enable = true;
    };

    networking = {
      # TODO: switch to using internal DNS server once set up
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];

      hostName = "p520";
      hostId = "181a3ead";

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
        enx2 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.ens1f0.ipv4;
              prefixLength = 28;
            }
          ];
        };
        enx3 = {
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
