{config, ...}: let
  netd = config.networkd;
in {
  systemd.network = {
    networks = {
      "11-enusb1" = {
        matchConfig.Name = "enusb1";
        address = netd.enusb1.addresses.ipv4;
        DHCP = "no";
      };
      # 40 is the default system generated one, this overwrites it
      "40-lo" = {
        matchConfig.Name = "lo";
        address = ["192.168.61.0/32" "${config.networking.loopback.ipv4}/32"];
      };
    };
    links = {
      "12-enusb1" = {
        matchConfig.MACAddress = netd.enusb1.mac;
        linkConfig = {
          Name = "enusb1";
          MTUBytes = 1500; # 1500 until I tweak the switch to support
        };
      };
    };
  };
}
