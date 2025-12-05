{config, ...}: let
  inherit (config.flake) hosts;
in {
  flake.modules.nixos.uff = {
    config,
    lib,
    ...
  }: let
    inherit (lib.strings) concatMapStringsSep;
    inherit (hosts.${config.networking.hostName}.interfaces) lo;

    uffHosts = ["uff1" "uff2" "uff3"];

    # Exclude the current host from the neighbors
    neighbors = concatMapStringsSep "\n" (
      hostname: "neighbor ${hosts.${hostname}.interfaces.lo.ipv4} peer-group fabric"
    ) (lib.filter (h: h != config.networking.hostName) uffHosts);

    # Exclude current host from BFD peers
    bfdPeers = let
      uffInterfaces =
        lib.concatMap (
          hostname:
            if hostname == config.networking.hostName
            then []
            else [
              hosts.${hostname}.interfaces.eno1.ipv4
              hosts.${hostname}.interfaces.enusb1.ipv4
            ]
        )
        uffHosts;
      otherPeers = [
        # Other Hosts
        hosts.x570.interfaces.enp6s0.ipv4
        hosts.x570.interfaces.enp7s0.ipv4
        "192.168.49.2" # Cisco
      ];
    in
      concatMapStringsSep "\n" (n: "peer ${n}") (uffInterfaces ++ otherPeers);
  in {
    services.frr.config = ''
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
      router ospf
       router-id ${lo.ipv4}
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf bfd
       ip ospf area 0
       ip ospf cost 400
      int br100
       ip ospf passive
       ip ospf area 0
      int enusb1
       ip ospf bfd
       ip ospf area 0
       ip ospf cost 1000
      !
      router bgp 65101
       bgp router-id ${lo.ipv4}
       no bgp default ipv4-unicast

       neighbor fabric peer-group
       neighbor fabric update-source ${lo.ipv4}
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
      exit
      !
      bfd
       ${bfdPeers}
       peer 192.168.49.1
        transmit-interval 1000
        receive-interval 2000
    '';
  };
}
