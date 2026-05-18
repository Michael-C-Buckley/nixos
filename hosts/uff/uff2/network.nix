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

    services = {
      keepalived.vrrpInstances = {
        wifi.priority = 120;
        lan.priority = 120;
      };

      udev.extraRules = ''
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="6c:4b:90:04:7b:b4", NAME="eno1"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="6c:1f:f7:06:27:ae", NAME="enu2"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="28:16:ad:44:8a:86", NAME="wlan1"
      '';
    };
  };
}
