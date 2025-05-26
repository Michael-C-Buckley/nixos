{config, ...}: {
  systemd.network = {
    links."10-enusb1" = {
      matchConfig.MACAddress = config.networking.hardware.enusb1.mac;
      linkConfig = {
        Name = "enusb1";
        MTUBytes = 1500; # 1500 until I tweak the switch to support
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
