_: {
  system.boot.uuid = "FC43-B84D";

  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.23/24"];
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
    loopback.ipv4 = "192.168.61.7";
    hostName = "sff3";
    hostId = "fb020cc3";
  };
}
