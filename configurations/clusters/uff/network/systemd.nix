{config, ...}: let
  netd = config.networkd;
in {
  systemd.network = {
    networks = {
      "20-eno1" = {
        matchConfig.Name = "eno1";
        address = netd.eno1.addresses.ipv4;
      };
      "21-enusb1" = {
        matchConfig.Name = "enusb1";
        address = netd.enusb1.addresses.ipv4;
      };
      # 40 is the default system generated one, this overwrites it
      "40-lo" = {
        matchConfig.Name = "lo";
        address = ["192.168.61.0/32" "${config.networking.loopback.ipv4}/32"];
      };
    };
    links = {
      "10-enusb1" = {
        matchConfig.MACAddress = netd.enusb1.mac;
        linkConfig = {
          Name = "enusb1";
          MTUBytes = 1500; # 1500 until I tweak the switch to support
        };
      };
    };
  };
}
