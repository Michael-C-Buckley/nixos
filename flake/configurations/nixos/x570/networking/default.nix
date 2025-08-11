_: {
  imports = [
    ./routing.nix
    ./wireguard.nix
  ];

  services.unbound.enable = true;

  networking = {
    hostId = "c07fa570";
    networkmanager.enable = true;
    #useNetworkd = true;

    # Virtual only bridge
    bridges.br0 = {
      interfaces = [];
    };

    loopback.ipv4 = "192.168.63.10/32";

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
    };
  };
}
