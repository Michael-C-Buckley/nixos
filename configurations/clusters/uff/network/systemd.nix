{config, ...}: {
  systemd.network = {
    networks = {
      "20-eno1" = {
        matchConfig.Name = "eno1";
        address = ["${config.custom.uff.ethIPv4}/24"];
      };
      "21-enusb1" = {
        matchConfig.Name = "enusb1";
        address = ["${config.custom.uff.enusb1.ipv4.addr}/27"];
      };
      # 40 is the default system generated one, this overwrites it
      "40-lo" = {
        matchConfig.Name = "lo";
        address = ["192.168.61.0/32" "${config.networking.loopback.ipv4}/32"];
      };
    };
    links = {
      "10-enusb1" = {
        matchConfig.MACAddress = config.networking.hardware.enusb1.mac;
        linkConfig = {
          Name = "enusb1";
          MTUBytes = 1500; # 1500 until I tweak the switch to support
        };
      };
    };
  };
}
