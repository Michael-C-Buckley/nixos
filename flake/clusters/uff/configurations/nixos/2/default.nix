_: {
  networkd = {
    enusb1 = {
      mac = "6c:1f:f7:06:27:ae";
      addresses.ipv4 = ["192.168.254.2/27"];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.2";
    hostId = "072294f5";

    ospf.defaultRoute = {
      metricType = 1;
      metric = 510;
    };
  };

  system = {
    boot.uuid = "E8D1-BB86";
    impermanence.zrootPath = "zroot/uff2";
  };
}
