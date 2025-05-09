{
  config,
  customLib,
  ...
}: {
  systemd.services = {
    "wireguard-mt1" = customLib.wireguardInterface {
      inherit config;
      name = "mt1";
      # Path because Agenix is currently not working on the desktop, this is the local file workaround
      cfgPath = "/etc/wireguard/wg-mt1.conf";
      ipAddresses = ["192.168.240.242/30"];
    };
  };
}
