# Networking specific to my home lab
# Include heavily opinionation for the servers present in the complex
# networking environment
{config, ...}: let
  inherit (config) flake;
  inherit
    (config.flake.lib.network)
    getVlanList
    mkVlanNetdev
    ;
in {
  flake.modules.nixos.lab-network = {
    config,
    lib,
    ...
  }: let
    inherit (config.networking) hostName;
    inherit (flake.hosts.${hostName}) interfaces;
  in {
    imports = with flake.modules.nixos; [
      bgp
      ospf
    ];

    services = {
      iperf3.enable = true;
    };

    systemd.network = {
      netdevs = builtins.listToAttrs (
        map mkVlanNetdev (getVlanList interfaces)
      );
    };
    networking = {
      # Wired interfaces will be on systemd-networkd
      useNetworkd = true;
      # I use networkmanager for wifi
      networkmanager = {
        enable = true;
        # `wl` will match against both my custom and linux default device naming for wifi
        unmanaged = lib.filter (name: !(lib.hasPrefix "wl" name)) (builtins.attrNames interfaces);
      };

      # Virtual only bridge
      bridges.br0 = {
        interfaces = [];
      };

      firewall = {
        trustedInterfaces = ["br0"];
      };
    };
  };
}
