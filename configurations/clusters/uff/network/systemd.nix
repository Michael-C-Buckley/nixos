{config, ...}: {
  systemd.network = {
    links.enusb1 = {
      matchConfig.MACAddress = config.networking.hardware.enusb1.mac;
      linkConfig = {
        Name = "enusb1";
        MTUBytes = 1500; # 1500 until I tweak the switch to support
      };
    };
  };
}
