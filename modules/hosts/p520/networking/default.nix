{
  flake.modules.nixos.p520 = {
    services = {
      iperf3.enable = true;
    };

    networking = {
      nameservers = [
        "192.168.49.1"
        "192.168.49.31"
        "192.168.49.32"
        "192.168.49.33"
      ];

      hostName = "p520";
      hostId = "181a3ead";

      # I would like to learn default routes with routing but container
      # networking is a massive thorn as it creates endless unwanted
      # default routes that I absolutely did not ask for;
      # So for now, use my core switch within the LAN
      defaultGateway = {
        address = "192.168.49.2";
        interface = "br0";
      };

      loopback.ipv4 = "192.168.63.5";

      firewall.trustedInterfaces = ["br0"];

      bridges = {
        br0.interfaces = ["eno1"];
      };
      interfaces = {
        br0.ipv4.addresses = [
          {
            address = "192.168.49.5";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
