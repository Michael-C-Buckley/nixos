{
  config,
  lib,
  functions,
  ...
}: let
  inherit (lib) mapAttrs' nameValuePair;

  interfaces = {
    mt1 = ["192.168.78.2/27"];
    mt3 = ["192.168.62.2/27"];
    mt4 = ["192.168.202.12/27"];
    o1 = ["192.168.32.131/27"];
  };
in {
  systemd.services = mapAttrs' (name: ipAddresses:
    nameValuePair "wireguard-${name}" (functions.wireguard {inherit config name ipAddresses;}))
  interfaces;
}
