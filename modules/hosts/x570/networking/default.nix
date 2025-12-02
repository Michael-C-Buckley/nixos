{config, ...}: let
  inherit (config.flake.hosts.x570) interfaces;
in {
  flake.modules.nixos.x570 = {
    services = {
      iperf3.enable = true;

      # Make the 10GbE NIC static
      udev.extraRules = ''
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:60:01:b8", NAME="enx10p1"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="90:e2:ba:60:01:b9", NAME="enx10p2"
      '';
    };

    # Don't wait for DHCP as I use static IPs
    systemd.network.wait-online.anyInterface = true;

    networking = {
      hostId = "c07fa570";
      hostName = "x570";

      # I use networkmanager for wifi
      # Wired interfaces will be on networkd
      networkmanager = {
        enable = true;
        unmanaged = [
          "enp6s0"
          "enp7s0"
          "enx10p1"
          "enx10p2"
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
        enp6s0.ipv4.addresses = [
          {
            address = interfaces.enp6s0.ipv4;
            prefixLength = 24;
          }
        ];
        enp7s0 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.enp7s0.ipv4;
              prefixLength = 28;
            }
          ];
        };
        enx10p1 = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = interfaces.enx10p1.ipv4;
              prefixLength = 28;
            }
          ];
        };
        lo.ipv4.addresses = [
          {
            address = interfaces.lo.ipv4;
            prefixLength = 32;
          }
        ];
      };
    };
  };
}
