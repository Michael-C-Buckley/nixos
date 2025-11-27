{config, ...}: let
  inherit (config.flake.hosts.uff2.interfaces) lo eno1 enusb1;
in {
  flake.modules.nixos.uff2 = {
    custom.enusb1.mac = "6c:1f:f7:06:27:ae";
    networking = {
      interfaces = {
        enusb1.ipv4.addresses = [
          {
            address = enusb1.ipv4;
            prefixLength = 28;
          }
        ];
        eno1.ipv4.addresses = [
          {
            address = eno1.ipv4;
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

      loopback.ipv4 = lo.ipv4;
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
