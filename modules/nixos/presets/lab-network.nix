# Networking specific to my home lab
# Include heavy opinionation for the servers present in the complex
# networking environment
{config, ...}: let
  inherit (config) flake;
  inherit
    (config.flake.lib.network)
    getAddress
    ;
in {
  flake.modules.nixos.lab-network = {
    config,
    lib,
    ...
  }: let
    inherit (builtins) attrNames filter listToAttrs;
    inherit (config.networking) hostName;
    inherit (flake.hosts.${hostName}) interfaces;

    lo = getAddress interfaces.lo.ipv4;

    labHosts = ["uff1" "uff2" "uff3" "b550" "p520" "x570"];

    # Exclude the current host from the neighbors
    neighbors = lib.strings.concatMapStringsSep "\n" (
      hostname: " neighbor ${getAddress flake.hosts.${hostname}.interfaces.lo.ipv4} peer-group fabric"
    ) (lib.filter (h: h != config.networking.hostName) labHosts);

    # Remove wifi interfaces
    networkdInterfaces = filter (name: !(lib.hasPrefix "wl" name)) (attrNames interfaces);

    physicalInterfaces = lib.unique (
      filter (lib.hasPrefix "en") (attrNames interfaces)
    );
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
        ip prefix-list BLOCK-DEFAULT seq 10 permit 0.0.0.0/0 ge 1 le 32
        !
        ip forwarding
        ipv6 forwarding
        !
        router bgp 65101
          bgp router-id ${lo}
          no bgp default ipv4-unicast

          neighbor fabric peer-group
          neighbor fabric update-source ${lo}
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
      # All statically set
      wait-online.anyInterface = true;

      networks =
        listToAttrs
        (map (interface: {
            name = "20-${interface}";
            value = {
              matchConfig.Name = interface;
              networkConfig.Address = ["${interfaces.${interface}.ipv4}"];
            };
          })
          physicalInterfaces);
    };

    networking = {
      # Wired interfaces will be on systemd-networkd
      useNetworkd = true;
      # I use networkmanager for wifi
      networkmanager = {
        enable = lib.mkDefault true;
        # `wl` will match against both my custom and linux default device naming for wifi
        unmanaged = networkdInterfaces ++ physicalInterfaces;
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
