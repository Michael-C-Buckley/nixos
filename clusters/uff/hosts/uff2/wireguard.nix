# UFF2 has the endpoints while HA is getting built-out
{
  config,
  customLib,
  ...
}: {
  systemd.services = {
    "wireguard-mt1" = customLib.wireguardInterface {
      inherit config;
      name = "wg-mt1";
      cfgPath = "/etc/wireguard/mt1.conf";
      ipAddresses = ["192.168.254.97/31" "fe80::a227/64"];
    };
    "wireguard-clients" = customLib.wireguardInterface {
      inherit config;
      name = "wg-clients";
      cfgPath = "/etc/wireguard/clients.conf";
      ipAddresses = ["192.168.62.33/27" "fe80::a227/64"];
    };
  };
}
