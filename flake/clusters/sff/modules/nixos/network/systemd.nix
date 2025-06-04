{config, ...}: let
  inherit (config.networkd) enx520p1 enx520p2;
in {
  systemd.network = {
    networks = {
      "20-enx520p1" = {
        matchConfig.Name = "enx520p1";
        address = enx520p1.addresses.ipv4;
      };
      "21-enx520p2" = {
        matchConfig.Name = "enx520p2";
        address = enx520p1.addresses.ipv4;
      };
      # 40 is the default system generated one, this overwrites it
      "40-lo" = {
        matchConfig.Name = "lo";
        address = ["192.168.61.4/32" "${config.networking.loopback.ipv4}/32"];
      };
    };
    links = {
      "11-enx520p1" = {
        matchConfig.MACAddress = enx520p1.mac;
        linkConfig = {
          Name = "enx520p1";
          MTUBytes = 1500; # 1500 until I tweak the switch to support
        };
      };
      "12-enx520p2" = {
        matchConfig.MACAddress = enx520p2.mac;
        linkConfig = {
          Name = "enx520p2";
          MTUBytes = 1500; # 1500 until I tweak the switch to support
        };
      };
    };
  };
}
