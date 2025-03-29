{...}: let
  ipAddress = "192.168.48.101";
in {
  imports = [
    ./hardware.nix
  ];

  custom.uff = {
    loopbackIPv4 = "192.168.61.1";
    bridgeIPv4 = ipAddress;
    enusb1 = {
      macAddr = "6c:1f:f7:06:27:8e";
      ipv4.addr = "192.168.254.1";
    };
  };

  networking = {
    hostName = "uff1";
    hostId = "ab0406ca";
  };
}
