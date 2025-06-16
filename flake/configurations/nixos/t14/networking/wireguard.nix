{
  config,
  pkgs,
  self,
  ...
}: let
  inherit (self.lib.wireguard) genInterface;
  mkInterface = {
    name,
    ipAddresses,
  }:
    genInterface {
      inherit config pkgs name ipAddresses;
    };
in {
  systemd.services = {
    "wireguard-mt1" = mkInterface {
      name = "mt1";
      ipAddresses = ["192.168.78.2/27"];
    };
    "wireguard-mt3" = mkInterface {
      name = "mt3";
      ipAddresses = ["192.168.62.2/27"];
    };
    "wireguard-mt4" = mkInterface {
      name = "mt4";
      ipAddresses = ["192.168.202.12/27"];
    };
    "wireguard-o1" = mkInterface {
      name = "o1";
      ipAddresses = ["192.168.32.131/27"];
    };
  };
}
