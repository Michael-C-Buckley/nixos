{config, pkgs, lib, inputs, ... }: let 
  wireguardInterface = inputs.nixos-modules.nixosModules.wireguard-interface {inherit config pkgs lib;};
in {
  systemd.services = {
    "wireguard-cary4" = wireguardInterface {
      name = "cary4";
      ipAddresses = ["192.168.78.2/27"];
    };
    "wireguard-creekstoneM4" = wireguardInterface  {
      name = "creekstoneM4";
      ipAddresses = ["192.168.62.2/27"];
    };
    "wireguard-o1" = wireguardInterface {
      name = "o1";
      ipAddresses = ["192.168.32.131/27"];
    };
  };
}