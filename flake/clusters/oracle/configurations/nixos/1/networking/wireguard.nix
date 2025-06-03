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
      ipAddresses = ["192.168.32.129/27" "fe80::32:129/64"];
    };
    "wireguard-mt1" = self.lib.wireguard.genInterface {
      inherit config pkgs;
      name = "mt1";
      ipAddresses = ["192.168.254.81/31" "fe80::254:81/64"];
    };
  };
}
