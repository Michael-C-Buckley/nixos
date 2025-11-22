{
  flake.modules.nixos.x570 = {
    services = {
      iperf3.enable = true;
    };

    # Don't wait for DHCP as I use static IPs
    systemd.network.wait-online.anyInterface = true;

    networking = {
      hostId = "c07fa570";
      hostName = "x570";
      networkmanager = {
        enable = true;
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
        enp7s0.ipv4.addresses = [
          {
            address = "192.168.49.10";
            prefixLength = 24;
          }
        ];
        lo.ipv4.addresses = [
          {
            address = "192.168.63.10";
            prefixLength = 32;
          }
        ];
      };
    };
  };
}
