{config, ...}: {
  systemd.network = {
    links."10-enusb1" = {
      matchConfig.MACAddress = config.custom.uff.enusb1.macAddr;
      linkConfig = {
        Name = "enusb1";
        MTUBytes = 9000;
      };
    };

    networks = {
      br0.bridgeConfig = {
        type = "bridge";
        name = "br0";
      };
    };
  };
}
