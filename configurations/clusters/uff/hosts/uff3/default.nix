{...}: let
  ipAddress = "192.168.48.103";
in {
  system.boot.uuid = "802A-C2C6";

  custom.uff = {
    ethIPv4 = ipAddress;
    enusb1 = {
      ipv4.addr = "192.168.254.3";
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.3";
    hardware.enusb1.mac = "6c:1f:f7:06:13:8f";
    hostName = "uff3";
    hostId = "f303a8e8";
  };
}
