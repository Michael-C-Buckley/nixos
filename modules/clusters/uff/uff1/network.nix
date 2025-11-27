{
  flake.modules.nixos.uff1 = {
    networkd = {
      eno1.addresses.ipv4 = ["192.168.49.31/24"];
      enusb1 = {
        mac = "6c:1f:f7:06:27:8e";
        addresses.ipv4 = ["192.168.61.145/28"];
      };
    };

    networking = {
      networkmanager.ensureProfiles.profiles = {
        home = {
          ipv4.address = "172.16.248.31/16";
          ipv6.address = "fe80::1001/64";
        };
        home2 = {
          ipv4.address = "172.30.248.31/16";
          ipv6.address = "fe80::1001/64";
        };
      };

      loopback.ipv4 = "192.168.61.1";
      hostId = "ab0406ca";
      hostName = "uff1";

      ospf.defaultRoute = {
        metricType = 1;
        metric = 520;
      };
    };

    services.keepalived.vrrpInstances = {
      wifi.priority = 110;
    };
  };
}
