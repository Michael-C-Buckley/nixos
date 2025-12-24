{
  flake.modules.nixos.uff2 = {
    networking = {
      networkmanager.ensureProfiles.profiles = {
        home = {
          ipv4.address = "172.16.166.32/16";
          ipv6.address = "fe80::1002/64";
        };
        home2 = {
          ipv4.address = "172.30.166.32/16";
          ipv6.address = "fe80::1002/64";
        };
      };

      hostId = "072294f5";
      hostName = "uff2";

      ospf.defaultRoute = {
        metricType = 1;
        metric = 510;
      };
    };

    services.keepalived.vrrpInstances = {
      wifi.priority = 120;
      lan1.priority = 120;
      lan2.priority = 120;
    };
  };
}
