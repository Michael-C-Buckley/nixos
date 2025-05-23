{
  config,
  customLib,
  ...
}: {
  systemd.services = {
    "wireguard-clients" = customLib.wireguardInterface {
      inherit config;
      name = "clients";
      ipAddresses = ["192.168.32.129/27" "fe80::32:129/64"];
    };
    "wireguard-mt1" = customLib.wireguardInterface {
      inherit config;
      name = "mt1";
      ipAddresses = ["192.168.254.81/31" "fe80::254:81/64"];
    };
  };
}
