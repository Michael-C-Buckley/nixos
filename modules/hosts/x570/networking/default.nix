{config, ...}: let
  inherit (config.flake.hosts.x570.interfaces) lo eno1 eno2 enx3;
in {
  flake.modules.nixos.x570 = {
    imports = with config.flake.modules.nixos; [
      bgp
      ospf
    ];

    services = {
      iperf3.enable = true;
    };

    # Don't wait for DHCP as I use static IPs
    systemd.network.wait-online.anyInterface = true;

    networking = {
      hostId = "c07fa570";
      hostName = "x570";

      defaultGateway = {
        address = "192.168.48.30";
        interface = "eno1";
        metric = 20;
      };

      # I use networkmanager for wifi
      # Wired interfaces will be on networkd
      networkmanager = {
        enable = true;
        unmanaged = [
          "eno1"
          "eno2"
          "enx3"
          "enx4"
        ];
      };
      useNetworkd = true;

      # Virtual only bridge
      bridges.br0 = {
        interfaces = [];
      };

      firewall = {
        allowedUDPPorts = [33401];
        trustedInterfaces = ["br0"];
      };

      interfaces = {
        eno1.ipv4.addresses = [
          {
            address = eno1.ipv4;
            prefixLength = 24;
          }
        ];
        eno2 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = eno2.ipv4;
              prefixLength = 28;
            }
          ];
        };
        enx3 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = enx3.ipv4;
              prefixLength = 28;
            }
          ];
        };
        lo.ipv4.addresses = [
          {
            address = lo.ipv4;
            prefixLength = 32;
          }
        ];
      };
    };
  };
}
