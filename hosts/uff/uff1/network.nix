{
  flake.modules.nixos.uff1 = {
    networking = {
      networkmanager.ensureProfiles.profiles = {
        home = {
          ipv4.address = "172.16.166.31/16";
          ipv6.address = "fe80::1001/64";
        };
        home2 = {
          ipv4.address = "172.30.166.31/16";
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

    services = {
      keepalived.vrrpInstances = {
        wifi.priority = 110;
        lan.priority = 110;
      };

      udev.extraRules = ''
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="6c:4b:90:04:7d:b4", NAME="eno1"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="6c:1f:f7:06:27:8e", NAME="enu2"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="28:16:ad:43:f2:24", NAME="wlan1"
      '';
    };
  };
}
