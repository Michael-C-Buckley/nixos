_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    ospf.enable = true;
    hostId = "181a3ead";

    loopback.ipv4 = "192.168.63.5";

    bridges.br0.interfaces = ["eno1"];
    interfaces.br0.ipv4 = {
      addresses = [
        {
          address = "192.168.48.5";
          prefixLength = 24;
        }
      ];
    };
  };
}
