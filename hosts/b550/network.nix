{
  services.iperf3 = {
    enable = true;
    openFirewall = true;
  };
  networking = {
    hostId = "272a6fae";

    bridges = {
      br0.interfaces = [ ];
      br1.interfaces = [ "eno1" ];
      br100.interfaces = [ ];
    };

    defaultGateway = {
      address = "192.168.59.1";
      interface = "br1";
      metric = 49;
    };

    interfaces = {
      eno1.useDHCP = false;
      lo.ipv4.addresses = [
        {
          address = "192.168.63.6";
          prefixLength = 32;
        }
      ];
      br1.ipv4.addresses = [
        {
          address = "192.168.59.9";
          prefixLength = 27;
        }
      ];
      br0.ipv4.addresses = [
        {
          address = "192.168.56.33";
          prefixLength = 27;
        }
      ];
      br100.ipv4.addresses = [
        {
          address = "192.168.56.38";
          prefixLength = 27;
        }
      ];
      enp2.ipv4.addresses = [
        {
          address = "192.168.60.133";
          prefixLength = 28;
        }
      ];
      enx3.ipv4.addresses = [
        {
          address = "192.168.60.147";
          prefixLength = 28;
        }
      ];
      enx4.ipv4.addresses = [
        {
          address = "192.168.60.3";
          prefixLength = 29;
        }
      ];

    };
  };
}
