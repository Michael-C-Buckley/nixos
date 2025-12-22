{config, ...}: let
  inherit (config.flake.hosts.x570.interfaces) lo;
in {
  flake.modules.nixos.x570 = {
    services.frr.config = ''
      ip forwarding
      ipv6 forwarding

      ip prefix-list 64800-IN seq 5 permit 192.168.64.0/20
      ip prefix-list 64800-IN seq 10 deny 0.0.0.0/0
      ip prefix-list 64800-OUT seq 5 permit ${lo.ipv4}
      ip prefix-list 64800-OUT seq 10 deny 0.0.0.0/0

      router ospf
        router-id ${lo.ipv4}
        distribute-list BLOCK-DEFAULT eno1.4
        distribute-list BLOCK-DEFAULT eno2.6
        distribute-list BLOCK-DEFAULT enx3.8
        distribute-list BLOCK-DEFAULT enx4.8

      router bgp 65100
        no bgp ebgp-requires-policy
        neighbor 192.168.240.241 remote-as 64800

        address-family ipv4
          network ${lo.ipv4}/32
          neighbor 192.168.240.241 activate
        exit

      int lo
        ip ospf passive
        ip ospf area 0
      int eno1
        ip ospf cost 1000
        ip ospf area 0
      int eno2
        ip ospf cost 400
        ip ospf area 0
      int enx3
        ip ospf cost 100
        ip ospf area 0
      int eno1.3
       ip ospf cost 1010
       ip ospf area 0
      int eno1.4
       ip ospf cost 1000
       ip ospf area 0
      int eno2.5
       ip ospf cost 410
       ip ospf area 0
      int eno2.6
       ip ospf cost 400
       ip ospf area 0
      int enx3.7
       ip ospf cost 110
       ip ospf area 0
      int enx3.8
       ip ospf cost 100
       ip ospf area 0
      int enx4.7
       ip ospf cost 110
       ip ospf area 0
      int enx4.8
       ip ospf cost 100
       ip ospf area 0
    '';

    networking.ospf = {
      defaultRoute = {
        metricType = 1;
        metric = 550;
      };
    };
  };
}
