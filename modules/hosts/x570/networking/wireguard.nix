{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.x570 = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (flake.lib.wireguard) genInterface;
    inherit (lib) mapAttrs' nameValuePair;

    interfaces = {
      mt1 = ["192.168.240.242/30"];
      mt4 = ["192.168.202.10/24"];
    };
  in {
    systemd.services = mapAttrs' (name: ipAddresses:
      nameValuePair "wireguard-${name}" (genInterface {inherit config pkgs name ipAddresses;}))
    interfaces;
  };
}
