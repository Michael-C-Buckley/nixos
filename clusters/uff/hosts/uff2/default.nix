{...}: let
  ipAddress = "192.168.48.102";
in {
  imports = [
    ./hardware.nix
    ./wireguard.nix
  ];

  custom.uff = {
    loopbackIPv4 = "192.168.61.2";
    bridgeIPv4 = ipAddress;
    enusb1 = {
      macAddr = "6c:1f:f7:06:27:ae";
      ipv4.addr = "192.168.254.2";
    };
  };

  networking = {
    hostName = "uff2";
    hostId = "072294f5";
  };
}
