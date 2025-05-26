{config, ...}: let
  lo = config.networking.loopback.ipv4;
in {
  networking = {
    bgp.enable = true;
    ospf.enable = true;
  };

  services.frr = {
    bfdd.enable = true;
    bgpd.enable = true;
    ospf6d.enable = true;
    vrrpd.enable = true;

    config = ''
      ip forwarding
      ipv6 forwarding
      router ospf
       router-id ${lo}
       default-information originate metric 600 metric-type 1
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf area 0
       ip ospf cost 400
       uo
      int enusb1
       ip ospf area 0
       ip ospf cost 100

      router bgp 65101
       bgp router-id ${lo}
       no bgp default ipv4-unicast

       neighbor fabric peer-group
       neighbor fabric remote-as 65101
       neighbor 192.168.61.1 peer-group fabric
       neighbor 192.168.61.2 peer-group fabric
       neighbor 192.168.61.3 peer-group fabric

       address-family l2vpn evpn
        neighbor fabric activate
        advertise-all-vni
      exit-address-family
    '';
  };
}
