_: {
  system.boot.uuid = "DF19-0E9F";

  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.21/24"];
    enx520p1 = {
      mac = "";
      addresses.ipv4 = [];
    };
    enx520p2 = {
      mac = "";
      addresses.ipv4 = [];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.5";
    hostName = "sff1";
    hostId = "fb020cc1";
  };
}
