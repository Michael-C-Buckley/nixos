{
  flake.nixosConfigurations.x570.wireguard = {
    config,
    pkgs,
    lib,
    customLib,
    ...
  }: let
    # Pkgs Lib is overlaid and different than stock lib
    inherit (customLib.wireguard) genInterface;
    inherit (lib) mapAttrs' nameValuePair;

    interfaces = {
      mt1 = ["192.168.240.242/30"];
      mt4 = ["192.168.202.10/24"];
    };

    mkInterface = {
      name,
      ipAddresses,
    }:
      genInterface {
        inherit config pkgs name ipAddresses;
      };
  in {
    systemd.services = mapAttrs' (name: ipAddresses:
      nameValuePair "wireguard-${name}" (mkInterface {inherit name ipAddresses;}))
    interfaces;
  };
}
