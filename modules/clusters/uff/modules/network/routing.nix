{
  flake.modules.uff.networking = {
    config,
    lib,
    ...
  }: let
    inherit (builtins) head;
    inherit (lib) filter mkDefault hasPrefix;
    inherit (lib.strings) concatMapStringsSep;
    lo = config.networking.loopback.ipv4;
    eno1 = config.networkd.eno1.addresses.ipv4;
    enusb1 = config.networkd.enusb1.addresses.ipv4;

    # Exclude the current host from the neighbors
    neighbors =
      concatMapStringsSep "\n" (
        n: "neighbor ${n} peer-group fabric"
      ) (filter (n: n != lo) [
        # UFFs
        "192.168.61.1"
        "192.168.61.2"
        "192.168.61.3"
      ]);

    # exclude current host from BFD peers
    bfdPeers =
      concatMapStringsSep "\n" (
        n: "peer ${n}"
      ) (filter (
          n:
            !(hasPrefix n (head eno1)) && !(hasPrefix n (head enusb1))
        ) [
          # UFF interfaces
          "192.168.48.31"
          "192.168.48.32"
          "192.168.48.33"
          "192.168.254.1"
          "192.168.254.2"
          "192.168.254.3"

          # Other Hosts
          "192.168.48.2"
          "192.168.48.10" # X570
        ]);
  in {
    networking = {
      bgp.enable = true;
      ospf.enable = true;

      firewall.allowedUDPPorts = [3784 3785 4784];
    };

    services = {
      keepalived.vrrpInstances.wan = {
        state = mkDefault "BACKUP";
        interface = "eno1";
        virtualRouterId = 1;
        virtualIps = [{addr = "192.168.48.30/24";}];
      };
      frr = {
        bfdd.enable = true;
        bgpd.enable = true;
        ospf6d.enable = true;

        config = ''
          ip prefix-list MT3 seq 5 permit 192.168.48.0/20
          ip prefix-list MT3 seq 10 permit 192.168.64.0/20
          ip prefix-list 65102-OUT seq 5 permit 192.168.48.0/20
          ip prefix-list 65102-OUT seq 10 deny 0.0.0.0/0
          ip prefix-list 65102-IN seq 5 permit 192.168.64.0/20
          !
          ip forwarding
          ipv6 forwarding
          !
          router ospf
           router-id ${lo}
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
           ip ospf cost 100
          !
          router bgp 65101
           bgp router-id ${lo}
           no bgp default ipv4-unicast

           neighbor fabric peer-group
           neighbor fabric update-source ${lo}
           neighbor fabric remote-as 65101
           ${neighbors}
           neighbor 192.168.48.1 remote-as 65101
           neighbor 192.168.48.1 bfd

           neighbor 192.168.52.11 remote-as 65102
           neighbor 192.168.52.11 update-source ${lo}
           neighbor 192.168.52.11 next-hop-self
           neighbor 192.168.52.11 ebgp-multihop 3
           neighbor 192.168.52.11 bfd

           address-family l2vpn evpn
            neighbor fabric activate
            advertise-all-vni
           exit-address-family

           address-family ipv4 unicast
            neighbor 192.168.48.1 prefix-list MT3 in
            neighbor 192.168.48.1 activate

            neighbor 192.168.52.11 prefix-list 65102-OUT out
            neighbor 192.168.52.11 prefix-list 65102-IN in
            neighbor 192.168.52.11 activate

           exit-address-family
          exit
          !
          bfd
           ${bfdPeers}
           peer 192.168.52.11 multihop local-address ${lo}
             transmit-interval 1000
             receive-interval 1000
             minimum-ttl 5
           peer 192.168.48.1
            transmit-interval 1000
            receive-interval 2000
        '';
      };
    };
  };
}
