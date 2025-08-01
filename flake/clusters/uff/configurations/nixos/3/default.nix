_: {
  imports = [./filesystems.nix];
  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.33/24"];
    enusb1 = {
      mac = "6c:1f:f7:06:13:8f";
      addresses.ipv4 = ["192.168.254.3/27"];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.3";
    hostId = "f303a8e8";

    ospf.defaultRoute = {
      metricType = 1;
      metric = 500;
    };
  };

  services.keepalived.vrrpInstances.wan = {
    priority = 130;
    state = "MASTER";
  };

  system = {
    boot.uuid = "1555-62FA";
  };
}
