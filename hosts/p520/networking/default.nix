_: {
  imports = [
    ./routing.nix
  ];

  networking = {
    ospf.enable = true;
    hostName = "p520";
    hostId = "181a3ead";

    # WIP: Temporary default static route to avoid issues until VRRP goes online
    defaultGateway = { address = "192.168.48.102"; interface = "br0"; };

    # WIP: transition to resolved
    nameservers = [
      "1.1.1.1"
    ];

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
