{
  config,
  customLib,
  ...
}: {
  systemd.services = {
    "wireguard-cary4" = customLib.wireguardInterface {
      inherit config;
      name = "cary4";
      ipAddresses = ["192.168.78.2/27"];
    };
    "wireguard-creekstoneM4" = customLib.wireguardInterface {
      inherit config;
      name = "creekstoneM4";
      ipAddresses = ["192.168.62.2/27"];
    };
    "wireguard-o1" = customLib.wireguardInterface {
      inherit config;
      name = "o1";
      ipAddresses = ["192.168.32.131/27"];
    };
  };
}
