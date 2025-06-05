_: {
  networkd = {
    enx520p1 = {
      mac = "90:e2:ba:60:01:b8";
      addresses.ipv4 = ["192.168.254.3/27"];
    };
    enx520p2 = {
      mac = "90:e2:ba:60:01:b9";
      addresses.ipv4 = [];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.7";
    hostId = "fb020cc3";
  };

  system = {
    boot.uuid = "FC43-B84D";
    impermanence.zrootPath = "zroot/sff3";
  };
}
