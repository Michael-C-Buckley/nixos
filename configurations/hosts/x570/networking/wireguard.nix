{
  config,
  customLib,
  ...
}: {
  systemd.services = {
    "wireguard-mt1" = customLib.wireguardInterface {
      inherit config;
      name = "mt1";
      ipAddresses = ["192.168.240.242/30"];
    };
  };
}
