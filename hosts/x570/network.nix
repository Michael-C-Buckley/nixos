{
  networking = {
    hostId = "c07fa570";
    useNetworkd = true;

    bridges = {
      br1.interfaces = [ "eno1" ];
      br100.interfaces = [ ];
    };

    defaultGateway = {
      address = "192.168.59.1";
      interface = "br1";
      metric = 99;
    };

    interfaces = {
      eno1.useDHCP = false;
      br1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.59.7";
            prefixLength = 27;
          }
        ];
      };
    };
  };

  services = {
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
