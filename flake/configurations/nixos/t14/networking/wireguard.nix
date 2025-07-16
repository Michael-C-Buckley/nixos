{
  config,
  pkgs,
  self,
  lib,
  ...
}: let
  inherit (self.lib.wireguard) genInterface;
  inherit (lib) mapAttrs' nameValuePair;

  interfaces = {
    mt1 = ["192.168.78.2/27"];
    mt1v6 = ["192.168.78.34/27"];
    mt3 = ["192.168.62.2/27"];
    mt4 = ["192.168.202.12/27"];
    o1 = ["192.168.32.131/27"];
  };

  mkInterface = {
    name,
    ipAddresses,
  }:
    genInterface {
      inherit config pkgs name ipAddresses;
    };
in {
  systemd.services = mapAttrs' (a: ipAddresses: let
    name = "wireguard-${a}";
  in
    nameValuePair name (mkInterface {inherit name ipAddresses;}))
  interfaces;
}
