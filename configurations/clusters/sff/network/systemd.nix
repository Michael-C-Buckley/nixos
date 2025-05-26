{config, ...}: {
  systemd.network = {
    links."10-enx520p1" = {
      matchConfig.MACAddress = config.networking.hardware.enx520p1.mac;
      linkConfig = {
        Name = "enx520p1";
        MTUBytes = 1500; # 1500 until I tweak the switch to support
      };
    };
    links."11-enx520p2" = {
      matchConfig.MACAddress = config.networking.hardware.enx520p2.mac;
      linkConfig = {
        Name = "enx520p2";
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
