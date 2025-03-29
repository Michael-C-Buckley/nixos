# UFF2 has the endpoints while HA is getting built-out
{config, inputs, pkgs, lib, ...}: let 
  wireguardInterface = inputs.nixos-modules.nixosModules.wireguard-interface {inherit config pkgs lib;};
in {
  systemd.services = {
    "wireguard-mt1" = wireguardInterface {
      name = "wg-mt1";
      cfgPath = "/etc/wireguard/mt1.conf";
      ipAddresses = ["192.168.254.97/31" "fe80::a227/64"];
    };
    "wireguard-clients" = wireguardInterface {
      name = "wg-clients";
      cfgPath = "/etc/wireguard/clients.conf";
      ipAddresses = ["192.168.62.33/27" "fe80::a227/64"];
    };
  };
}