{
  flake.nixosConfigurations.x570.routing = {config, ...}: let
    inherit (builtins) head getAttr toString;
    lo = getAttr "address" (head config.networking.interfaces.lo.ipv4.addresses);
    loPrefix = toString (getAttr "prefixLength" (head config.networking.interfaces.lo.ipv4.addresses));
  in {
    # Default Nixos will have standard priority, force to override
    # environment.etc."frr/frr.conf".source = lib.mkForce config.age.secrets.frr.path;

    services.frr.config = ''
      ip forwarding
      ipv6 forwarding

      ip route 192.168.48.0/20 blackhole 250

      router ospf
        router-id ${lo}

      router eigrp 1
        network 192.168.50.32/27
        network ${lo}/${loPrefix}

      router bgp 65100
        no bgp ebgp-requires-policy
        neighbor 192.168.240.241 remote-as 64800

        address-family ipv4
          network 192.168.48.0/20
          neighbor 192.168.240.241 activate
        exit

      int lo
        ip ospf passive
        ip ospf area 0

      int enp7s0
        ip ospf cost 400
        ip ospf area 0
        ip ospf bfd

      int enp8s0
        ip ospf cost 100
        ip ospf area 0
        ip ospf bfd

      bfd
       peer 192.168.48.31
       peer 192.168.48.32
       peer 192.168.48.33
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
