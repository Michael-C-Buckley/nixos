{config, ...}: let
  inherit (config.networkd) enmlx1 enmlx2;
in {
  systemd.network = {
    networks = {
      "20-enmlx1" = {
        matchConfig.Name = "enmlx1";
        address = enmlx2.addresses.ipv4;
      };
      "21-enmlx2" = {
        matchConfig.Name = "enmlx2";
        address = enmlx2.addresses.ipv4;
      };
      # 40 is the default system generated one, this overwrites it
      "40-lo" = {
        matchConfig.Name = "lo";
        address = ["192.168.78.130/32" "${config.networking.loopback.ipv4}/32"];
      };
    };
    links = {
      "11-enmlx1" = {
        matchConfig.MACAddress = enmlx1.mac;
        linkConfig = {
          Name = "enmlx1";
          MTUBytes = 9000;
        };
      };
      "12-enmlx2" = {
        matchConfig.MACAddress = enmlx2.mac;
        linkConfig = {
          Name = "enmlx2";
          MTUBytes = 9000;
        };
      };
    };
  };
}
