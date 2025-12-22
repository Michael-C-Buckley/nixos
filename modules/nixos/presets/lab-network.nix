# Networking specific to my home lab
# Include heavily opinionation for the servers present in the complex
# networking environment
{config, ...}: let
  inherit (config) flake;
  inherit
    (config.flake.lib.network)
    fixVlanName
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

    vlanList = getVlanList interfaces;

    # Remove wifi interfaces
    networkdInterfaces = builtins.filter (name: builtins.match "wl.*" name == null) (builtins.attrNames interfaces);
  in {
    imports = with flake.modules.nixos; [
      bfd
      bgp
      ospf
    ];

    services = {
      iperf3 = {
        enable = true;
        openFirewall = true;
      };
    };

    systemd.network = {
      netdevs = builtins.listToAttrs (map mkVlanNetdev vlanList);

      networks = builtins.listToAttrs (
        map
        (interface: let
          fixedName = fixVlanName interface;
          # The current network has fixed logic on what the masks will be
          cidr =
            if interface == "eno1"
            then "24"
            else if lib.hasInfix "-" interface
            then "27"
            else "28";
        in {
          name = "10-${fixedName}.network";
          value = {
            matchConfig.name = fixedName;
            networkConfig.Address = ["${interfaces.${interface}.ipv4}/${cidr}"];
          };
        })
        networkdInterfaces
      );
    };
    networking = {
      # Wired interfaces will be on systemd-networkd
      useNetworkd = true;
      # I use networkmanager for wifi
      networkmanager = {
        enable = lib.mkDefault true;
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
