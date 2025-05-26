{config, ...}: let
  ethIP = config.custom.uff.ethIPv4;
  enusb1 = config.custom.uff.enusb1;

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  # WIP: Wifi connection after adding age-encryption
  # environment.etc."NetworkManager/system-connections/wifi.nmconnection".source = "";

  networking = {
    interfaces = {
      # WIP: Transitioning from bridge back to base interfaces, options not yet changed
      eno1.useDHCP = false;
      eno1.ipv4.addresses = [(addr ethIP 24)];

      # Wifi gets DHCP
      wlp2s0.useDHCP = true;

      # L3 reachable loopback for anycast
      lo.ipv4.addresses = [
        (addr "192.168.61.0" 32)
      ];

      # This is the 2.5G USB NIC
      enusb1.ipv4.addresses = [(addr enusb1.ipv4.addr enusb1.ipv4.prefixLength)];
    };
  };
}
