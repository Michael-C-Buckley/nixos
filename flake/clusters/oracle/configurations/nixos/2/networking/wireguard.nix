{
  config,
  pkgs,
  self,
  ...
}: {
  systemd.services = {
    "wireguard-clients" = self.lib.wireguard.genInterface {
      inherit config pkgs;
      name = "clients";
      # Local file until agenix is setup and configured
      cfgPath = "/etc/wireguard/wg-clients.conf";
      ipAddresses = ["192.168.33.129/27" "fe80::33:129/64"];
    };
  };
}
