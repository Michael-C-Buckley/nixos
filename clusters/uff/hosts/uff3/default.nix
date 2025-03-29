{...}: let
  ipAddress = "192.168.48.103";
in {
  imports = [
    ./hardware.nix
  ];

  custom.uff = {
    loopbackIPv4 = "192.168.61.3";
    bridgeIPv4 = ipAddress;
    enusb1 = {
      macAddr = "6c:1f:f7:06:13:8f";
      ipv4.addr = "192.168.254.3";
    };
  };

  networking = {
    hostName = "uff3";
    hostId = "f303a8e8";
  };
}
