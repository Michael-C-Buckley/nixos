{lib, ...}: {
  flake.modules.nixos.t14 = {
    config,
    functions,
    ...
  }: let
    inherit (lib) mapAttrs' nameValuePair;
    mkWgInterface = functions.wireguard.genInterface;

    interfaces = {
      mt1 = ["192.168.78.2/27"];
      mt3 = ["192.168.62.2/27"];
      mt4 = ["192.168.202.12/27"];
      o1 = ["192.168.32.131/27"];
    };
  in {
    systemd.services = mapAttrs' (name: ipAddresses:
      nameValuePair "wireguard-${name}" (mkWgInterface {inherit config name ipAddresses;}))
    interfaces;
  };
}
