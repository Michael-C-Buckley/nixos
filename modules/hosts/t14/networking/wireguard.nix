{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.t14 = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (lib) mapAttrs' nameValuePair;
    mkWgInterface = flake.lib.wireguard.genInterface;

    interfaces = {
      mt1 = ["192.168.78.2/27"];
      mt1v6 = ["192.168.78.34/27"];
      mt3 = ["192.168.62.2/27"];
      mt4 = ["192.168.202.12/27"];
      o1 = ["192.168.32.131/27"];
    };
  in {
    systemd.services = mapAttrs' (name: ipAddresses:
      nameValuePair "wireguard-${name}" (mkWgInterface {inherit config pkgs name ipAddresses;}))
    interfaces;
  };
}
