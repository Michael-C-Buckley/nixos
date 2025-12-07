{config, ...}: let
  hostName = "b550";
  inherit (config.flake.hosts.${hostName}.interfaces) lo br0 eno1 enp2 enx3 enx4;

  mkIntf = address: {
    mtu = 9000;
    addresses = [
      {
        inherit address;
        prefixLength = 28;
      }
    ];
  };
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
        lo.ipv4.addresses = [
          {
            address = lo.ipv4;
            prefixLength = 32;
          }
        ];
        br0.ipv4.addresses = [
          {
            address = br0.ipv4;
            prefixLength = 27;
          }
        ];
        eno1.ipv4.addresses = [
          {
            address = eno1.ipv4;
            prefixLength = 24;
          }
        ];
        enp2.ipv4 = mkIntf enp2.ipv4;
        enx3.ipv4 = mkIntf enx3.ipv4;
        enx4.ipv4 = mkIntf enx4.ipv4;
      };
    };
  };
}
