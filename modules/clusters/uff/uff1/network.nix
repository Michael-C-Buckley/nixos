{
  flake.modules.nixos.uff1 = {
    custom.enusb1.mac = "6c:1f:f7:06:27:8e";
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
