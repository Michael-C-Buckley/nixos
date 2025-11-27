{
  flake.modules.nixos.uff2 = {
    custom.enusb1.mac = "6c:1f:f7:06:27:ae";
    networking = {
      interfaces = {
        enusb1.ipv4.addresses = [
          {
            address = "192.168.61.146";
            prefixLength = 28;
          }
        ];
        eno1.ipv4.addresses = [
          {
            address = "192.168.49.32";
            prefixLength = 24;
          }
        ];
      };

      networkmanager.ensureProfiles.profiles = {
        home = {
          ipv4.address = "172.16.248.32/16";
          ipv6.address = "fe80::1002/64";
        };
        home2 = {
          ipv4.address = "172.30.248.32/16";
          ipv6.address = "fe80::1002/64";
        };
      };

      loopback.ipv4 = "192.168.61.2";
      hostId = "072294f5";
      hostName = "uff2";

      ospf.defaultRoute = {
        metricType = 1;
        metric = 510;
      };
    };

    services.keepalived.vrrpInstances = {
      wifi.priority = 120;
    };
  };
}
