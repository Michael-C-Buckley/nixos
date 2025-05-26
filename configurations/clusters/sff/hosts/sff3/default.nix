{...}: let
  ethIP = "192.168.48.23";

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  system.boot.uuid = "FC43-B84D";

  networking = {
    hostName = "sff3";
    hostId = "fb020cc3";
    interfaces.eno1.ipv4.addresses = [(addr ethIP 24)];
  };
}
