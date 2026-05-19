{
  config,
  lib,
  functions,
  ...
}: let
  inherit (lib) mapAttrs' nameValuePair;

  interfaces = {
    mt1 = ["192.168.240.242/30"];
    #mt4 = ["192.168.202.10/24"];
  };
in {
  systemd.services = mapAttrs' (name: ipAddresses:
    nameValuePair "wireguard-${name}" (functions.wireguard {inherit config name ipAddresses;}))
  interfaces;
}
