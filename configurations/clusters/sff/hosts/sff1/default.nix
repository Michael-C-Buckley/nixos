{...}: let
  ethIP = "192.168.48.21";

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  system.boot.uuid = "DF19-0E9F";

  networking = {
    hostName = "sff1";
    hostId = "fb020cc1";
    interfaces.eno1.ipv4.addresses = [(addr ethIP 24)];
  };
}
