{config, ...}: let
  inherit (config.flake.lib.networking) getAddress;
  lo = getAddress config.flake.hosts.x570.interface.lo;
in {
  flake.modules.nixos.x570 = {
    services.frr.config = ''
      ip forwarding
      ipv6 forwarding

      ip prefix-list 64800-IN seq 5 permit 192.168.64.0/20
      ip prefix-list 64800-IN seq 10 deny 0.0.0.0/0
      ip prefix-list 64800-OUT seq 5 permit ${lo}
      ip prefix-list 64800-OUT seq 10 deny 0.0.0.0/0

      router ospf
       router-id ${lo}

      router bgp 65100
       no bgp ebgp-requires-policy
       neighbor 192.168.240.241 remote-as 64800

       address-family ipv4
         network ${lo}/32
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
      int enx4
       ip ospf cost 40
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
