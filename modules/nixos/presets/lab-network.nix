# Networking specific to my home lab
# Include heavy opinionation for the servers present in the complex
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

    labHosts = ["uff1" "uff2" "uff3" "b550" "p520" "x570"];

    # Exclude the current host from the neighbors
    neighbors = lib.strings.concatMapStringsSep "\n" (
      hostname: " neighbor ${flake.hosts.${hostname}.interfaces.lo.ipv4} peer-group fabric"
    ) (lib.filter (h: h != config.networking.hostName) labHosts);

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

      frr.config = ''
        ip prefix-list MT3 seq 5 permit 192.168.48.0/20
        ip prefix-list MT3 seq 10 permit 192.168.64.0/20
        ip prefix-list 65102-OUT seq 5 permit 192.168.48.0/20
        ip prefix-list 65102-OUT seq 10 deny 0.0.0.0/0
        ip prefix-list 65102-IN seq 5 permit 192.168.64.0/20
        ip prefix-list 65102-IN seq 10 deny 0.0.0.0/0
        !
        ip forwarding
        ipv6 forwarding
        !
        router bgp 65101
          bgp router-id ${interfaces.lo.ipv4}
          no bgp default ipv4-unicast

          neighbor fabric peer-group
          neighbor fabric update-source ${interfaces.lo.ipv4}
          neighbor fabric remote-as 65101
          ${neighbors}
          neighbor 192.168.49.1 remote-as 65101
          neighbor 192.168.49.1 bfd

          address-family l2vpn evpn
            neighbor fabric activate
            advertise-all-vni
          exit-address-family

          address-family ipv4 unicast
            neighbor 192.168.49.1 prefix-list MT3 in
            neighbor 192.168.49.1 activate
          exit-address-family
      '';
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
          name = "10-${interface}";
          value = {
            matchConfig.Name = fixedName;
            networkConfig.Address = ["${interfaces.${interface}.ipv4}/${cidr}"];
            vlan = builtins.filter (lib.hasPrefix interface) vlanList;
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
