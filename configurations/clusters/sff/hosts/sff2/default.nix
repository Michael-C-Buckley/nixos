{...}: let
  ethIP = "192.168.48.22";

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  system.boot.uuid = "3A1C-9DCC";

  networking = {
    loopback.ipv4 = "192.168.61.6";
    hostName = "sff2";
    hostId = "fb020cc2";
    interfaces.eno1.ipv4.addresses = [(addr ethIP 24)];
  };
}
