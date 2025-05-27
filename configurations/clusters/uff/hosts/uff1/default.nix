_: {
  system.boot.uuid = "6B03-5772";

  networkd = {
    eno1.addresses.ipv4 = ["192.168.48.101/24"];
    enusb1 = {
      mac = "6c:1f:f7:06:27:8e";
      addresses.ipv4 = ["192.168.254.1/27"];
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.1";
    hostName = "uff1";
    hostId = "ab0406ca";
  };
}
