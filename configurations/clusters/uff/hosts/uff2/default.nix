{...}: let
  ipAddress = "192.168.48.102";
in {
  imports = [
    ./wireguard.nix
  ];

  system.boot.uuid = "E8D1-BB86";

  custom.uff = {
    ethIPv4 = ipAddress;
    enusb1 = {
      ipv4.addr = "192.168.254.2";
    };
  };

  networking = {
    loopback.ipv4 = "192.168.61.2";
    hardware.enusb1.mac = "6c:1f:f7:06:27:ae";
    hostName = "uff2";
    hostId = "072294f5";
  };
}
