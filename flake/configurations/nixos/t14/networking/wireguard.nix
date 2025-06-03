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
      ipAddresses = ["192.168.78.2/27"];
    };
    "wireguard-mt3" = self.lib.wireguard.genInterface {
      inherit config pkgs;
      name = "mt3";
      ipAddresses = ["192.168.62.2/27"];
    };
    "wireguard-o1" = self.lib.wireguard.genInterface {
      inherit config pkgs;
      name = "o1";
      ipAddresses = ["192.168.32.131/27"];
    };
  };
}
