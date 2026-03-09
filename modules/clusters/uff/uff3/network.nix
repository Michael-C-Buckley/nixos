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

    services = {
      keepalived.vrrpInstances = {
        wifi = {
          priority = 130;
          state = "MASTER";
        };
        lan = {
          priority = 130;
          state = "MASTER";
        };
      };
      udev.extraRules = ''
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="6c:4b:90:04:7d:23", NAME="eno1"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="6c:1f:f7:06:13:8f", NAME="enu2"
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="28:16:ad:4d:c8:c1", NAME="wlan1"
      '';
    };
  };
}
