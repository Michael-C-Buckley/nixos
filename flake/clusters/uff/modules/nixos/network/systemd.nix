{config, ...}: let
  inherit (config.networkd) enusb1 eno1;
in {
  systemd.network = {
    networks = {
      "10-eno1" = {
        matchConfig.Name = "eno1";
        address = eno1.addresses.ipv4;
        DHCP = "no";
      };
      "11-enusb1" = {
        matchConfig.Name = "enusb1";
        address = enusb1.addresses.ipv4;
        DHCP = "no";
      };
      # 40 is the default system generated one, this overwrites it
      "40-lo" = {
        matchConfig.Name = "lo";
        address = ["192.168.61.0/32" "${config.networking.loopback.ipv4}/32"];
      };
    };
    links = {
      # MTU 1500 until I tweak the switches to support
      "11-eno1" = {
        matchConfig.Name = "eno1";
        linkConfig.MTUBytes = 1500;
      };
      "12-enusb1" = {
        matchConfig.MACAddress = enusb1.mac;
        linkConfig = {
          Name = "enusb1";
          MTUBytes = 1500;
        };
      };
    };
  };
}
