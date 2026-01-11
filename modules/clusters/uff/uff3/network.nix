{
  flake.modules.nixos.uff3 = {
    networking = {
      networkmanager.ensureProfiles.profiles = {
        home = {
          ipv4.address = "172.16.166.33/16";
          ipv6.address = "fe80::1003/64";
        };
        home2 = {
          ipv4.address = "172.30.166.33/16";
          ipv6.address = "fe80::1003/64";
        };
      };

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
      lan = {
        priority = 130;
        state = "MASTER";
      };
    };
  };
}
