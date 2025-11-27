{
  flake.modules.nixos.uff3 = {
    custom.enusb1.mac = "6c:1f:f7:06:13:8f";
    networking = {
      interfaces = {
        enusb1.ipv4.addresses = [
          {
            address = "192.168.61.147";
            prefixLength = 28;
          }
        ];
        eno1.ipv4.addresses = [
          {
            address = "192.168.49.33";
            prefixLength = 24;
          }
        ];
      };

      networkmanager.ensureProfiles.profiles = {
        home = {
          ipv4.address = "172.16.248.33/16";
          ipv6.address = "fe80::1003/64";
        };
        home2 = {
          ipv4.address = "172.30.248.33/16";
          ipv6.address = "fe80::1003/64";
        };
      };

      loopback.ipv4 = "192.168.61.3";
      hostId = "f303a8e8";
      hostName = "uff3";

      ospf.defaultRoute = {
        metricType = 1;
        metric = 500;
      };
    };

    services.keepalived.vrrpInstances = {
      wifi = {
        priority = 130;
        state = "MASTER";
      };
    };
  };
}
