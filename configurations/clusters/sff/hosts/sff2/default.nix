_: {
  system.boot.uuid = "3A1C-9DCC";

  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.22/24"];
    enx520p1 = {
      mac = "90:e2:ba:44:86:68";
      addresses.ipv4 = [];
    };
    enx520p2 = {
      mac = "90:e2:ba:44:86:69";
      addresses.ipv4 = [];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.6";
    hostName = "sff2";
    hostId = "fb020cc2";
  };
}
