_: {
  networkd = {
    enusb1 = {
      mac = "6c:1f:f7:06:27:8e";
      addresses.ipv4 = ["192.168.254.1/27"];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.1";
    hostId = "ab0406ca";

    ospf.defaultRoute = {
      metricType = 1;
      metric = 520;
    };
  };

  system = {
    boot.uuid = "6B03-5772";
    impermanence.zrootPath = "zroot/uff1";
  };
}
