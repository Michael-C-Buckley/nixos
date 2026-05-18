{
  flake.modules.nixos.o1 = {
    services.frr = {
      config = ''
        ip prefix-list ALL-LAN seq 10 permit 192.168.0.0/16 ge 16

        router bgp 64851
          neighbor 192.168.254.80 remote-as 64514
          no bgp default ipv4-unicast

          address-family ipv4 unicast
            neighbor 192.168.254.80 activate
            neighbor 192.168.254.80 prefix-list ALL-LAN in
            neighbor 192.168.254.80 prefix-list ALL-LAN out
          exit-address-family
      '';
    };
  };
}
