{
  imports = [
    ./routing.nix
  ];

  services = {
    iperf3.enable = true;
    unbound.enable = true;
  };

  networking = {
    ospf.enable = true;
    hostName = "p520";
    hostId = "181a3ead";

    loopback.ipv4 = "192.168.63.5";

    firewall.trustedInterfaces = ["br0" "br200"];

    bridges = {
      br0.interfaces = ["eno1"];
      # Internal Quadlet Network
      br200.interfaces = [];
    };
    interfaces = {
      br0.ipv4.addresses = [
        {
          address = "192.168.48.5";
          prefixLength = 24;
        }
      ];
      br200.ipv4.addresses = [
        {
          address = "192.168.53.1";
          prefixLength = 26;
        }
      ];
    };
  };
}
