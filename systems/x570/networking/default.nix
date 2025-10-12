{
  flake.nixosConfigurations.x570.networking = {
    services = {
      iperf3.enable = true;
      unbound.enable = true;
    };

    networking = {
      hostId = "c07fa570";
      hostName = "x570";
      networkmanager = {
        enable = true;
      };
      useNetworkd = false;

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
            address = "192.168.48.10";
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
