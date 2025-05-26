{...}: let
  ethIP = "192.168.48.22";

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  networking = {
    hostName = "sff2";
    hostId = "fb020cc2";
    interfaces.eno1.ipv4.addresses = [(addr ethIP 24)];
  };

  # Logrotate randomly breaking?
  # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501
  services.logrotate.checkConfig = false;
}
