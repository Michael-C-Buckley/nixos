{config, ...}: let
  inherit (config.flake.hosts.x570.interfaces) lo;
in {
  flake.modules.nixos.x570 = {
    # Default Nixos will have standard priority, force to override
    # environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;

    services.frr.config = ''
      ip forwarding
      ipv6 forwarding

      ip prefix-list 64800-IN seq 5 permit 192.168.64.0/20
      ip prefix-list 64800-IN seq 10 deny 0.0.0.0/0
      ip prefix-list 64800-OUT seq 5 permit ${lo.ipv4}
      ip prefix-list 64800-OUT seq 10 deny 0.0.0.0/0

      router ospf
        router-id ${lo.ipv4}

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

      int enp6s0
        ip ospf cost 1000
        ip ospf area 0

      int enp7s0
        ip ospf cost 400
        ip ospf area 0

      int enx10p1
        ip ospf cost 100
        ip ospf area 0
    '';

    networking = {
      ospf = {
        defaultRoute = {
          metricType = 1;
          metric = 550;
        };
      };
      firewall.allowedUDPPorts = [3784 3785];
    };

    services.frr = {
      bfdd.enable = true;
    };
  };
}
