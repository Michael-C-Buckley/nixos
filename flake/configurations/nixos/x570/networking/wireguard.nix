{
  config,
  pkgs,
  self,
  ...
}: {
  systemd.services = {
    "wireguard-mt1" = self.lib.wireguard.genInterface {
      inherit config pkgs;
      name = "mt1";
      ipAddresses = ["192.168.240.242/30"];
    };
    "wireguard-mt4" = self.lib.wireguard.genInterface {
      inherit config pkgs;
      name = "mt4";
      ipAddresses = ["192.168.202.10/24"];
    };
  };
}
