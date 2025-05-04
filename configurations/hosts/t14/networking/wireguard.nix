{
  config,
  customLib,
  ...
}: {
  systemd.services = {
    "wireguard-mt1" = customLib.wireguardInterface {
      inherit config;
      name = "mt1";
      ipAddresses = ["192.168.78.2/27"];
    };
    "wireguard-mt3" = customLib.wireguardInterface {
      inherit config;
      name = "mt3";
      ipAddresses = ["192.168.62.2/27"];
    };
    "wireguard-o1" = customLib.wireguardInterface {
      inherit config;
      name = "o1";
      ipAddresses = ["192.168.32.131/27"];
    };
  };
}
