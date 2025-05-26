{...}: let
  ipAddress = "192.168.48.101";
in {
  system.boot.uuid = "AB50-96FA";

  custom.uff = {
    ethIPv4 = ipAddress;
    enusb1 = {
      ipv4.addr = "192.168.254.1";
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.1";
    hardware.enusb1.mac = "6c:1f:f7:06:27:8e";
    hostName = "uff1";
    hostId = "ab0406ca";
  };
}
