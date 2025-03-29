{config, ...}: let
  brIP = config.custom.uff.bridgeIPv4;
  enusb1 = config.custom.uff.enusb1;
  loopback = config.custom.uff.loopbackIPv4;

  addr = addr: prefix: {
    address = addr;
    prefixLength = prefix;
  };
in {
  # WIP: Wifi connection after adding age-encryption
  # environment.etc."NetworkManager/system-connections/wifi.nmconnection".source = "";

  networking = {
    # Add the first interface into a bridge and disable DHCP
    bridges.br0.interfaces = ["eno1"];
    interfaces = {
      # Bridge-related configs
      eno1.useDHCP = false;
      br0.ipv4.addresses = [(addr brIP 24)];

      # Wifi gets DHCP
      wlp2s0.useDHCP = true;

      # L3 reachable loopback addresses for host and anycast
      lo.ipv4.addresses = [
        (addr loopback 32)
        (addr "192.168.61.0" 32)
      ];

      # This is the 2.5G USB NIC
      enusb1.ipv4.addresses = [(addr enusb1.ipv4.addr enusb1.ipv4.prefixLength)];
    };
  };
}
