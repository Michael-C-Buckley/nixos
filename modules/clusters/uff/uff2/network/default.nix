{
  flake.modules.nixos.uff2 = {
    networkd = {
      eno1.addresses.ipv4 = ["192.168.48.32/24"];
      enusb1 = {
        mac = "6c:1f:f7:06:27:ae";
        addresses.ipv4 = ["192.168.254.2/27"];
      };
    };

    networking = {
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

    services.keepalived.vrrpInstances.wan = {
      priority = 120;
    };
  };
}
