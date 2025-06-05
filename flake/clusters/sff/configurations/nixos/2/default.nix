_: {
  networkd = {
    enx520p1 = {
      mac = "90:e2:ba:44:86:68";
      addresses.ipv4 = ["192.168.254.2/27"];
    };
    enx520p2 = {
      mac = "90:e2:ba:44:86:69";
      addresses.ipv4 = [];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.6";
    hostId = "fb020cc2";
  };

  system = {
    boot.uuid = "3A1C-9DCC";
    impermanence.zrootPath = "zroot/sff2";
  };
}
