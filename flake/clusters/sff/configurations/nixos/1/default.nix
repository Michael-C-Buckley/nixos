# 1 has been temporarily moved to a separate location
_: {
  networkd = {
    enx520p1 = {
      mac = "90:e2:ba:5f:f3:68";
      addresses.ipv4 = ["192.168.254.1/27"];
    };
    enx520p2 = {
      mac = "90:e2:ba:5f:f3:69";
      addresses.ipv4 = [];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.5";
    hostId = "fb020cc1";
  };

  system = {
    boot.uuid = "DF19-0E9F";
  };
}
