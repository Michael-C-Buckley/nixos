{
  flake.modules.nixos.t14 = {
    services.frr.config = ''
      ip forward
      ip route 192.168.38.0/24 Null0 250

      ip prefix-list BGP-IN seq 10 permit 192.168.48.0/20
      ip prefix-list BGP-IN seq 20 permit 192.168.64.0/20
      ip prefix-list BGP-IN seq 30 permit 192.168.18.0/24
      ip prefix-list BGP-IN seq 100 deny 0.0.0.0/0

      ip prefix-list BGP-OUT seq 10 permit 192.168.238.0/24
      ip prefix-list BGP-OUT seq 100 deny 0.0.0.0/0

      router ospf
       ospf router-id 192.168.38.1
       network 172.16.213.2/32 area 0
       network 192.168.244.14/32 area 0

      int lo
       ip ospf passive

      router bgp 64700
          bgp router-id 192.168.38.1
          neighbor 192.168.78.1 remote-as 64800
          neighbor 192.168.78.33 remote-as 64800
          neighbor 192.168.62.1 remote-as 64512

          address-family ipv4 unicast
            network 192.168.38.0/24
            neighbor 192.168.78.1 prefix-list BGP-IN in
            neighbor 192.168.78.1 prefix-list BGP-OUT out
            neighbor 192.168.78.33 prefix-list BGP-IN in
            neighbor 192.168.78.33 prefix-list BGP-OUT out
            neighbor 192.168.62.1 prefix-list BGP-IN in
            neighbor 192.168.62.1 prefix-list BGP-OUT out
          exit-address-family
    '';
  };
}
